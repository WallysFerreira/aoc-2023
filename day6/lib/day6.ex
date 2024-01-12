defmodule Day6 do
  def read_file(path) do
    {:ok, contents} = File.read(path)
    String.split(contents, "\n", trim: true)
  end

  def extract_numbers(line, with_index \\ false) do
    numbers =
      Regex.scan(~r/[\d]+/, line)
      |> List.flatten()
      |> Enum.map(&(String.to_integer(&1)))

    if with_index do
      Enum.with_index(numbers)
    else
      numbers
    end
  end

  def get_races(lines) do
    durations = extract_numbers(Enum.at(lines, 0), true)
    distances = extract_numbers(Enum.at(lines, 1))

    durations
    |> Enum.map(fn duration_tuple ->
      {duration, idx} = duration_tuple

      %{
        duration: duration,
        distance: Enum.at(distances, idx)
      }
    end)
  end

  def calculate_distance_travelled(race_duration, time_holding_button) do
    (race_duration - time_holding_button) * time_holding_button
  end

  def get_winning_options(race) do
    1..(race.duration - 1)
    |> Enum.filter(&(calculate_distance_travelled(race.duration, &1) > race.distance))
  end

  def solve_part_1(path) do
    races =
      read_file(path)
      |> get_races()
  end
end
