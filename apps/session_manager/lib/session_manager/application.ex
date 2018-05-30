defmodule SessionManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec


  def start(_type, _args) do

    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: SessionManager.Worker.start_link(arg)
      # {SessionManager.Worker, arg},
      supervisor(Registry, [:unique, :session_storage], id: :session_storage),
      worker(SessionManager, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SessionManager.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
