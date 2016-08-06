defmodule Overwatch do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    import Overwatch.StatsSupervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      gen_event_supervisor(Overwatch.Stats.Bus, [
            event_handler(Overwatch.Stats.MemoryHandler, []),
            event_handler(Overwatch.Stats.CPUHandler, []),
            event_handler(Overwatch.Stats.DiskHandler, [])
          ]
      )
      # Starts a worker by calling: Overwatch.Worker.start_link(arg1, arg2, arg3)
      # worker(Overwatch.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Overwatch.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
