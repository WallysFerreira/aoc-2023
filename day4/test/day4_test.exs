defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  describe "part" do
    test "solves example file" do
      assert Day4.solve_part_1("files/example") == 13
    end
  end
end
