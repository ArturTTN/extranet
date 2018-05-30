defmodule NodeInterface do

  # def remote_call(module, fun, args, env \\ Mix.env) do
  #   do_remote_call({module, fun, args}, env)
  # end

  # def remote_node do
  #   Application.get_env(:node_interface, :node)
  # end

  # defp do_remote_call({module, fun, args}, :dev) do
  #   apply(module, fun, args)
  # end

  # defp do_remote_call({module, fun, args}, _) do
  #   :rpc.call(remote_node(), module, fun, args)
  # end


  def spawn_task(module, fun, args, supervisor) do
    do_spawn_task({module, fun, args}, supervisor)
  end

  defp do_spawn_task({module, fun, args}, supervisor) do
    # apply(module, fun, args)
    Task.Supervisor.async(supervisor, module, fun, args)
  end

end
