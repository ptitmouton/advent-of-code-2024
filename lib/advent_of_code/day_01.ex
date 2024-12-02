defmodule AdventOfCode.Day01 do
  def part1(input) do
      input
      |> create_lists()
      |> Tuple.to_list()
      |> Enum.map(&Enum.sort/1)
      |> Enum.zip_reduce(0, fn [l, r], acc ->
        acc + abs(l - r)
    end)
  end

  def part2(input) do
    {left_list, right_list} =
      input
      |> create_lists()

    left_list
    |> Enum.map(fn l ->
      l * Enum.count(right_list, &(&1 == l))
    end)
    |> Enum.sum()
  end

  defp create_lists(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.reduce({[], []}, fn
      [l, r], {left_list, right_list} ->
        {[String.to_integer(l) | left_list], [String.to_integer(r) | right_list]}
    end)
  end
end
