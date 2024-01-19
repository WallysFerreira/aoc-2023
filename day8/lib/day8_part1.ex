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
      |> Enum.map(&String.to_atom/1)

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

  def get_element(node, instruction) do
    {first, second} = node

    cond do
      instruction == :L -> first
      instruction == :R -> second
    end
  end

  def find_ZZZ(path) do
    map = read_map(path)

    Stream.cycle(map.instructions)
    |> Enum.reduce_while({["AAA"], Map.get(map.network, :AAA)}, fn instruction, acc ->
      {path, next_node} = acc

      element =
        next_node
        |> get_element(instruction)

      if element == "ZZZ" do
        {:halt, path}
      else
        {:cont, {[element | path], Map.get(map.network, String.to_atom(element))}}
      end
    end)
    |> Enum.reverse()
  end

  def count_steps_to_ZZZ(path) do
    find_ZZZ(path)
    |> length()
  end
end
