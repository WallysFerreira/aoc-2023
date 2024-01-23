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
end
