defmodule Overwatch.Drain.Elixometer do
  use Elixometer

  def update(metric, value) do
    update_gauge(metric, value)
  end
end
