defmodule Day6Part2 do
  def read_file(path) do
    {:ok, contents} = File.read(path)
    String.split(contents, "\n", trim: true)
  end

  def extract_numbers(line) do
    Regex.scan(~r/[\d]+/, line)
    |> List.flatten()
    |> Enum.reduce("", fn number, acc ->
      acc <> number
    end)
    |> String.to_integer()
  end

  def get_race(path) do
    lines = read_file(path)

    %{
      duration: extract_numbers(Enum.at(lines, 0)),
      distance: extract_numbers(Enum.at(lines, 1))
    }
  end

  def calculate_distance_travelled(race_duration, time_holding_button) do
    (race_duration - time_holding_button) * time_holding_button
  end

  def get_winning_options(race) do
    1..(race.duration - 1)
    |> Enum.filter(&(calculate_distance_travelled(race.duration, &1) > race.distance))
  end

  def get_total_winning_options(race) do
    race
    |> get_winning_options()
    |> length()
  end
end
