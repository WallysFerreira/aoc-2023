defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  describe "part 1" do
    test "solves example file" do
      assert Day3.solve_part_1("files/example") == 4361
    end

    test "solves my example file" do
      assert Day3.solve_part_1("files/example2") == 0
    end

    test "solves u/i_have_no_biscuits' example file" do
      assert Day3.solve_part_1("files/example3") == 413
    end

    test "solves u/i_have_no_biscuits' second example file" do
      assert Day3.solve_part_1("files/example4") == 925
    end
  end

  describe "part 2" do
    test "solves example file" do
      assert Day3.solve_part_2("files/example") == 467835
    end
  end
end
