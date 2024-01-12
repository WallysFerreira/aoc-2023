defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  describe "part 1" do
    test "solves example file" do
      assert Day6.solve_part_1("files/example") == 288
    end

    test "gets races info" do
      assert Day6.get_races(Day6.read_file("files/example")) == [
        %{
          duration: 7,
          distance: 9,
        },
        %{
          duration: 15,
          distance: 40,
        },
        %{
          duration: 30,
          distance: 200,
        },
      ]
    end
  end

  describe "calculates distance travelled" do
    test "in 7 milliseconds holding button for 0 milliseconds" do
      assert Day6.calculate_distance_travelled(7, 0) == 0
    end

    test "in 7 milliseconds holding button for 3 milliseconds" do
      assert Day6.calculate_distance_travelled(7, 3) == 12
    end

    test "in 7 milliseconds holding button for 4 milliseconds" do
      assert Day6.calculate_distance_travelled(7, 4) == 12
    end

    test "in 40 milliseconds holding button for 30 milliseconds" do
      assert Day6.calculate_distance_travelled(40, 30) == 300
    end
  end
end
