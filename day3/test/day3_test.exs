defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "solves part 1 example file" do
    assert Day3.solve_part_1("files/example") == 4361
  end

  test "solves my example file" do
    assert Day3.solve_part_1("files/example2") == 0
  end
end
