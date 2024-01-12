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
    times = extract_numbers(Enum.at(lines, 0), true)
    distances = extract_numbers(Enum.at(lines, 1))

    times
    |> Enum.map(fn time_tuple ->
      {time, idx} = time_tuple

      %{
        time: time,
        distance: Enum.at(distances, idx)
      }
    end)
  end

  def solve_part_1(path) do
  end
end
