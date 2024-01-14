defmodule Day7Part1 do
  def read_file(path) do
    {:ok, contents} = File.read(path)

    contents
    |> String.split("\n", trim: true)
  end

  def get_info(path) do
    read_file(path)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(&%{
      hand: String.split(Enum.at(&1, 0), "", trim: :true),
      bid: String.to_integer(Enum.at(&1, 1))
    })
  end
end
