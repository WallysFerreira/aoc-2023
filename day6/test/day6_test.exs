defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  describe "part 1" do
    test "solves example file" do
      assert Day6.solve_part_1("files/example") == 288
    end
  end
end
