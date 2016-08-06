defmodule Overwatch.Drain do

  @callback update(String.t, Float | Integer) :: any

  def update(metric, value) do
    drains = Application.get_env(:overwatch, :drains, [])

    drains
    |> Enum.map(fn drain -> drain.update(metric, value) end)
  end

end
