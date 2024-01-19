defmodule Day8Part1Test do
  use ExUnit.Case

  @example_path "files/example"
  @example2_path "files/example2"

  test "reads map" do
    assert Day8Part1.read_map(@example_path) == %{
      instructions: [:R, :L],
      network: %{
        "AAA": {"BBB", "CCC"},
        "BBB": {"DDD", "EEE"},
        "CCC": {"ZZZ", "GGG"},
        "DDD": {"DDD", "DDD"},
        "EEE": {"EEE", "EEE"},
        "GGG": {"GGG", "GGG"},
        "ZZZ": {"ZZZ", "ZZZ"},
      }
    }

    assert Day8Part1.read_map(@example2_path) == %{
      instructions: [:L, :L, :R],
      network: %{
        "AAA": {"BBB", "BBB"},
        "BBB": {"AAA", "ZZZ"},
        "ZZZ": {"ZZZ", "ZZZ"},
      }
    }
  end

  test "returns right element from instruction" do
    assert Day8Part1.get_element({"DDD", "EEE"}, :L) == "DDD"
    assert Day8Part1.get_element({"GGG", "UUU"}, :R) == "UUU"
  end

  describe "finds path to ZZZ" do
    test "in example 1" do
      assert Day8Part1.find_ZZZ(@example_path) == ["AAA", "CCC"]
    end

    test "in example 2" do
      assert Day8Part1.find_ZZZ(@example2_path) == ["AAA", "BBB", "AAA", "BBB", "AAA", "BBB"]
    end
  end

  describe "counts steps to ZZZ" do
    test "in example 1" do
      assert Day8Part1.count_steps_to_ZZZ(@example_path) == 2
    end

    test "in example 2" do
      assert Day8Part1.count_steps_to_ZZZ(@example2_path) == 6
    end
  end
end
