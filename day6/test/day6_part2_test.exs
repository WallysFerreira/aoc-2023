defmodule Day6Part2Test do
  use ExUnit.Case
  doctest Day6Part2

  @example_path "files/example"

  test "extracts race info" do
    assert Day6Part2.get_race(@example_path) == %{duration: 71530, distance: 940200}
  end

  test "counts winnig options" do
    race = Day6Part2.get_race(@example_path)

    assert Day6Part2.get_total_winning_options(race) == 71503
  end
end
