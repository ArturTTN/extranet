defmodule NodeInterface.Sabre do
  defstruct [:driver, :ipcc, :username, :password, :timer]
end


defimpl NodeInterface.Protocol, for: NodeInterface.Sabre do

  def search(requester) do
    NodeInterface.spawn_task(
      Sabre.Interfaces.Search,
      :get_data,
      [requester],
      {Sabre.Task.Supervisor, Application.get_env(:node_interface, :sabre_node)})
  end
end