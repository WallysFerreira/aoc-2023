defmodule Part1 do
  def read_file(path) do
    {:ok, contents} = File.read(path)

    contents
    |> String.split("\n", trim: true)
  end

  def connectable?(pipe1, pipe2, position_of_pipe1) do
    connects_with_north = ["|", "L", "J", "S"]
    connects_with_south = ["|", "7", "F", "S"]
    connects_with_east = ["-", "L", "F", "S"]
    connects_with_west = ["-", "7", "J", "S"]

    cond do
      position_of_pipe1 == :north ->
        if Enum.member?(connects_with_north, pipe1) do
          Enum.member?(connects_with_north, pipe2)
        else
          false
        end

      position_of_pipe1 == :south ->
        if Enum.member?(connects_with_south, pipe1) do
          Enum.member?(connects_with_south, pipe2)
        else
          false
        end

      position_of_pipe1 == :east ->
        if Enum.member?(connects_with_east, pipe1) do
          Enum.member?(connects_with_east, pipe2)
        else
          false
        end

      position_of_pipe1 == :west ->
        if Enum.member?(connects_with_west, pipe1) do
          Enum.member?(connects_with_west, pipe2)
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
end
