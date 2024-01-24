defmodule Part1 do
  def read_file(path) do
    {:ok, contents} = File.read(path)

    contents
    |> String.split("\n", trim: true)
  end

  def connectable?(pipe1, pipe2, position_of_pipe2) do
    connects_with_north = ["|", "L", "J", "S"]
    connects_with_east = ["-", "L", "F", "S"]
    connects_with_south = ["|", "7", "F", "S"]
    connects_with_west = ["-", "7", "J", "S"]

    cond do
      position_of_pipe2 == :north ->
        if Enum.member?(connects_with_north, pipe1) do
          Enum.member?(connects_with_south, pipe2)
        else
          false
        end

      position_of_pipe2 == :south ->
        if Enum.member?(connects_with_south, pipe1) do
          Enum.member?(connects_with_north, pipe2)
        else
          false
        end

      position_of_pipe2 == :east ->
        if Enum.member?(connects_with_east, pipe1) do
          Enum.member?(connects_with_west, pipe2)
        else
          false
        end

      position_of_pipe2 == :west ->
        if Enum.member?(connects_with_west, pipe1) do
          Enum.member?(connects_with_east, pipe2)
        else
          false
        end
    end
  end

  def find_start(lines) do
    lines
    |> Enum.map(&String.codepoints(&1))
    |> Enum.with_index()
    |> Enum.reduce_while(0, fn chars_with_index, _acc ->
      {chars, idx} = chars_with_index

      x = chars
      |> Enum.find_index(&(&1 == "S"))

      if x == nil do
        {:cont, 0}
      else
        {:halt, {x, idx}}
      end
    end)
  end

  def get_surrounding_coordinates(coordinates) do
    {original_x, original_y} = coordinates

    north = [original_x, original_y - 1]
    east = [original_x + 1, original_y]
    south = [original_x, original_y + 1]
    west = [original_x - 1, original_y]

    [
      if Enum.any?(north, &(&1 < 0)) do
        nil
      else
        List.to_tuple(north)
      end,
      if Enum.any?(east, &(&1 < 0)) do
        nil
      else
        List.to_tuple(east)
      end,
      if Enum.any?(south, &(&1 < 0)) do
        nil
      else
        List.to_tuple(south)
      end,
      if Enum.any?(west, &(&1 < 0)) do
        nil
      else
        List.to_tuple(west)
      end
    ]
  end

  def get_next_pipe(map, starting_coords, excluded_coords \\ []) do
    {starting_x, starting_y} = starting_coords
    starting_char = String.at(Enum.at(map, starting_y), starting_x)

    # Get surroundings
    starting_coords
    |> get_surrounding_coordinates()
    |> Enum.zip([:north, :east, :south, :west])
    # Find the first connectable pipe in surroundings
    |> Enum.reject(fn coord_with_dir ->
      {coord, _dir} = coord_with_dir

      coord == nil
    end)
    |> Enum.reduce_while(nil, fn pipe_coordinate_with_direction, _acc ->
      {pipe_coordinate, direction} = pipe_coordinate_with_direction
      {pipe_x, pipe_y} = pipe_coordinate

      pipe_char =
        if pipe_y >= length(map) do
          "."
        else
          if pipe_x > String.length(Enum.at(map, pipe_y)) do
            "."
          else
            String.at(Enum.at(map, pipe_y), pipe_x)
          end
        end

      should_be_excluded? =
        if is_list(Enum.at(excluded_coords, 0)) do
          excluded_coords
          |> Enum.map(&Enum.member?(&1, pipe_coordinate))
          |> Enum.any?()
        else
          Enum.member?(excluded_coords, pipe_coordinate)
        end

      if should_be_excluded? do
        {:cont, nil}
      else
        if connectable?(starting_char, pipe_char, direction) do
          {:halt, pipe_coordinate}
        else
          {:cont, nil}
        end
      end
    end)
  end

  def get_loop_path(file_path) do
    lines = read_file(file_path)
    starting_coordinates = find_start(lines)

    Stream.cycle(0..1)
    |> Enum.reduce_while({[], starting_coordinates}, fn _, acc ->
      {path_till_now, current_coordinates} = acc

      next_coordinates = get_next_pipe(lines, current_coordinates, path_till_now)

      if next_coordinates == starting_coordinates do
        {:halt, path_till_now}
      else
        {:cont, {List.insert_at(path_till_now, -1, next_coordinates), next_coordinates}}
      end
    end)
  end

  def get_loop_paths(file_path) do
    lines = read_file(file_path)
    starting_coordinates = find_start(lines)

    Stream.cycle(0..1)
    |> Enum.reduce_while({[[], []], {starting_coordinates, starting_coordinates}}, fn _, acc ->
      {path_till_now, current_coordinates} = acc
      {curr_coords_1, curr_coords_2} = current_coordinates

      excluded_coords =
        path_till_now
        |> Enum.map(&List.insert_at(&1, 0, starting_coordinates))

      next_coords_1 = get_next_pipe(lines, curr_coords_1, excluded_coords)
      path_till_now = [Enum.at(path_till_now, 0) |> List.insert_at(-1, next_coords_1), Enum.at(path_till_now, 1)]

      excluded_coords =
        path_till_now
        |> Enum.map(&List.insert_at(&1, 0, starting_coordinates))

      next_coords_2 = get_next_pipe(lines, curr_coords_2, excluded_coords)
      path_till_now =
      if next_coords_2 == nil do
        [Enum.at(path_till_now, 0), Enum.at(path_till_now, 1) |> List.insert_at(-1, next_coords_1)]
      else
        [Enum.at(path_till_now, 0), Enum.at(path_till_now, 1) |> List.insert_at(-1, next_coords_2)]
      end

      if next_coords_2 == nil do
        {:halt, path_till_now}
      else
        {:cont, {path_till_now, {next_coords_1, next_coords_2}}}
      end
    end)
  end

  def find_farthest_point(file_path) do
    get_loop_paths(file_path)
    |> Enum.at(0)
    |> length()
  end
end
