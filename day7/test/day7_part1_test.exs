defmodule Day7Part1Test do
  use ExUnit.Case

  @example_path "files/example"

  test "extracts hand and bid info" do
    assert Day7Part1.get_info(@example_path) == [
      %{
        hand: ["3", "2", "T", "3", "K"],
        bid: 765
      },
      %{
        hand: ["T", "5", "5", "J", "5"],
        bid: 684
      },
      %{
        hand: ["K", "K", "6", "7", "7"],
        bid: 28
      },
      %{
        hand: ["K", "T", "J", "J", "T"],
        bid: 220
      },
      %{
        hand: ["Q", "Q", "Q", "J", "A"],
        bid: 483
      }
    ]
  end
end
