defmodule Ezle.Flow.StoryBoard do
  use Timex
  alias Timex.Parse.DateTime.Parser

  def filter_by_type(stories, type)
    when is_list(stories)
    when type in [:feature,:defect, :chore] do

    Enum.filter(stories, fn story -> story.story_type == type end)
  end

  def sort_by(stories, attribute \\ :id)
    when is_list(stories) do

    stories
    |> Enum.sort(&(before?(Map.get(&2, attribute), Map.get(&1, attribute))))
  end

  def before?(nil, _), do: true
  def before?(_, nil), do: false

  def before?(date_string1, date_string2) do
    {:ok, date1} = Parser.parse(date_string1, "{ISO:Extended:Z}")
    {:ok, date2} = Parser.parse(date_string2, "{ISO:Extended:Z}")

    Timex.before?(date1, date2)
  end

  def completed_by_year_week(stories) do
    year_weeks = Enum.map(stories, fn s -> Ezle.Flow.DateHelper.year_week(s.completed_at) end)

    year_weeks
    |> Enum.uniq
    |> Enum.filter(fn yw -> yw > "" end)
    |> Enum.map(fn yw -> {yw, Enum.count(year_weeks, fn completed_yw -> completed_yw == yw end)} end)
  end
end
