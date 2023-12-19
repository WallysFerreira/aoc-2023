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
    numbers_list = filter_and_add_index(line)

    number_object = %{
      value: "",
      line: -1,
      start_index: -1,
      end_index: -1,
    }

    {numbers, _, _, _, _} = numbers_list |> Enum.reduce({[], number_object, -2, "", -1}, fn number_with_index, acc ->
      {_, length} = List.last(numbers_list)
      {num, idx} = number_with_index
      {numbers, this_number, last_index, number_value, start_index} = acc

      IO.puts("Current number: #{num}; Current Index: #{idx}; Last index: #{last_index}; First index: #{start_index}")

      cond do
        idx != last_index + 1 ->
          this_number = Map.replace(number_object, :value, number_value)
          this_number = Map.replace(this_number, :end_index, last_index)
          this_number = Map.replace(this_number, :start_index, start_index)
          {[this_number | numbers], number_object, idx, num, idx}
        idx == length ->
          this_number = Map.replace(number_object, :value, number_value <> num)
          this_number = Map.replace(this_number, :end_index, idx)
          this_number = Map.replace(this_number, :start_index, start_index)
          {[this_number | numbers], number_object, idx, "", -1}
        true ->
          {numbers, this_number, idx, number_value <> num, start_index}
      end

    end)

    numbers
  end

  def get_number(line) do
    get_numbers_in_line(line)
  end

  def solve_part_1(path) do
    read_file(path) |> Enum.map(&get_number(&1))
  end
end
