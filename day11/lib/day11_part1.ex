defmodule Day11Part1 do
  def read_file(path) do
    {:ok, contents} = File.read(path)

    contents
    |> String.split("\n", trim: true)
  end
end
