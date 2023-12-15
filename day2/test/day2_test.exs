defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  test "solves example of part 1" do
    assert Day2.solve_part_1("files/example") == 8
  end

  test "solves example of part 2" do
    assert Day2.solve_part_2("files/example") == 2286
  end
end
