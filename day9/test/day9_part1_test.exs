defmodule Day9Part1Test do
  use ExUnit.Case

  @example_path "files/example"

  test "reads lists from file" do
    assert Day9Part1.read_file(@example_path) == [[0, 3, 6, 9, 12, 15], [1, 3, 6, 10, 15, 21], [10, 13, 16, 21, 30, 45]]
  end

  describe "gets sequence of differences" do
    test "with all positives" do
      assert Day9Part1.get_differences([0, 3, 7, 15, 25]) == [3, 4, 8, 10]
    end

    test "with all negatives" do
      assert Day9Part1.get_differences([-40, -30, -27, -15]) == [10, 3, 12]
    end

    test "with mixed numbers" do
      assert Day9Part1.get_differences([0, -2, 9, 19, -20]) == [-2, 11, 10, -39]
    end
  end
end
