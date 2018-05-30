defmodule SessionManager do
  use GenServer

  @ets_table :session

  def start_link(), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def init(args) do
      :ets.new(@ets_table, [:set, :public, :named_table, {:read_concurrency, true}])
      {:ok, args}
  end

  def handle_call({:push, token, office_id, timer}, _from, state) do

    with  {_, sessions} <- lookup(office_id),
          sessions <- (sessions ++ [token])
    do
      {_, token} = case :ets.insert(@ets_table, {office_id, sessions}) do
        true -> lookup(office_id)
        false -> {:ok, [token]}
      end

      {:reply, {:ok, token}, state}
    end
  end



  ###### api
  def set_session({:error, msg}, office_id, timer) do
    [{:error, msg}]
  end

  def set_session({:ok, pid}, office_id, timer) do

    pid
      |> SessionManager.Session.get_session()
      |> store_token(office_id, timer)
  end


  def store_token({:ok, token}, office_id, timer) do
    __MODULE__
      |> GenServer.call({:push, token, office_id, timer}, 10_000)
  end


  def get_session(driver) do


    office_id = driver.ipcc
    timer = driver.timer

    :timer.sleep(driver.timer);

    {_, sess_array} = lookup( office_id )

    {:ok, [session | _tail]} = case Kernel.length(sess_array) > 0 do
      false -> SessionManager.Session.create_session(driver)
                  |> SessionManager.set_session(office_id, timer)
      true -> {:ok, sess_array}
    end

    session

  end

  def cleanup(office_id, token) do
    with {_, sessions} <- lookup( office_id ),
          sessions <- sessions |>
                        List.delete(token)
    do
      :ets.insert(@ets_table, {office_id, sessions})
    end
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(name) do
    case :ets.lookup(@ets_table, name) do
      [{^name, data}] -> {:ok, data}
      [] -> {:empty, []}
    end
  end

end