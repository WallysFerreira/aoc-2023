defmodule Day7Part1Test do
  use ExUnit.Case

  @example_path "files/example"

  test "extracts hand and bid info" do
    assert Day7Part1.get_info(@example_path) == [
      %{
        hand: ["3", "2", "T", "3", "K"],
        bid: 765
      },
      %{
        hand: ["T", "5", "5", "J", "5"],
        bid: 684
      },
      %{
        hand: ["K", "K", "6", "7", "7"],
        bid: 28
      },
      %{
        hand: ["K", "T", "J", "J", "T"],
        bid: 220
      },
      %{
        hand: ["Q", "Q", "Q", "J", "A"],
        bid: 483
      }
    ]
  end

  describe "gets hand type" do
    test "five of a kind" do assert Day7Part1.get_hand_type(String.split("AAAAA", "", trim: :true)) == "Five of a kind" end
    test "four of a kind" do assert Day7Part1.get_hand_type(String.split("AA8AA", "", trim: :true)) == "Four of a kind" end
    test "full house" do assert Day7Part1.get_hand_type(String.split("23332", "", trim: :true)) == "Full house" end
    test "three of a kind" do assert Day7Part1.get_hand_type(String.split("TTT98", "", trim: :true)) == "Three of a kind" end
    test "two pair" do assert Day7Part1.get_hand_type(String.split("23432", "", trim: :true)) == "Two pair" end
    test "one pair" do assert Day7Part1.get_hand_type(String.split("A23A4", "", trim: :true)) == "One pair" end
    test "high card" do assert Day7Part1.get_hand_type(String.split("23456", "", trim: :true)) == "High card" end
  end

  describe "compares cards" do
    test "A and 2" do
      assert Day7Part1.compare("A", "2") == 1
      assert Day7Part1.compare("2", "A") == 2
    end

    test "J and T" do
      assert Day7Part1.compare("J", "T") == 1
      assert Day7Part1.compare("T", "J") == 2
    end

    test "8 and 6" do
      assert Day7Part1.compare("8", "6") == 1
      assert Day7Part1.compare("6", "8") == 2
    end

    test "3 and 3" do
      assert Day7Part1.compare("3", "3") == 0
    end
  end

  describe "compares hands" do
    test "AAAAA and 23456" do
      assert Day7Part1.is_stronger?(String.split("AAAAA", "", trim: :true), String.split("23456", "", trim: :true)) == true
      assert Day7Part1.is_stronger?(String.split("23456", "", trim: :true), String.split("AAAAA", "", trim: :true)) == false
    end

    test "33332 and 2AAAA" do
      assert Day7Part1.is_stronger?(String.split("33332", "", trim: :true), String.split("2AAAA", "", trim: :true)) == true
      assert Day7Part1.is_stronger?(String.split("2AAAA", "", trim: :true), String.split("33332", "", trim: :true)) == false
    end

    test "77888 and 77788" do
      assert Day7Part1.is_stronger?(String.split("77888", "", trim: :true), String.split("77788", "", trim: :true)) == true
      assert Day7Part1.is_stronger?(String.split("77788", "", trim: :true), String.split("77888", "", trim: :true)) == false
    end

    test "KK677 and KTJJT" do
      assert Day7Part1.is_stronger?(String.split("KK677", "", trim: :true), String.split("KTJJT", "", trim: :true)) == true
      assert Day7Part1.is_stronger?(String.split("KTJJT", "", trim: :true), String.split("KK677", "", trim: :true)) == false
    end

    test "QQQJA and T55J5" do
      assert Day7Part1.is_stronger?(String.split("QQQJA", "", trim: :true), String.split("T55J5", "", trim: :true)) == true
      assert Day7Part1.is_stronger?(String.split("T55J5", "", trim: :true), String.split("QQQJA", "", trim: :true)) == false
    end
  end
end
