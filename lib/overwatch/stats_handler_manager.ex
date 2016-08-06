defmodule Overwatch.StatsHandlerManager do
  use GenServer

  defmodule State do
    defstruct handler: nil, args: [], event_manager: nil, monitor_ref: nil
  end

  def start_link(event_manager, handler, args \\ []) do
    GenServer.start_link(__MODULE__,
      [event_manager, handler, args], name: handler)
  end

  def remove_handler(handler, args) do
    GenServer.cast(handler, {:remove_handler, handler, args})
  end

  def init([event_manager, handler, args]) do
    monitor_ref = Process.monitor(event_manager)
    state = %State{event_manager: event_manager,
                   handler: handler,
                   args: args}
    {:ok, ^event_manager} =
      start_handler(state)
    {:ok, %State{state|monitor_ref: monitor_ref}}
  end

  def handle_cast({:remove_handler, handler, args},
    %State{event_manager: event_manager,
           monitor_ref: monitor_ref,
           handler: handler,
           args: args} = state) do
    :ok = GenEvent.remove_handler(event_manager, handler, args)
    Process.demonitor(monitor_ref)
    {:stop, :normal, state}
  end

  def handle_info({:DOWN, _ref, :process, {_event_manager, _node}, _reason}, state) do
    {:stop, :event_manager_down, state}
  end

  def handle_info({:gen_event_EXIT, handler, _reason},
    %State{event_manager: event_manager, handler: state_handler} =   state) do
    ^state_handler = handler
    {:ok, ^event_manager} = start_handler(state)
    {:noreply, state}
  end

  defp start_handler(
    %State{event_manager: event_manager,
           handler: handler,
           args: args}) do
    case GenEvent.add_mon_handler(event_manager, handler, args) do
      :ok -> {:ok, event_manager}
      {:error, reason} -> {:stop, reason}
    end
  end
end
