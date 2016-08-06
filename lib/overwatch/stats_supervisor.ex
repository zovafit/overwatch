defmodule Overwatch.StatsSupervisor do
  use Supervisor
  defmodule Spec do
    import Supervisor.Spec, warn: false

    def gen_event_supervisor(name, event_handlers \\ []) do
      supervisor(Overwatch.StatsSupervisor, [name, event_handlers])
    end

    def event_handler(name, args \\ []) do
      {name, args}
    end
  end

  def start_link(event_manager, handlers) do
    Supervisor.start_link(__MODULE__, [event_manager, handlers], name: __MODULE__)
  end

  def init([event_manager, handlers]) do
    handlers = for {handler, args} <- handlers do
      worker(Overwatch.StatsHandlerManager, [event_manager, handler, []], id: handler, restart: :transient)
    end
    children = [worker(event_manager, []), worker(Overwatch.Stats.Timer, [event_manager, []])|handlers]
    supervise(children, [strategy: :one_for_one])
  end
end
