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
  - [x] Use the formula to calculate amount of points in the card
  - [ ] Sum points in all cards
  """

  def read_file(path) do
    {:ok, contents} = File.read(path)
    contents |> String.split("\n", trim: true)
  end

  def split_lists(line) do
    clean_line = Regex.replace(~r/Card[\s]+[\d]+: /, line, "")

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

  def create_card_object(lists_tuple) do
    {winning_list, card_list} = lists_tuple

    %{
      winning_list: winning_list,
      list: card_list,
      matches: [],
      number_of_matches: nil,
      points: nil
    }
  end

  def get_matches(card_object) do
    card_object = Map.replace(card_object, :matches, card_object.list
    |> Enum.filter(fn card_number ->
      Enum.any?(card_object.winning_list, fn x -> x == card_number end)
    end))

    Map.replace(card_object, :number_of_matches, length(card_object.matches))
  end

  def calculate_points(card_object) do
    Map.replace(card_object, :points, cond do
      card_object.number_of_matches == 0 -> 0
      true -> Integer.pow(2, card_object.number_of_matches - 1)
    end)
  end

  def solve_part_1(path) do
    lists = read_file(path) |> Enum.map(&split_lists/1)

    cards =
      lists
      |> Enum.map(&create_card_object/1)

    cards =
      cards
      |> Enum.map(&get_matches/1)

    cards =
      cards
      |> Enum.map(&calculate_points/1)

    Enum.reduce(cards, 0, fn card_object, points_sum -> points_sum + card_object.points end)
  end
end
