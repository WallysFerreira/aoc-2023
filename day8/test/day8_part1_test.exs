defmodule Day8Part1Test do
  use ExUnit.Case

  @example_path "files/example"

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
  end
end
