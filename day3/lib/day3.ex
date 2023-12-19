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

  def filter_and_add_index(line) do
    Enum.with_index(String.split(line, "", trim: true)) |> Enum.filter(fn char_with_index ->
      {char, _} = char_with_index

      case Integer.parse(char) do
        {_num, ""} -> true
        :error -> false
      end
    end)
  end

  def get_numbers_in_line(line) do
    {_, numbers_in_line} = filter_and_add_index(line) |> Enum.reduce({-1, ""}, fn number_with_index, acc ->
      {num, idx} = number_with_index
      {last_index, numbers} = acc

      cond do
        idx != last_index + 1 ->
          {idx, numbers <> " " <> num}
        true ->
          {idx, numbers <> num}
      end
    end)

    String.split(numbers_in_line, " ", trim: true) |> Enum.map(&String.to_integer(&1))
  end

  def get_number(line) do
    get_numbers_in_line(line)
  end

  def solve_part_1(path) do
    read_file(path) |> Enum.map(&get_number(&1))
  end
end
