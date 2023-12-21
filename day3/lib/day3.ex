defmodule Day3 do
  @moduledoc """
  Documentation for `Day3`.
  """

  @doc """
  Hello world.

  ## To-do list
  - [x] Create a list with the symbols
  - [x] Get starting and ending coordinates of a number
  - [x] Put all characters around the number into a list
  - [x] Check if any characters in the list match the symbols and, if so, put the number into a list
  - [x] Sum all numbers in the list
  """

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

  def get_number_objects(lines) do
    filtered_numbers = Enum.map(lines, fn line ->
      {contents, line_number} = line
      numbers_list = filter_and_add_index(contents)

      number_object = %{
        value: "",
        line: line_number,
        start_index: -1,
        end_index: -1,
      }

      {numbers, _, _, _, _} = numbers_list |> Enum.reduce({[], number_object, -2, "", -1}, fn number_with_index, acc ->
        {num, idx} = number_with_index
        {numbers, this_number, last_index, number_value, start_index} = acc

        case Enum.find(numbers_list, fn num_tuple ->
          {_, indx} = num_tuple
          indx == idx + 1
        end) do
          {_next_num, _next_index} ->
            {numbers, this_number, idx, number_value <> num, if start_index == -1 do idx else start_index end}
          nil ->
            this_number = Map.replace(number_object, :value, number_value <> num)
            this_number = Map.replace(this_number, :end_index, last_index + 1)
            this_number = Map.replace(this_number, :start_index, start_index)

            {[this_number | numbers], number_object, -2, "", -1}
        end
      end)

      numbers |> Enum.filter(fn number_obj ->
        String.length(number_obj.value) > 0
      end)
    end)

    Enum.concat(filtered_numbers)
  end

  def at_line_start?(number_obj) do
    number_obj.start_index == 0
  end

  def at_line_end?(number_obj, lines) do
    with {string, _} = Enum.at(lines, number_obj.line) do
      number_obj.end_index == String.length(string) - 1
    end
  end

  def get_surroundings(number_obj, lines) do
    lines_indexes = cond do
      number_obj.line == 0 -> [number_obj.line + 1]
      number_obj.line == length(lines) - 1 -> [number_obj.line - 1]
      true -> [number_obj.line - 1, number_obj.line + 1]
    end

    char_indexes = cond do
      at_line_start?(number_obj) && at_line_end?(number_obj, lines) -> Enum.to_list(number_obj.start_index..number_obj.end_index)
      at_line_start?(number_obj) -> Enum.to_list(number_obj.start_index..number_obj.end_index + 1)
      at_line_end?(number_obj, lines) -> Enum.to_list(number_obj.start_index - 1..number_obj.end_index)
      true -> Enum.to_list(number_obj.start_index - 1..number_obj.end_index + 1)
    end

    found_chars = Enum.concat(Enum.map(lines_indexes, fn line_index ->
      with {string, _} = Enum.at(lines, line_index) do
        chars = String.split(string, "", trim: true)
        char_indexes |> Enum.map(&Enum.at(chars, &1))
      end
    end))

    with {string, _} = Enum.at(lines, number_obj.line) do
      chars = String.split(string, "", trim: true)
      Enum.concat(found_chars, [Enum.at(chars, List.first(char_indexes)), Enum.at(chars, List.last(char_indexes))])
    end
  end

  def is_next_to_symbol?(number, lines) do
      get_surroundings(number, lines) |> Enum.any?(fn char ->
        case Integer.parse(char) do
          :error -> char != "."
          {_num, ""} -> false
        end
      end)
  end

  def solve_part_1(path) do
    lines = Enum.with_index(read_file(path))
    numbers = lines |> get_number_objects()

    numbers_next_to_symbols = Enum.filter(numbers, fn number -> is_next_to_symbol?(number, lines) end)

    numbers_next_to_symbols |> Enum.map(&IO.inspect/1)

    numbers_next_to_symbols |> Enum.reduce(0, fn number_obj, sum ->
      sum + String.to_integer(number_obj.value)
    end)
  end
end
