defmodule Solve do
    def normalize_string(string) do
        names_numbers = %{
            "one" => "1",
            "two" => "2",
            "three" => "3",
            "four" => "4",
            "five" => "5",
            "six" => "6",
            "seven" => "7",
            "eight" => "8",
            "nine" => "9",
        }

         Map.keys(names_numbers) |> Enum.reduce(string, fn key, str ->
            String.replace(str, key, "#{String.first(key)}#{names_numbers[key]}#{String.last(key)}")
        end)
    end

    def extract_number(string) do
        numbers = String.replace(string, ~r/[^\d]/, "")
        sliced_numbers = String.first(numbers) <> String.last(numbers)
        String.to_integer(sliced_numbers)
    end
end

defmodule Testing do
    def read_file(path) do
      {:ok, contents} = File.read(path)
      contents |> String.split("\n", trim: true)
    end

    def run_tests() do
        %{:example => solve_file("example"), :input => solve_file("input")}
    end

    def solve_file(path) do
        example_content = read_file(path)
        normalized_strings = example_content |> Enum.map(&Solve.normalize_string(&1))
        numbers = normalized_strings |> Enum.map(&Solve.extract_number(&1))
        numbers |> Enum.reduce(fn num, sum -> num + sum end)
    end
end
