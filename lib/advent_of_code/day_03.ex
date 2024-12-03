defmodule AdventOfCode.Day03 do
  def part1(input) do
    regex = ~r/mul\((\d{1,3}),(\d{1,3})\)/

    regex
    |> Regex.scan(input)
    |> Enum.map(fn [_, a, b] ->
      {String.to_integer(a), String.to_integer(b)}
    end)
    |> Enum.reduce(0, fn {l, r}, acc ->
      acc + l * r
    end)
  end

  def part2(input) do
    regex = ~r/(do(?:n't)?\(\))|mul\((\d{1,3}),(\d{1,3})\)/

    regex
    |> Regex.scan(input)
    |> Enum.reduce({true, 0}, fn
      [_, "don't()" | _], {_, acc} -> {false, acc}
      [_, "do()" | _], {_, acc} -> {true, acc}
      [_, _, a, b], {true, acc} -> {true, acc + String.to_integer(a) * String.to_integer(b)}
      [_, _, _, _], {false, acc} -> {false, acc}
    end)
    |> elem(1)
  end
end
