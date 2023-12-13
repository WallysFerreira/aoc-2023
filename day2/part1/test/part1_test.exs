defmodule Part1Test do
  use ExUnit.Case
  doctest Part1

  test "solves example" do
    assert Part1.solve_file("example") == 8
  end
end
