defmodule AdventOfCode.Day02 do
  def part1(input) do
    input
    |> create_reports()
    |> Enum.map(&check_report/1)
    |> Enum.count(&(&1 == :valid))
  end

  def part2(input) do
    input
    |> create_reports()
    |> Enum.map(fn report ->
      if check_report(report) == :valid do
        :valid
      else
        Enum.reduce_while(report, {0, report}, fn _, {count, report} ->
          new_report =
            Enum.slice(report, 0, count) ++
              Enum.slice(report, count + 1, Enum.count(report) - count)

          if check_report(new_report) == :valid do
            {:halt, :valid}
          else
            {:cont, {count + 1, report}}
          end
        end)
      end
    end)
    |> Enum.count(&(&1 == :valid))
  end

  defp create_reports(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn report ->
      report
      |> String.split(" ", trim: true)
      |> Enum.map(fn level ->
        String.to_integer(level)
      end)
    end)
  end

  defp check_report([first | [next | report]]) do
    cond do
      check_next_level(first, next) == false -> :invalid
      first < next -> check_report_next(:inc, next, report)
      first > next -> check_report_next(:dec, next, report)
      true -> :invalid
    end
  end

  defp check_report_next(dir, curr, report, opts \\ [])
  defp check_report_next(_, _, [], _), do: :valid

  defp check_report_next(:inc, curr, [next | report], opts) do
    cond do
      curr < next && check_next_level(curr, next) ->
        check_report_next(:inc, next, report, opts)

      true ->
        :invalid
    end
  end

  defp check_report_next(:dec, curr, [next | report], opts) do
    cond do
      curr > next && check_next_level(curr, next) ->
        check_report_next(:dec, next, report, opts)

      true ->
        :invalid
    end
  end

  defp check_next_level(curr, next) do
    diff = abs(curr - next)
    diff >= 1 && diff <= 3
  end
end
