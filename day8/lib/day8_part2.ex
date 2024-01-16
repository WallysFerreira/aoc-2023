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

  def path_to_last_node(path) do
    map = read_map(path)

    starting_nodes = get_firsts(map) |> Enum.map(&[&1])
    ending_nodes = get_lasts(map) |> Enum.map(&[&1])

    starting_nodes_keys =
      starting_nodes
      |> Enum.map(fn node ->
        {node_key, _node_value} = Enum.at(node, 0)
        [node_key]
      end)

    Stream.cycle(map.instructions)
    |> Enum.reduce_while({starting_nodes_keys, List.flatten(starting_nodes)}, fn instruction, acc ->
      {paths, current_nodes} = acc

      next_nodes =
        current_nodes
        |> Enum.map(fn current_node ->
          {_node_key, node_values} = current_node

          get_element(node_values, instruction)
        end)
        |> Enum.map(fn node_key ->
          map.network
          |> Enum.find(fn map_node ->
            {map_node_key, _map_node_value} = map_node
            String.to_atom(node_key) == map_node_key
          end)
        end)

      found_both? =
        Enum.with_index(next_nodes)
        |> Enum.all?(fn node_with_idx ->
          {node, idx} = node_with_idx
          {next_node_key, _next_node_value} = node

          {ending_node_key, _ending_node_values} = Enum.at(Enum.at(ending_nodes, idx), 0)
          ending_node_key == next_node_key
        end)

      if found_both? do
        {:halt, paths}
      else
        paths_till_now =
          Enum.with_index(paths)
          |> Enum.map(fn path_tuple ->
            {path, idx} = path_tuple
            {next_node_key, _next_node_value} = Enum.at(next_nodes, idx)

            path
            |> List.insert_at(-1, next_node_key)
          end)
        {:cont, {paths_till_now, next_nodes}}
      end
    end)
  end
end
