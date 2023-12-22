defmodule Day4 do
  @moduledoc """
  Documentation for `Day4`.
  """

  @doc """

  # General info
  The numbers before the "|" character is the list of winning numbers, the numbers after the character is the list of card numbers.
  Scoring is based on the number of matches between the lists.
  To calculate the total of points in a card use the formula 2^(x - 1), where x is the number of matches.
  The answer to the puzzle is the sum of the points in all cards.

  ## Part 1 to-do list
  - [x] Split winning numbers list and card numbers list
  - [x] Count how many numbers appear in both lists
  - [ ] Use the formula to calculate amount of points in the card
  - [ ] Sum points in all cards
  """

  def read_file(path) do
    {:ok, contents} = File.read(path)
    contents |> String.split("\n", trim: true)
  end

  def split_lists(line) do
    clean_line = Regex.replace(~r/Card [\d]+: /, line, "")

    with lists_as_string = clean_line |> String.split(" | ", trim: true) do
      lists =
        lists_as_string
        |> Enum.map(fn number_as_string ->
          String.split(number_as_string, " ", trim: true)
          |> Enum.map(&String.to_integer/1)
        end)

      {Enum.at(lists, 0), Enum.at(lists, 1)}
    end
  end

  def get_matches(lists_tuple) do
    {winning_list, card_list} = lists_tuple

    card_list
    |> Enum.filter(fn card_number ->
      Enum.any?(winning_list, fn x -> x == card_number end)
    end)
  end

  def solve_part_1(path) do
    lists = read_file(path) |> Enum.map(&split_lists/1)

    number_of_matches = lists
    |> Enum.map(&length(get_matches(&1)))
  end
end
