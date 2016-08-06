defmodule Overwatch.Drain.Logger do
  require Logger
  @behaviour Overwatch.Drain

  def update(metric, value) do
    Logger.info "Update to #{metric}: #{value}"
  end
end
