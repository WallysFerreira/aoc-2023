defmodule Day9Part1Test do
  use ExUnit.Case

  @example_path "files/example"

  test "reads lists from file" do
    assert Day9Part1.read_file(@example_path) == [
      [0, 3, 6, 9, 12, 15],
      [1, 3, 6, 10, 15, 21],
      [10, 13, 16, 21, 30, 45]
    ]
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

  describe "gets list of differences until all zeroes" do
    test "in first example" do
      assert Day9Part1.find_all_differences([0, 3, 6, 9, 12, 15]) == [
        [3, 3, 3, 3, 3],
      ]
    end

    test "in second example" do
      assert Day9Part1.find_all_differences([1, 3, 6, 10, 15, 21]) == [
        [2, 3, 4, 5, 6],
        [1, 1, 1, 1],
      ]
    end

    test "in third example" do
      assert Day9Part1.find_all_differences([10, 13, 16, 21, 30, 45]) == [
        [3, 3, 5, 9, 15],
        [0, 2, 4, 6],
        [2, 2, 2],
      ]
    end
  end

  describe "fills next values" do
    test "first example" do
      assert Day9Part1.get_next_values([0, 3, 6, 9, 12, 15]) == [
        [0, 3, 6, 9, 12, 15, 18],
        [3, 3, 3, 3, 3, 3],
      ]
    end

    test "second example" do
      assert Day9Part1.get_next_values([1, 3, 6, 10, 15, 21]) == [
        [1, 3, 6, 10, 15, 21, 28],
        [2, 3, 4, 5, 6, 7],
        [1, 1, 1, 1, 1],
      ]
    end

    test "third example" do
      assert Day9Part1.get_next_values([10, 13, 16, 21, 30, 45]) == [
        [10, 13, 16, 21, 30, 45, 68],
        [3, 3, 5, 9, 15, 23],
        [0, 2, 4, 6, 8],
        [2, 2, 2, 2],
      ]
    end
  end

  test "sum all next values of main lists" do
    lists = Day9Part1.read_file(@example_path)

    assert Day9Part1.sum_next_values(lists) == 114
  end
end
