defmodule Solve do
    def normalize_string(string) do
        names_numbers = %{"one" => "1", "two" => "2"}

         Map.keys(names_numbers) |> Enum.reduce(string, fn key, str ->
            String.replace(str, key, names_numbers[key])
        end)
    end

    def extract_numbers(string) do
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
        numbers = example_content |> Enum.map(&Solve.extract_number(&1))
        numbers |> Enum.reduce(fn num, sum -> num + sum end)
    end
end


Solve.extract_number("one1two")
