defmodule Overwatch.Stats.CPUHandler do
  use GenEvent
  alias Overwatch.Drain

  def handle_event(:tick, state) do
    ~w(avg1 avg5 avg15)a
    |> Enum.map(fn stat -> Drain.update(:"cpu_#{stat}", apply(:cpu_sup, stat, [])) end)
    {:ok, state}
  end
end
