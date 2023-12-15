defmodule Day2 do
  @moduledoc """
  Documentation for `Day2`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Day2.solve_part_1("files/example")
      8

  """

  @max_qty %{:red => 12, :green => 13, :blue => 14}

  def read_file(path) do
    {:ok, contents} = File.read(path)
    contents |> String.split("\n", trim: true)
  end

  def parse_to_int(string) do
    case Integer.parse(string) do
      {num, ""} -> num
      :error -> nil
    end
  end

  def get_values(line, color) do
    found = Regex.scan(~r/[\d]+ #{color}/, line)

    values = Enum.reduce(found, [], fn str, list ->
      [String.to_integer(Enum.at(String.split(Enum.at(str, 0)), 0)) | list]
    end)

    Enum.reverse(values)
  end

  def get_id(line) do
    String.to_integer(Enum.at(String.split(Enum.at(Regex.run(~r/Game [\d]+/, line), 0)), 1))
  end

  def create_game(line) do
    %{
      :id => get_id(line),
      :blue => get_values(line, "blue"),
      :red => get_values(line, "red"),
      :green => get_values(line, "green")
    }
  end

  def get_all_games(path) do
    Enum.reverse(read_file(path) |> Enum.reduce([], fn line, acc ->
      [create_game(line) | acc]
    end))
  end

  def get_impossible_games(path) do
    get_all_games(path) |> Enum.filter(fn game ->
      Map.keys(@max_qty) |> Enum.any?(fn key ->
        Enum.max(game[key]) > @max_qty[key]
      end)
    end)
  end

  def get_possible_games(path) do
    get_all_games(path) -- get_impossible_games(path)
  end

  def get_min_values(game) do
    %{
      :blue_min => Enum.max(game.blue),
      :red_min => Enum.max(game.red),
      :green_min => Enum.max(game.green),
    }
  end

  def solve_part_1(path) do
    Enum.reduce(get_possible_games(path), 0, fn game, acc -> acc + game.id end)
  end

  def solve_part_2(path) do
    Enum.reduce(get_all_games(path) |> Enum.map(fn game ->
      Map.values(get_min_values(game)) |> Enum.reduce(fn min_value, acc -> acc * min_value end)
    end), fn power, sum -> sum + power end)
  end
end
