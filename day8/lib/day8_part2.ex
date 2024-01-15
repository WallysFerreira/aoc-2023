defmodule Day8Part2 do
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
      |> Enum.map(&String.to_atom/1)

    network =
      Enum.drop(lines, 1)
      |> Enum.map(fn line ->
        Regex.scan(~r/[0-Z]{3}/, line)
        |> List.flatten()
      end)
      |> Enum.reduce(%{}, fn node, network_map ->
        network_map
        |> Map.put_new(String.to_atom(Enum.at(node, 0)), {Enum.at(node, 1), Enum.at(node, 2)})
      end)

    %{instructions: instructions, network: network}
  end

  def get_element(node, instruction) do
    {first, second} = node

    cond do
      instruction == :L -> first
      instruction == :R -> second
    end
  end

  def get_firsts(map) do
    map.network
    |> Map.to_list()
    |> Enum.filter(fn tuple ->
      {key, _value} = tuple
      String.at(to_string(key), 2) == "A"
    end)
  end

  def get_lasts(map) do
    map.network
    |> Map.to_list()
    |> Enum.filter(fn tuple ->
      {key, _value} = tuple
      String.at(to_string(key), 2) == "Z"
    end)
  end
end
