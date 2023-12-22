defmodule Day4 do
  @moduledoc """
  Documentation for `Day4`.
  """

  @doc """

  # Part 1

  ## Info for part 1
  The numbers before the "|" character is the list of winning numbers, the numbers after the character is the list of card numbers.
  Scoring is based on the number of matches between the lists.
  To calculate the total of points in a card use the formula 2^(x - 1), where x is the number of matches.
  The answer to the puzzle is the sum of the points in all cards.

  ## Part 1 to-do list
  - [x] Split winning numbers list and card numbers list
  - [x] Count how many numbers appear in both lists
  - [x] Use the formula to calculate amount of points in the card
  - [x] Sum points in all cards


  # Part 2

  ## Info for part 2
  Cards have instances.
  Each matching number on a card gives one copy (instance) of the next cards.

  ## Part 2 to-do list
  - [x] Add field instances to card object, starting with 1 (the original card)
  - [x] Propagate each match on a card object to the adding one instance to the subsequent cards on the list
  - [x] Sum instances of all cards
  """

  def read_file(path) do
    {:ok, contents} = File.read(path)
    contents |> String.split("\n", trim: true)
  end

  def split_lists(line) do
    clean_line = Regex.replace(~r/Card[\s]+[\d]+: /, line, "")

    card_number = Enum.at(Enum.at(Regex.scan(~r/[\d]+/, line), 0), 0)

    with lists_as_string = clean_line |> String.split(" | ", trim: true) do
      lists =
        lists_as_string
        |> Enum.map(fn number_as_string ->
          String.split(number_as_string, " ", trim: true)
          |> Enum.map(&String.to_integer/1)
        end)

      {Enum.at(lists, 0), Enum.at(lists, 1), String.to_integer(card_number)}
    end
  end

  def create_card_object(lists_tuple) do
    {winning_list, card_list, card_number} = lists_tuple

    %{
      id: card_number,
      winning_list: winning_list,
      list: card_list,
      matches: [],
      number_of_matches: nil,
      points: nil,
      instances: 1,
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

  def propagate_matches_to_instances(card, cards_list) do
    card_index = cards_list
    |> Enum.find_index(fn x -> x == card end)

    indexes_to_propagate =
      if card.number_of_matches > 0 do
        Enum.to_list(card_index + 1..card_index + card.number_of_matches)
        |> Enum.reject(&(&1 >= length(cards_list)))
      else
        []
      end

    indexes_to_propagate
    |> Enum.reduce(cards_list, fn index_to_propagate, old_list ->
      card_to_update = Enum.at(old_list, index_to_propagate)

      updated_card = Map.update!(card_to_update, :instances, fn instances ->
        instances + card.instances
      end)

      old_list
      |> List.replace_at(index_to_propagate, updated_card)
    end)
  end

  def solve_part_2(path) do
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

    {updated_cards, _} =
      cards
      |> Enum.reduce({cards, 1}, fn card, acc ->
        {old_list, times_ran} = acc

        card_to_use = if times_ran == 1 do
          card
        else
          Enum.find(old_list, &(&1.id == card.id))
        end

        {propagate_matches_to_instances(card_to_use, old_list), times_ran + 1}
      end)

    updated_cards
    |> Enum.reduce(0, fn card, sum -> sum + card.instances end)
  end
end
