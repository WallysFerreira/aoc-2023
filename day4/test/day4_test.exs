defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  describe "part 1" do
    test "solves example file" do
      assert Day4.solve_part_1("files/example") == 13
    end
  end

  describe "part 2" do
    test "solves example file" do
      assert Day4.solve_part_2("files/example") == 30
    end
  end
end
