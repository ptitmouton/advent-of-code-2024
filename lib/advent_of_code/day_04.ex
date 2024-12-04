defmodule AdventOfCode.Day04 do
  def part1(input) do
    grid = make_grid(input)

    (find_text(grid, "XMAS") ++ find_text(grid, "SAMX"))
    |> Enum.sort_by(fn {_, _, x, y} -> {y, x} end)
    |> Enum.count()
  end

  def part2(input) do
    grid = make_grid(input)

    Enum.with_index(grid)
    |> Enum.reduce([], fn {row, y}, acc ->
      Enum.with_index(row)
      |> Enum.reduce(acc, fn
        {"A", x}, acc ->
          if check_xmasscross(grid, x, y) do
            [{x, y} | acc]
          else
            acc
          end

        {_, _}, acc ->
          acc
      end)
    end)
    |> Enum.count()
  end

  defp make_grid(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.graphemes/1)
  end

  defp check_xmasscross(grid, x, y) do
    if (check_downright(grid, x - 1, y - 1, "MAS") || check_downright(grid, x - 1, y - 1, "SAM")) &&
         (check_downleft(grid, x + 1, y - 1, "MAS") || check_downleft(grid, x + 1, y - 1, "SAM")),
       do: true,
       else: false
  end

  defp find_text(grid, <<head::binary-size(1), _::binary>> = text) do
    Enum.with_index(grid)
    |> Enum.reduce([], fn {row, y}, acc ->
      Enum.with_index(row)
      |> Enum.reduce(acc, fn
        {^head, x}, acc ->
          acc =
            if check_right(grid, x, y, text),
              do: [{text, :right, x, y} | acc],
              else: acc

          acc =
            if check_down(grid, x, y, text),
              do: [{text, :down, x, y} | acc],
              else: acc

          acc =
            if check_downleft(grid, x, y, text),
              do: [{text, :downleft, x, y} | acc],
              else: acc

          acc =
            if check_downright(grid, x, y, text),
              do: [{text, :downright, x, y} | acc],
              else: acc

          acc

        {_, _}, acc ->
          acc
      end)
    end)
  end

  defp check_right(_, _, _, ""), do: true

  defp check_right(grid, x, y, <<head::binary-size(1), rest::binary>>) do
    cond do
      x >= Enum.count(Enum.at(grid, y)) -> false
      head == Enum.at(Enum.at(grid, y), x) -> check_right(grid, x + 1, y, rest)
      true -> false
    end
  end

  defp check_down(_, _, _, ""), do: true

  defp check_down(grid, x, y, <<head::binary-size(1), rest::binary>>) do
    cond do
      y >= Enum.count(grid) -> false
      head == Enum.at(Enum.at(grid, y), x) -> check_down(grid, x, y + 1, rest)
      true -> false
    end
  end

  defp check_downleft(_, _, _, ""), do: true

  defp check_downleft(grid, x, y, <<head::binary-size(1), rest::binary>>) do
    cond do
      y >= Enum.count(grid) -> false
      x < 0 -> false
      head == Enum.at(Enum.at(grid, y), x) -> check_downleft(grid, x - 1, y + 1, rest)
      true -> false
    end
  end

  defp check_downright(_, _, _, ""), do: true

  defp check_downright(grid, x, y, <<head::binary-size(1), rest::binary>>) do
    cond do
      y >= Enum.count(grid) -> false
      x >= Enum.at(Enum.at(grid, y), x) -> false
      head == Enum.at(Enum.at(grid, y), x) -> check_downright(grid, x + 1, y + 1, rest)
      true -> false
    end
  end
end
