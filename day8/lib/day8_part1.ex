defmodule Day8Part1 do
  def read_file(path) do
    {:ok, contents} = File.read(path)

    contents
    |> String.split("\n", trim: true)
  end

  def read_map(path) do
    lines = read_file(path)

    instructions =
      Enum.at(lines, 0)
      |> String.split("", trim: true)

    network =
      Enum.drop(lines, 1)
      |> Enum.map(fn line ->
        Regex.scan(~r/[A-Z]{3}/, line)
        |> List.flatten()
      end)
      |> Enum.reduce(%{}, fn node, network_map ->
        network_map
        |> Map.put_new(String.to_atom(Enum.at(node, 0)), {Enum.at(node, 1), Enum.at(node, 2)})
      end)

    %{instructions: instructions, network: network}
  end
end
