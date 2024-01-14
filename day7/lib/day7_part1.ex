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

  def is_stronger?(card1, card2) do
    cards_list = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]

    Enum.find_index(cards_list, &(card1 == &1)) > Enum.find_index(cards_list, &(card2 == &1))
  end
end
