defmodule Day8Part2Test do
  use ExUnit.Case

  @example_path "files/example_part2"

  test "reads map" do
    assert Day8Part2.read_map(@example_path) == %{
      instructions: [:L, :R],
      network: %{
        "11A": {"11B", "XXX"},
        "11B": {"XXX", "11Z"},
        "11Z": {"11B", "XXX"},
        "22A": {"22B", "XXX"},
        "22B": {"22C", "22C"},
        "22C": {"22Z", "22Z"},
        "22Z": {"22B", "22B"},
        "XXX": {"XXX", "XXX"},
      }
    }
  end

  test "returns right element from instruction" do
    assert Day8Part2.get_element({"DDD", "EEE"}, :L) == "DDD"
    assert Day8Part2.get_element({"GGG", "UUU"}, :R) == "UUU"
  end

  test "finds first nodes" do
    map = Day8Part2.read_map(@example_path)

    assert Day8Part2.get_firsts(map) == [{:"11A", {"11B", "XXX"}}, {:"22A", {"22B", "XXX"}}]
  end

  test "finds last nodes" do
    map = Day8Part2.read_map(@example_path)

    assert Day8Part2.get_lasts(map) == [{:"11Z", {"11B", "XXX"}}, {:"22Z", {"22B", "22B"}}]
  end

  test "finds path to all last nodes" do
    assert Day8Part2.path_to_all_last_nodes(@example_path) == [[:"11A", :"11B", :"11Z", :"11B", :"11Z", :"11B"], [:"22A", :"22B", :"22C", :"22Z", :"22B", :"22C"]]
  end

  describe "finds path to one last node at a time" do
    test "starting at 11A" do
      map = Day8Part2.read_map(@example_path)
      assert Day8Part2.path_to_last_node(map, :"11A") == [:"11A", :"11B"]
    end

    test "starting at 22A" do
      map = Day8Part2.read_map(@example_path)
      assert Day8Part2.path_to_last_node(map, :"22A") == [:"22A", :"22B", :"22C"]
    end
  end

  test "gets number of steps to all last nodes" do
    assert Day8Part2.count_steps_to_all_last_nodes(@example_path) == 6
  end
end
