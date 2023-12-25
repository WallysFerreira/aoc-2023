defmodule Day5Test do
  use ExUnit.Case
  doctest Day5

  describe "part 1" do
    test "solves part 1" do
      assert Day5.solve_part_1("files/example") == 35
    end
  end
end
