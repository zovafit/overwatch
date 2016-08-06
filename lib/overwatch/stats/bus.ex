defmodule Overwatch.Stats.Bus do
  use GenServer
  def start_link() do
    manager = GenEvent.start_link(name: __MODULE__)
  end
end
