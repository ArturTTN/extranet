defmodule SessionManager.Session do

  defstruct token: "",
            driver: nil,
            id: ""

  require Logger
  use GenServer

  @process_lifetime_ms 5_000


  def init([%{id: id, token: token} = session, driver]) do

    Process.send_after(self(), :init_close, @process_lifetime_ms)

    {:ok, %__MODULE__{
      token: token,
      driver: driver,
      id: id}
    }
  end

  def handle_call(:get, _from, state) do
    {:reply, Map.fetch(state, :token), state}
  end

  def handle_info(:init_close, state) do

    with %__MODULE__{driver: driver, token: token, id: id} <- state,
          true <- SessionManager.cleanup( driver.ipcc, token )
    do
      Process.send_after(self(), :close_session, @process_lifetime_ms)
    end

    {:noreply, state}
  end

  def handle_info(:close_session, %__MODULE__{driver: driver, token: token, id: id} = state) do

    %{driver | token: token, id: id}
      |> SessionManager.Protocol.close_session()

    {:stop, :normal, state}
  end


  ### api

  def create_session(driver) do

    office_id = driver.ipcc

    result = driver
      |> SessionManager.Protocol.create_session()
      |> _start_process(driver)

    result
  end


  def get_session(pid) do
    pid
      |> GenServer.call(:get)
  end

  defp _start_process({:ok, session}, driver), do: GenServer.start_link(__MODULE__, [session, driver])
  defp _start_process(session_data, _), do: session_data



end