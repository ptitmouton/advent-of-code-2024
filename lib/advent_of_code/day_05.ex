defmodule AdventOfCode.Day05 do
  def part1(input) do
    [rules: rules, pages: pages] = parse_input(input)

    pages
    |> Enum.filter(&is_sorted?(&1, rules))
    |> Enum.map(&get_middle_value/1)
    |> Enum.sum()
  end

  def part2(input) do
    [rules: rules, pages: pages] = parse_input(input)

    pages
    |> Enum.filter(&(!is_sorted?(&1, rules)))
    |> Enum.map(&sort_by_rulebook(&1, rules))
    |> Enum.map(&get_middle_value/1)
    |> Enum.sum()
  end

  defp parse_input(input) do
    [rules, pages] =
      input
      |> String.split("\n\n", trim: true)

    rules =
      rules
      |> String.split("\n", trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split(&1, "|", trim: true))
      |> Enum.map(fn [bef, aft] ->
        {String.to_integer(bef), String.to_integer(aft)}
      end)

    pages =
      pages
      |> String.split("\n", trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.map(fn pagelist ->
        pagelist
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    [rules: rules, pages: pages]
  end

  defp is_sorted?(list, rules) do
    list == sort_by_rulebook(list, rules)
  end

  defp sort_by_rulebook(list, rules) do
    Enum.sort(list, fn a, b ->
      cond do
        Enum.find(rules, fn {bef, aft} -> a == bef && b == aft end) ->
          true

        Enum.find(rules, fn {bef, aft} -> b == bef && a == aft end) ->
          false

        true ->
          true
      end
    end)
  end

  defp get_middle_value(list) do
    Enum.at(list, div(Enum.count(list), 2))
  end
end
