defmodule Day7Part1 do
  def read_file(path) do
    {:ok, contents} = File.read(path)

    contents
    |> String.split("\n", trim: true)
  end

  def get_info(path) do
    read_file(path)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(&%{
      hand: String.split(Enum.at(&1, 0), "", trim: :true),
      bid: String.to_integer(Enum.at(&1, 1))
    })
  end

  def get_hand_type(hand) do
    matches = hand
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.frequencies()

    cond do
      Map.has_key?(matches, 5) -> "Five of a kind"
      Map.has_key?(matches, 4) -> "Four of a kind"
      Map.has_key?(matches, 3) -> if Map.has_key?(matches, 2) do "Full house" else "Three of a kind" end
      Map.has_key?(matches, 2) -> if Map.get(matches, 2) == 2 do "Two pair" else "One pair" end
      true -> "High card"
    end
  end

  # Returns 0 if cards are of equal strength. Otherwise returns the number of the strongest card
  def compare(card1, card2) when is_binary(card1) do
    cards_list = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]

    cond do
      Enum.find_index(cards_list, &(card1 == &1)) > Enum.find_index(cards_list, &(card2 == &1)) -> 1
      Enum.find_index(cards_list, &(card1 == &1)) < Enum.find_index(cards_list, &(card2 == &1)) -> 2
      true -> 0
    end
  end

  def compare(hand1, hand2) when is_list(hand1) do
    types_list = ["High card", "One pair", "Two pair", "Three of a kind", "Full house", "Four of a kind", "Five of a kind"]

    hand1_idx = Enum.find_index(types_list, &(get_hand_type(hand1) == &1))
    hand2_idx = Enum.find_index(types_list, &(get_hand_type(hand2) == &1))

    cond do
      hand1_idx == hand2_idx ->
        Enum.reduce_while(0..4, 0, fn idx, _ ->
          result = compare(Enum.at(hand1, idx), Enum.at(hand2, idx))

          if result != 0 do
            {:halt, result}
          else
            {:cont, result}
          end
        end)

      hand1_idx > hand2_idx -> 1
      hand1_idx < hand2_idx -> 2
    end
  end

  def rank_hands(hands) do
    Enum.reduce(0..4, [], fn idx, updated_hands ->
      {current_hand, remaining} = List.pop_at(hands, idx)

      rank =
        remaining
        |> Enum.reduce(0, fn opposing_hand, count ->
          if compare(current_hand.hand, opposing_hand.hand) == 1 do
            count + 1
          else
            count
          end
        end)

      [Map.put_new(current_hand, :rank, rank + 1) | updated_hands]
    end)
    |> Enum.reverse()
  end
end
