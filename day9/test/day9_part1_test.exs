defmodule Day9Part1Test do
  use ExUnit.Case

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
