defmodule Part1 do
  @moduledoc """
  Documentation for `Part1`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Part1.solve_file("example")
      0

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
      [Enum.at(String.split(Enum.at(str, 0)), 0) | list]
    end)

    Enum.reverse(values)
  end

  def create_game(line) do
    game = %{
      :id => String.to_integer(String.slice(line, 5..5)),
      :blue => get_values(line, "blue"),
      :red => get_values(line, "red"),
      :green => get_values(line, "green")
    }
  end

  def solve_file(path) do
    games = read_file(path) |> Enum.reduce([], fn line, acc ->
      [create_game(line) | acc]
    end)

    0
  end
end
