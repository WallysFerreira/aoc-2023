defmodule Day11Part1Test do
  use ExUnit.Case

  @example_path "files/example"

  test "returns a list of string when reading file" do
    lines = Day11Part1.read_file(@example_path)

    assert is_list(lines)
    assert Enum.all?(lines, &is_binary(&1))
  end
end
