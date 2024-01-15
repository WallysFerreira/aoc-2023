defmodule Day7Part2Test do
  use ExUnit.Case

  @example_path "files/example"

  test "extracts hand and bid info" do
    assert Day7Part2.get_info(@example_path) == [
      %{hand: ["3", "2", "T", "3", "K"], bid: 765},
      %{hand: ["T", "5", "5", "J", "5"], bid: 684},
      %{hand: ["K", "K", "6", "7", "7"], bid: 28},
      %{hand: ["K", "T", "J", "J", "T"], bid: 220},
      %{hand: ["Q", "Q", "Q", "J", "A"], bid: 483}
    ]
  end

  describe "gets hand type" do
    test "five of a kind" do assert Day7Part2.get_hand_type(String.split("AAAAA", "", trim: :true)) == "Five of a kind" end
    test "four of a kind" do assert Day7Part2.get_hand_type(String.split("AA8AA", "", trim: :true)) == "Four of a kind" end
    test "full house" do assert Day7Part2.get_hand_type(String.split("23332", "", trim: :true)) == "Full house" end
    test "three of a kind" do assert Day7Part2.get_hand_type(String.split("TTT98", "", trim: :true)) == "Three of a kind" end
    test "two pair" do assert Day7Part2.get_hand_type(String.split("23432", "", trim: :true)) == "Two pair" end
    test "one pair" do assert Day7Part2.get_hand_type(String.split("A23A4", "", trim: :true)) == "One pair" end
    test "high card" do assert Day7Part2.get_hand_type(String.split("23456", "", trim: :true)) == "High card" end
    test "five of a kind with joker" do assert Day7Part2.get_hand_type(String.split("QJJQQ", "", trim: :true)) == "Five of a kind" end
    test "five of a kind with all jokers" do assert Day7Part2.get_hand_type(String.split("JJJJJ", "", trim: :true)) == "Five of a kind" end
    test "four of a kind with joker" do assert Day7Part2.get_hand_type(String.split("QJJQ2", "", trim: :true)) == "Four of a kind" end
    test "full house with joker" do assert Day7Part2.get_hand_type(String.split("44J22", "", trim: :true)) == "Full house" end
    test "three of a kind with joker" do assert Day7Part2.get_hand_type(String.split("4JJT2", "", trim: :true)) == "Three of a kind" end
  end

  describe "compares cards" do
    test "A and 2" do
      assert Day7Part2.compare("A", "2") == :first
      assert Day7Part2.compare("2", "A") == :second
    end

    test "J and T" do
      assert Day7Part2.compare("J", "T") == :second
      assert Day7Part2.compare("T", "J") == :first
    end

    test "8 and 6" do
      assert Day7Part2.compare("8", "6") == :first
      assert Day7Part2.compare("6", "8") == :second
    end

    test "3 and 3" do
      assert Day7Part2.compare("3", "3") == :equal
    end
  end

  describe "compares hands" do
    test "AAAAA and 23456" do
      assert Day7Part2.compare(String.split("AAAAA", "", trim: :true), String.split("23456", "", trim: :true)) == :first
      assert Day7Part2.compare(String.split("23456", "", trim: :true), String.split("AAAAA", "", trim: :true)) == :second
    end

    test "33332 and 2AAAA" do
      assert Day7Part2.compare(String.split("33332", "", trim: :true), String.split("2AAAA", "", trim: :true)) == :first
      assert Day7Part2.compare(String.split("2AAAA", "", trim: :true), String.split("33332", "", trim: :true)) == :second
    end

    test "77888 and 77788" do
      assert Day7Part2.compare(String.split("77888", "", trim: :true), String.split("77788", "", trim: :true)) == :first
      assert Day7Part2.compare(String.split("77788", "", trim: :true), String.split("77888", "", trim: :true)) == :second
    end

    test "KK677 and KTJJT" do
      assert Day7Part2.compare(String.split("KK677", "", trim: :true), String.split("KTJJT", "", trim: :true)) == :second
      assert Day7Part2.compare(String.split("KTJJT", "", trim: :true), String.split("KK677", "", trim: :true)) == :first
    end

    test "QQQJA and T55J5" do
      assert Day7Part2.compare(String.split("QQQJA", "", trim: :true), String.split("T55J5", "", trim: :true)) == :first
      assert Day7Part2.compare(String.split("T55J5", "", trim: :true), String.split("QQQJA", "", trim: :true)) == :second
    end
  end

  test "ranks hands" do
    hands = Day7Part2.get_info(@example_path)

    assert Day7Part2.rank_hands(hands) == [
      %{hand: ["3", "2", "T", "3", "K"], bid: 765, rank: 1},
      %{hand: ["T", "5", "5", "J", "5"], bid: 684, rank: 3},
      %{hand: ["K", "K", "6", "7", "7"], bid: 28, rank: 2},
      %{hand: ["K", "T", "J", "J", "T"], bid: 220, rank: 5},
      %{hand: ["Q", "Q", "Q", "J", "A"], bid: 483, rank: 4}
    ]
  end

  test "calculates total winnings" do
    hands = Day7Part2.get_info(@example_path)

    assert Day7Part2.get_total_winnings(hands) == 5905
  end
end
