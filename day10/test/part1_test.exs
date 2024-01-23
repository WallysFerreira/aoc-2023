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
      directions = [:west, :east, :north, :south]

      # Tests with J
      results_J =
        directions -- [:west]
        |> Enum.map(&Part1.connectable?("-", "J", &1))

      assert Enum.any?(results_J) == false
      assert Part1.connectable?("-", "J", :west) == true

      # Tests with L
      results_L =
        directions -- [:east]
        |> Enum.map(&Part1.connectable?("-", "L", &1))

      assert Enum.any?(results_L) == false
      assert Part1.connectable?("-", "L", :east) == true

      # Tests with 7
      results_7 =
        directions -- [:west]
        |> Enum.map(&Part1.connectable?("-", "7", &1))

      assert Enum.any?(results_7) == false
      assert Part1.connectable?("-", "7", :west) == true

      # Tests with F
      results_F =
        directions -- [:east]
        |> Enum.map(&Part1.connectable?("-", "F", &1))

      assert Enum.any?(results_F) == false
      assert Part1.connectable?("-", "F", :east) == true
    end

    test "vertical with bendeds" do
      directions = [:west, :east, :north, :south]
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
      directions = [:west, :east, :north, :south]
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
end
