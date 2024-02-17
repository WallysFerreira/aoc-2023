defmodule Day11Part1 do
  def read_file(path) do
    {:ok, contents} = File.read(path)

    contents
    |> String.split("\n", trim: true)
  end

  def remove_first_column(map) do
    map
    |> Enum.map(&String.slice(&1, 1..-1//1))
  end

  def get_columns(map) do
    cols_qnt = String.length(Enum.at(map, 0))

    {cols, _} =
      Enum.to_list(0..(cols_qnt - 1))
      |> Enum.reduce({[], map}, fn _, acc ->
        {cols, updated_map} = acc

        updated_cols =
          cols
          |> List.insert_at(
            -1,
            updated_map
            |> Enum.map(&String.first(&1))
          )

        {updated_cols, remove_first_column(updated_map)}
      end)

    cols
  end

  def expand(path) do
    read_file(path)
  end
end
