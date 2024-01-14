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
      assert Day7Part1.is_stronger?("A", "2") == true
      assert Day7Part1.is_stronger?("2", "A") == false
    end

    test "J and T" do
      assert Day7Part1.is_stronger?("J", "T") == true
      assert Day7Part1.is_stronger?("T", "J") == false
    end

    test "8 and 6" do
      assert Day7Part1.is_stronger?("8", "6") == true
      assert Day7Part1.is_stronger?("6", "8") == false
    end

    test "3 and 3" do
      assert Day7Part1.is_stronger?("3", "3") == false
    end
  end
end
