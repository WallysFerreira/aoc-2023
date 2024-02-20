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
    |> Enum.map(&to_string/1)
  end

  def expand_rows(map) do
    {final_map, _final_offset} =
      map
      |> Enum.with_index()
      |> Enum.reduce({map, 0}, fn tuple, acc ->
        {row, idx} = tuple
        {updated_map, offset} = acc

        if Enum.all?(String.split(row, "", trim: true), &(&1 == ".")) do
          {List.insert_at(updated_map, idx + offset, row), offset + 1}
        else
          acc
        end
      end)

    final_map
  end

  def expand_cols(map) do
    {final_map, _final_offset} =
      get_columns(map)
      |> Enum.with_index()
      |> Enum.reduce({map, 0}, fn tuple, acc ->
        {col, col_idx} = tuple
        {updated_map, offset} = acc

        if Enum.all?(String.split(col, "", trim: true), &(&1 == ".")) do
          updated_map =
            updated_map
            |> Enum.with_index()
            |> Enum.reduce(updated_map, fn row_tuple, updated_map ->
              {row, row_idx} = row_tuple

              new_row =
                row
                |> String.split("", trim: true)
                |> List.insert_at(col_idx + offset, ".")
                |> to_string()

              updated_map
              |> List.replace_at(row_idx, new_row)
            end)

          {updated_map, offset + 1}
        else
          acc
        end
      end)

    final_map
  end

  def expand(map) do
    map
    |> expand_rows()
    |> expand_cols()
  end

  def matches_to_galaxies(matches, galaxies_map, row_idx, galaxies_found_number) do
    matches
    |> Enum.with_index()
    |> Enum.reduce([], fn match, acc ->
      {match_tuple, match_number} = match

      {col_idx, _match_length} = match_tuple

      acc
      |> List.insert_at(-1, {
        galaxies_found_number + match_number,
        %{x: col_idx, y: row_idx}
      })
    end)
    |> Enum.reduce(galaxies_map, fn galaxy_tuple, acc ->
      {galaxy_number, galaxy_coords} = galaxy_tuple

      acc
      |> Map.put(galaxy_number, galaxy_coords)
    end)
  end

  def list_galaxies(map) do
    {found_galaxies, _} =
      map
      |> Enum.with_index()
      |> Enum.reduce_while({%{}, 1}, fn tuple, acc ->
        {row, row_idx} = tuple
        {found_galaxies, galaxies_found_number} = acc

        matches =
          Regex.scan(~r/#/, row, return: :index)
          |> List.flatten()

        if Enum.empty?(matches) do
          {:cont, {found_galaxies, galaxies_found_number}}
        else
          found_galaxies =
            matches
            |> matches_to_galaxies(found_galaxies, row_idx, galaxies_found_number)

          {:cont, {found_galaxies, galaxies_found_number + length(matches)}}
        end
      end)

    found_galaxies
  end

  def calculate_distance(galaxies, galaxy1, galaxy2) do
    galaxy1 =
      galaxies
      |> Map.get(galaxy1)

    galaxy2 =
      galaxies
      |> Map.get(galaxy2)

    abs(galaxy2.x - galaxy1.x) + abs(galaxy2.y - galaxy1.y)
  end

  def sum_distances(galaxies) do
    Map.keys(galaxies)
    |> Enum.map(fn current_galaxy_number ->
      Map.keys(galaxies)
      |> Enum.slice(current_galaxy_number..-1//1)
      |> Enum.map(&calculate_distance(galaxies, current_galaxy_number, &1))
      |> Enum.sum()
    end)
    |> Enum.sum()
  end
end
