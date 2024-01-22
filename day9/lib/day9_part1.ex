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
        {:halt, differences}
      else
        {:cont, {current_dif, List.insert_at(differences, -1, current_dif)}}
      end
    end)
  end

  def get_next_values(list) do
    old_list =
      List.insert_at(find_all_differences(list), 0, list)
      |> Enum.reverse()

    old_list
    |> Enum.with_index()
    |> Enum.reduce(old_list, fn current, updated_lists ->
      {current_list, current_list_idx} = current

      dif_list =
        if current_list_idx == 0 do
          [0]
        else
          updated_lists
          |> Enum.at(current_list_idx - 1)
        end


      new_list =
        current_list
        |> List.insert_at(-1, List.last(dif_list) + List.last(current_list))

      List.replace_at(updated_lists, current_list_idx, new_list)
    end)
    |> Enum.reverse()
  end
end
