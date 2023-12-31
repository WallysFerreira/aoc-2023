defmodule Day5 do
  def read_file(path) do
    {:ok, contents} = File.read(path)
    String.split(contents, "\n\n", trim: true)
  end

  def create_almanac(sections) do
    almanac_object = %{
      seed_numbers: nil,
      seed_ranges: [],
      to_soil: nil,
      to_fertilizer: nil,
      to_water: nil,
      to_light: nil,
      to_temperature: nil,
      to_humidity: nil,
      to_location: nil,
    }

    almanac = Enum.with_index(sections)
    |> Enum.reduce(almanac_object, fn section_tuple, updated_almanac ->
      {section, index} = section_tuple

      if index == 0 do
        seed_numbers = Regex.scan(~r/[\d]+/, section)
        |> Enum.map(fn seed_number_list ->
          String.to_integer(Enum.at(seed_number_list, 0))
        end)

        Map.replace(updated_almanac, :seed_numbers, seed_numbers)
      else
        section_name = Enum.at(Enum.at(Regex.scan(~r/to-[\w]+/, section), 0), 0)
        section_name = section_name
        |> String.replace("-", "_")
        section_name = String.to_atom(section_name)

        section_numbers =
          Enum.drop(String.split(section, "\n", trim: true), 1)

        maps =
          section_numbers
          |> Enum.map(fn numbers ->
            numbers =
              String.split(numbers)
              |> Enum.map(&String.to_integer/1)

            {Enum.at(numbers, 0), Enum.at(numbers, 1), Enum.at(numbers, 2)}
          end)

        Map.replace(updated_almanac, section_name, maps)
      end
    end)

    extract_seed_range_info(almanac)
  end

  def get_destination_number(source_number, maps) do
    maps
    |> Enum.reduce_while(source_number, fn map, acc ->
      {dest_range_start, source_range_start, range_length} = map

      if acc >= source_range_start &&
        acc <= source_range_start + range_length do
        {:halt, dest_range_start + acc - source_range_start}
      else
        {:cont, acc}
      end
    end)
  end

  def get_destination(almanac, dest_category, seeds) do
    categories = ["soil", "fertilizer", "water", "light", "temperature", "humidity", "location"]

    Stream.map(seeds, fn seed ->
      Enum.reduce_while(categories, seed, fn category, dest_number ->
        current_map = Map.get(almanac, String.to_atom("to_#{category}"))
        dest_number = get_destination_number(dest_number, current_map)

        if category == dest_category do
          {:halt, dest_number}
        else
          {:cont, dest_number}
        end
      end)
    end)
  end

  def get_destination(almanac, dest_category, seeds, _type) do
    categories = ["soil", "fertilizer", "water", "light", "temperature", "humidity", "location"]

    {_, locations} = Enum.unzip(seeds
    |> Enum.map(fn range_tuple ->
      {range_start, range_length} = range_tuple

      Enum.reduce_while(Stream.iterate(1, &(&1 + 1)), {range_start, []}, fn _, acc ->
        {current_seed, locations} = acc

        locations = [Enum.reduce_while(categories, current_seed, fn category, dest_number ->
          current_map = Map.get(almanac, String.to_atom("to_#{category}"))
          dest_number = get_destination_number(dest_number, current_map)

          if category == dest_category do
            {:halt, dest_number}
          else
            {:cont, dest_number}
          end
        end) | locations]

        if current_seed == range_start + range_length do
          {:halt, {current_seed, locations}}
        else
          {:cont, {current_seed + 1, locations}}
        end
      end)
    end))

    locations
  end

  def extract_seed_range_info(almanac) do
    Enum.chunk_every(almanac.seed_numbers, 2)
    |> Enum.reduce(almanac, fn range_pair, updated_almanac ->
      Map.put(updated_almanac, :seed_ranges, [{Enum.at(range_pair, 0), Enum.at(range_pair, 1)} | updated_almanac.seed_ranges])
    end)

  end

  def solve_part_1(path) do
    almanac =
      read_file(path)
      |> create_almanac()

    locations_of_seeds = almanac
    |> get_destination("location", almanac.seed_numbers)

    Enum.min(locations_of_seeds)
  end

  def solve_part_2(path) do
    almanac =
      read_file(path)
      |> create_almanac()

    #get_destination(almanac, "location", almanac.seed_ranges, "tuple")

    {first_half, second_half} = Enum.split(almanac.seed_ranges, Integer.floor_div(length(almanac.seed_ranges), 2))

    #Enum.min(List.flatten([first_half, second_half]
    Enum.min(List.flatten(Enum.chunk_every(almanac.seed_ranges, 2)
    |> Stream.map(&Task.async(Day5, :get_destination, [almanac, "location", &1, "tuple"]))
    |> Enum.map(&Task.await(&1, :infinity))))
  end
end
