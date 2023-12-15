defmodule Day3 do
  @moduledoc """
  Documentation for `Day3`.
  """

  @doc """
  Hello world.

  ## To-do list
  - [x] Create a list with the symbols
  - [ ] Get starting and ending coordinates of a number
  - [ ] Put all characters around the number into a list
  - [ ] Check if any characters in the list match the symbols and, if so, put the number into a list
  - [ ] Sum all numbers in the list
  """

  @symbols ['#', '$', '*', '+']

  def read_file(path) do
    {:ok, contents} = File.read(path)
    contents |> String.split("\n", trim: true)
  end

  def get_number(line) do
    String.split(line, "", trim: true) |> Enum.map(fn char ->
      case Integer.parse(char) do
        {num, ""} -> IO.puts(num)
        :error -> IO.puts("going to next number")
      end

    end)

    IO.puts("going to next line")
  end

  def solve_part_1(path) do
    read_file(path) |> Enum.map(&get_number(&1))
  end
end
