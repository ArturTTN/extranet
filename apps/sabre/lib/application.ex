defmodule Sabre.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      supervisor(Task.Supervisor,
        [[name: Sabre.Task.Supervisor]],
        [restart: :transient])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sabre.Supervisor]
    Supervisor.start_link(children, opts)
  end
end