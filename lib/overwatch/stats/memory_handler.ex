defmodule Overwatch.Stats.MemoryHandler do
  use GenEvent
  require Logger

  def handle_event(:tick, state) do
    :memsup.get_system_memory_data
    |> Enum.map(fn {key, value} -> Overwatch.Drain.update(key, value) end)
    {:ok, state}
  end
end
