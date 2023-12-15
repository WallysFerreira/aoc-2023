defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  test "solves example" do
    assert Day2.solve_part_1("files/example") == 8
  end
end
