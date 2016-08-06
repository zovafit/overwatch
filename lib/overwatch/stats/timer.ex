defmodule Overwatch.Stats.Timer do
  use GenServer
  require Logger

  def start_link(event_manager, args \\ []) do
    GenServer.start_link(__MODULE__, [event_manager, args], name: __MODULE__)
  end

  def init([event_manager, args]) do
    Logger.info "Y U NO INIT #####"
    Process.send_after(__MODULE__, :tick, 1000)
    {:ok, event_manager}
  end


  def handle_info(:tick, event_manager) do
    Logger.info "Sending tick"
    GenEvent.notify(event_manager, :tick)
    Process.send_after(__MODULE__, :tick, 5000)
    {:noreply, event_manager}
  end
end
