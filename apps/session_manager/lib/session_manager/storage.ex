defmodule SessionManager.Storage do

  require Logger
  use GenServer


  @account_registry_name :session_storage

  def start_link(storage_name) do
    GenServer.start_link(__MODULE__, [], name: via_tuple(storage_name))
  end

  def init([]) do
    {:ok, []}
  end

  defp via_tuple(storage_name), do: {:via, Registry, {@account_registry_name, storage_name}}

  def handle_call(:pop, _from, [h | t]) do
    {:reply, h, t}
  end

  def handle_call(:pop, _from, state), do: {:reply, nil, state}

  def handle_call(:list, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:push, session_pid}, state) do
    {:noreply, state ++ [session_pid]}
  end


  #### api ####

  def list_session(storage_name) do
    GenServer.call(via_tuple(storage_name), :list)
  end

  def pop_session(storage_name) do
    GenServer.call(via_tuple(storage_name), :pop)
  end

  def push_session(storage_name, session_pid) do
    GenServer.cast(via_tuple(storage_name), {:push, session_pid})
  end


end