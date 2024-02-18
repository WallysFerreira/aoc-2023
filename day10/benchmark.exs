inputs = %{
  "example 1" => "files/example1",
  "example 2" => "files/example2",
  "real input" => "files/input"
}

Benchee.run(%{
  "one cursor" => fn path -> Part1.get_loop_path(path) end,
  "two cursors" => fn path -> Part1.get_loop_paths(path) end,
}, inputs: inputs)
