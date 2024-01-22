defmodule Day9Part1 do
  def read_file(path) do
    {:ok, contents} = File.read(path)

    contents
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: :true)
      |> Enum.map(&String.to_integer(&1))
    end)
  end

  def get_differences(arr) do
    arr
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&(Enum.at(&1, 1) - Enum.at(&1, 0)))
  end
end
