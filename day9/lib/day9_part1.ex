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

  def get_differences(list) do
    list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&(Enum.at(&1, 1) - Enum.at(&1, 0)))
  end

  def find_all_differences(list) do
    Stream.cycle(0..1)
    |> Enum.reduce_while({list, []}, fn _, acc ->
      {current_list, differences} = acc

      current_dif = get_differences(current_list)

      if Enum.all?(current_dif, fn elem -> elem == 0 end) do
        {:halt, List.insert_at(differences, -1, current_dif)}
      else
        {:cont, {current_dif, List.insert_at(differences, -1, current_dif)}}
      end
    end)
  end
end
