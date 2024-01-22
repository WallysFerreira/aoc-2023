defmodule Day9Part1 do
  def get_differences(arr) do
    arr
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&(Enum.at(&1, 1) - Enum.at(&1, 0)))
  end
end
