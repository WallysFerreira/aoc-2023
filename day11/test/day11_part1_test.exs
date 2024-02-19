defmodule Day11Part1Test do
  use ExUnit.Case

  @example_path "files/example"
  @example_expanded_path "files/example_expanded"

  test "returns a list of string when reading file" do
    lines = Day11Part1.read_file(@example_path)

    assert is_list(lines)
    assert Enum.all?(lines, &is_binary(&1))
  end

  test "correctly extracts columns" do
    map = Day11Part1.read_file(@example_path)
    columns = Day11Part1.get_columns(map)

    assert is_list(columns)
    assert Enum.at(columns, 0) == "..#......#"
    assert Enum.at(columns, 2) == ".........."
    assert Enum.at(columns, 5) == ".........."
    assert Enum.at(columns, 8) == ".........."
  end

  test "expands space" do
    map = Day11Part1.read_file(@example_path)
    example_expanded = Day11Part1.read_file(@example_expanded_path)

    assert Day11Part1.expand(map) == example_expanded
  end

  test "lists galaxies with their coordinates" do
    map = Day11Part1.read_file(@example_path)
    expanded_map = Day11Part1.expand(map)

    assert Day11Part1.list_galaxies(expanded_map) == %{
             1 => %{:x => 4, :y => 0},
             2 => %{:x => 9, :y => 1},
             3 => %{:x => 0, :y => 2},
             4 => %{:x => 8, :y => 5},
             5 => %{:x => 1, :y => 6},
             6 => %{:x => 12, :y => 7},
             7 => %{:x => 9, :y => 10},
             8 => %{:x => 0, :y => 11},
             9 => %{:x => 5, :y => 11}
           }
  end

  describe "calculates distance between galaxies" do
    test "1 and 7" do
      galaxies =
        Day11Part1.read_file(@example_path)
        |> Day11Part1.expand()
        |> Day11Part1.list_galaxies()

      assert Day11Part1.calculate_distance(galaxies, 1, 7) == 15
    end

    test "3 and 6" do
      galaxies =
        Day11Part1.read_file(@example_path)
        |> Day11Part1.expand()
        |> Day11Part1.list_galaxies()

      assert Day11Part1.calculate_distance(galaxies, 3, 6) == 17
    end

    test "8 and 9" do
      galaxies =
        Day11Part1.read_file(@example_path)
        |> Day11Part1.expand()
        |> Day11Part1.list_galaxies()

      assert Day11Part1.calculate_distance(galaxies, 8, 9) == 5
    end

    test "5 and 9" do
      galaxies =
        Day11Part1.read_file(@example_path)
        |> Day11Part1.expand()
        |> Day11Part1.list_galaxies()

      assert Day11Part1.calculate_distance(galaxies, 5, 9) == 9
    end
  end

  test "sum distances between all pairs of galaxies" do
    galaxies =
      Day11Part1.read_file(@example_path)
      |> Day11Part1.expand()
      |> Day11Part1.list_galaxies()

    assert Day11Part1.sum_distances(galaxies) == 374
  end
end
