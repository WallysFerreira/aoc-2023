defmodule Day5Test do
  use ExUnit.Case
  doctest Day5

  describe "part 1" do
    test "solves example file" do
      assert Day5.solve_part_1("files/example") == 35
    end
  end

  describe "part 2" do
    test "solves example file" do
      assert Day5.solve_part_2("files/example") == 46
    end
  end
end
