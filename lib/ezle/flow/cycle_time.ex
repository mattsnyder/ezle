defmodule Ezle.Flow.CycleTime do
  use Timex

  alias Timex.Interval
  alias Timex.Parse.DateTime.Parser

  @sunday "Sun"
  @saturday "Sat"

  # CycleTime.weekdays_elapsed(Map.get(story, start_at), Map.get(story, end_at))
  def weekdays_elapsed(start_at, finish_at) when is_binary(start_at) and is_binary(finish_at) do
    {:ok, start} = Parser.parse(start_at, "{ISO:Extended:Z}")
    {:ok, finish} = Parser.parse(finish_at, "{ISO:Extended:Z}")
    weekdays_elapsed(start, finish)
  end

  def weekdays_elapsed(last_updated_at, compare_to) when last_updated_at == compare_to, do: 1

  def weekdays_elapsed(last_updated_at, compare_to) do
    Interval.new(from: last_updated_at, until: compare_to)
    |> Interval.with_step(days: 1)
    |> Enum.map(&Timex.format!(&1, "%a", :strftime))
    |> Enum.filter(&weekday/1)
    |> Enum.count()
  end

  defp weekday(@sunday), do: false
  defp weekday(@saturday), do: false
  defp weekday(_), do: true
end
