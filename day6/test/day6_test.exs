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
          time: 7,
          distance: 9,
        },
        %{
          time: 15,
          distance: 40,
        },
        %{
          time: 30,
          distance: 200,
        },
      ]
    end
  end
end
