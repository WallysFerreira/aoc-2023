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

  def path_to_last_node(map, starting_node_key) do
    index_of_node =
      get_firsts(map)
      |> Enum.find_index(fn node ->
        {node_key, _node_value} = node
        node_key == starting_node_key
      end)

    {_starting_node_key, starting_node_value} =
      get_firsts(map)
      |> Enum.at(index_of_node)

    {last_node_key, _last_node_value} =
      get_lasts(map)
      |> Enum.at(index_of_node)

    Stream.cycle(map.instructions)
    |> Enum.reduce_while({[starting_node_key], starting_node_value}, fn instruction, acc ->
      {path_till_now, current_node} = acc

      next_node_key = get_element(current_node, instruction)

      if String.at(next_node_key, 2) == "Z" do
        {:halt, path_till_now}
      else
        {:cont, {List.insert_at(path_till_now, -1, String.to_atom(next_node_key)), Map.get(map.network, String.to_atom(next_node_key))}}
      end
    end)
  end

  def count_steps_to_all_last_nodes(path) do
    map = read_map(path)

    lengths =
      map
      |> get_firsts()
      |> Enum.map(fn node ->
        {key, _value} = node

        path_to_last_node(map, key)
        |> length()
      end)

    lengths
    |> Enum.reduce_while(lengths, fn _length, acc ->
      a_b = Enum.take(acc, 2)

      new_list =
        Enum.slice(acc, 2..-1)
        |> List.insert_at(0, Math.lcm(Enum.at(a_b, 0), Enum.at(a_b, 1)))

      if length(new_list) == 1 do
        {:halt, Enum.at(new_list, 0)}
      else
        {:cont, new_list}
      end
    end)
  end
end
