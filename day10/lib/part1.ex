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

  def get_next_pipe(map, starting_coords) do
    {starting_x, starting_y} = starting_coords
    starting_char = String.at(Enum.at(map, starting_y), starting_x)

    # Get surroundings
    starting_coords
    |> get_surrounding_coordinates()
    |> Enum.zip([:north, :east, :south, :west])
    # Find the first connectable pipe in surroundings
    |> Enum.reduce_while({}, fn pipe_coordinate_with_direction, acc ->
      {pipe_coordinate, direction} = pipe_coordinate_with_direction
      {pipe_x, pipe_y} = pipe_coordinate

      pipe_char = String.at(Enum.at(map, pipe_y), pipe_x)

      IO.inspect("Pipe 1 #{starting_char} at #{starting_x}, #{starting_y}\n
      Pipe 2 #{pipe_char} at #{pipe_x}, #{pipe_y}\n
      Connects in #{direction}? #{connectable?(starting_char, pipe_char, direction)}")

      if connectable?(starting_char, pipe_char, direction) do

        {:halt, pipe_coordinate}
      else
        {:cont, {}}
      end
    end)
  end
end
