defmodule Overwatch.Stats.DiskHandler do
  use GenEvent

  def handle_event(:tick, state) do
    {:ok, state}
  end
end
