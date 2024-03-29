defmodule Part1Test do
  use ExUnit.Case

  @example1_path "files/example1"
  @example2_path "files/example2"

  describe "reads file" do
    test "from first example" do
      assert Part1.read_file(@example1_path) == [
        "-L|F7",
        "7S-7|",
        "L|7||",
        "-L-J|",
        "L|-JF",
      ]
    end

    test "from second example" do
      assert Part1.read_file(@example2_path) == [
        "7-F7-",
        ".FJ|7",
        "SJLL7",
        "|F--J",
        "LJ.LJ",
      ]
    end
  end

  describe "judges if pipes can connect" do
    test "horizontal with vertical" do
      directions = [:west, :east, :north, :south]

      results =
        directions
        |> Enum.map(&Part1.connectable?("-", "|", &1))

      assert Enum.any?(results) == false
    end

    test "horizontal with bendeds" do
      directions = [:east, :west, :south, :north]

      # Tests with J
      results_J =
        directions -- [:east]
        |> Enum.map(&Part1.connectable?("-", "J", &1))

      assert Enum.any?(results_J) == false
      assert Part1.connectable?("-", "J", :east) == true

      # Tests with L
      results_L =
        directions -- [:west]
        |> Enum.map(&Part1.connectable?("-", "L", &1))

      assert Enum.any?(results_L) == false
      assert Part1.connectable?("-", "L", :west) == true

      # Tests with 7
      results_7 =
        directions -- [:east]
        |> Enum.map(&Part1.connectable?("-", "7", &1))

      assert Enum.any?(results_7) == false
      assert Part1.connectable?("-", "7", :east) == true

      # Tests with F
      results_F =
        directions -- [:west]
        |> Enum.map(&Part1.connectable?("-", "F", &1))

      assert Enum.any?(results_F) == false
      assert Part1.connectable?("-", "F", :west) == true
    end

    test "vertical with bendeds" do
      directions = [:east, :west, :south, :north]
      bendeds = ["J", "L", "7", "F"]

      results =
        directions
        |> Enum.map(fn direction ->
          bendeds
          |> Enum.map(&Part1.connectable?("|", &1, direction))
        end)

      # No vertical should connect from west
      assert Enum.any?(Enum.at(results, 0)) == false

      # No vertical should connect from east
      assert Enum.any?(Enum.at(results, 1)) == false

      # Vertical should connect with J and L from north
      assert Enum.at(Enum.at(results, 2), 0) == true
      assert Enum.at(Enum.at(results, 2), 1) == true
      # Not all connecting from north should be true
      assert Enum.all?(Enum.at(results, 2)) == false

      # Vertical should connect with 7 and F from south
      assert Enum.at(Enum.at(results, 3), 2) == true
      assert Enum.at(Enum.at(results, 3), 3) == true
      # Not all connecting from south should be true
      assert Enum.all?(Enum.at(results, 3)) == false
    end

    test "ground with any" do
      directions = [:west, :east, :north, :south]
      pipes = ["-", "|", "J", "L", "7", "F", "S"]

      results =
        directions
        |> Enum.map(fn direction ->
          pipes
          |> Enum.map(&Part1.connectable?(".", &1, direction))
        end)

      assert Enum.any?(Enum.map(results, &Enum.any?(&1))) == false
    end

    test "start with any" do
      directions = [:east, :west, :south, :north]
      pipes = ["-", "|", "J", "L", "7", "F"]

      results =
        directions
        |> Enum.map(fn direction ->
          pipes
          |> Enum.map(&Part1.connectable?("S", &1, direction))
        end)

      # From west
      # -
      assert Enum.at(Enum.at(results, 0), 0) == true
      # J
      assert Enum.at(Enum.at(results, 0), 2) == true
      # 7
      assert Enum.at(Enum.at(results, 0), 4) == true
      # Others
      assert Enum.all?(Enum.at(results, 0)) == false

      # From east
      # -
      assert Enum.at(Enum.at(results, 1), 0) == true
      # L
      assert Enum.at(Enum.at(results, 1), 3) == true
      # F
      assert Enum.at(Enum.at(results, 1), 5) == true
      # Others
      assert Enum.all?(Enum.at(results, 1)) == false

      # From north
      # |
      assert Enum.at(Enum.at(results, 2), 1) == true
      # J
      assert Enum.at(Enum.at(results, 2), 2) == true
      # L
      assert Enum.at(Enum.at(results, 2), 3) == true
      # Others
      assert Enum.all?(Enum.at(results, 2)) == false

      # From south
      # |
      assert Enum.at(Enum.at(results, 3), 1) == true
      # 7
      assert Enum.at(Enum.at(results, 3), 4) == true
      # F
      assert Enum.at(Enum.at(results, 3), 5) == true
      # Others
      assert Enum.all?(Enum.at(results, 3)) == false
    end
  end

  describe "finds start of loop" do
    test "on first example" do
      lines = Part1.read_file(@example1_path)

      assert Part1.find_start(lines) == {1, 1}
    end

    test "on second example" do
      lines = Part1.read_file(@example2_path)

      assert Part1.find_start(lines) == {0, 2}
    end
  end

  describe "gets north, east, south, west coords" do
    test "using coords of S in first example" do
      lines = Part1.read_file(@example1_path)
      coords_of_S = Part1.find_start(lines)

      assert Part1.get_surrounding_coords(coords_of_S) == [{1, 0}, {2, 1}, {1, 2}, {0, 1}]
    end

    test "using coords of S in second example" do
      lines = Part1.read_file(@example2_path)
      coords_of_S = Part1.find_start(lines)

      assert Part1.get_surrounding_coords(coords_of_S) == [{0, 1}, {1, 2}, {0, 3}, nil]
    end

    test "using coords on the starting bound" do
      assert Part1.get_surrounding_coords({0, 0}) == [nil, {1, 0}, {0, 1}, nil]
    end
  end

  describe "finds coords of next pipe" do
    test "from S in first example" do
      lines = Part1.read_file(@example1_path)
      coords_of_S = Part1.find_start(lines)

      assert Part1.get_next_pipe(lines, coords_of_S) == {2, 1}
    end

    test "from second step in first example" do
      lines = Part1.read_file(@example1_path)

      assert Part1.get_next_pipe(lines, {2, 1}) == {3, 1}
    end

    test "from S in second example" do
      lines = Part1.read_file(@example2_path)
      coords_of_S = Part1.find_start(lines)

      assert Part1.get_next_pipe(lines, coords_of_S) == {1, 2}
    end

    test "from second step in second example" do
      lines = Part1.read_file(@example2_path)

      assert Part1.get_next_pipe(lines, {1, 2}) == {1, 1}
    end
  end

  describe "traces steps in loop using one cursor" do
    test "on first example" do
      assert Part1.get_loop_path(@example1_path) == [{2, 1}, {3, 1}, {3, 2}, {3, 3}, {2, 3}, {1, 3}, {1, 2}]
    end

    test "on second example" do
      assert Part1.get_loop_path(@example2_path) == [{1, 2}, {1, 1}, {2, 1}, {2, 0}, {3, 0}, {3, 1}, {3, 2}, {4, 2}, {4, 3}, {3, 3}, {2, 3}, {1, 3}, {1, 4}, {0, 4}, {0, 3}]
    end
  end

  describe "traces steps in loop using two cursors" do
    test "on first example" do
      assert Part1.get_loop_paths(@example1_path) == [
        [{2, 1}, {3, 1}, {3, 2}, {3, 3}],
        [{1, 2}, {1, 3}, {2, 3}, {3, 3}]
      ]
    end

    test "on second example" do
      assert Part1.get_loop_paths(@example2_path) == [
        [{1, 2}, {1, 1}, {2, 1}, {2, 0}, {3, 0}, {3, 1}, {3, 2}, {4, 2}],
        [{0, 3}, {0, 4}, {1, 4}, {1, 3}, {2, 3}, {3, 3}, {4, 3}, {4, 2}]
      ]
    end
  end

  describe "finds farthest point in loop" do
    test "on first example" do
      assert Part1.find_farthest_point(@example1_path) == 4
    end

    test "on second example" do
      assert Part1.find_farthest_point(@example2_path) == 8
    end
  end
end
