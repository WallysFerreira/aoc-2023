defmodule Day6Part1Test do
  use ExUnit.Case
  doctest Day6Part1

  @example_path "files/example"

  test "gets races info" do
    assert Day6Part1.get_races(@example_path) == [
             %{
               duration: 7,
               distance: 9
             },
             %{
               duration: 15,
               distance: 40
             },
             %{
               duration: 30,
               distance: 200
             }
           ]
  end

  describe "calculates distance travelled" do
    test "in 7 milliseconds holding button for 0 milliseconds" do
      assert Day6Part1.calculate_distance_travelled(7, 0) == 0
    end

    test "in 7 milliseconds holding button for 3 milliseconds" do
      assert Day6Part1.calculate_distance_travelled(7, 3) == 12
    end

    test "in 7 milliseconds holding button for 4 milliseconds" do
      assert Day6Part1.calculate_distance_travelled(7, 4) == 12
    end

    test "in 40 milliseconds holding button for 30 milliseconds" do
      assert Day6Part1.calculate_distance_travelled(40, 30) == 300
    end
  end

  test "gets winning options" do
    races =
      Day6Part1.get_races(@example_path)

    assert Day6Part1.get_winning_options(Enum.at(races, 0)) == [2, 3, 4, 5]
    assert Day6Part1.get_winning_options(Enum.at(races, 1)) == [4, 5, 6, 7, 8, 9, 10, 11]
    assert Day6Part1.get_winning_options(Enum.at(races, 2)) == [11, 12, 13, 14, 15, 16, 17, 18, 19]
  end

  test "calculates total number of winning options" do
    races =
      Day6Part1.get_races(@example_path)

    assert Day6Part1.get_total_winning_options(races) == 288
  end
end
