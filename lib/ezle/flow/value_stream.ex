defmodule Ezle.Flow.ValueStream do
  use Timex

  alias Ezle.Flow.StoryBoard
  alias Ezle.Flow.CycleTime

  # TODO: Get manager out of method, for now serving as shortcut for CLI
  def inspect_time_to_ship(stories) do
    stories
    |> Map.values()
    |> StoryBoard.filter_by_type(:feature)
    |> StoryBoard.sort_by(:completed_at)
    |> Enum.take(10)
    |> cycle_time_avg_with_meta(
      :started_at,
      :completed_at
      )
  end

  def cycle_time_avg_with_meta(stories, start_at, end_at)
    when is_list(stories)
    when is_atom(start_at) and is_atom(end_at) do

    stories
    |> Enum.map(fn story -> [story.id, story.name, CycleTime.weekdays_elapsed(Map.get(story, start_at), Map.get(story, end_at))] end)
  end

  def cycle_time_avg(stories, start_at, end_at)
    when is_list(stories)
    when is_atom(start_at) and is_atom(end_at) do

    stories
    |> Enum.map(fn story -> CycleTime.weekdays_elapsed(Map.get(story, start_at), Map.get(story, end_at)) end)
    |> Enum.sum()
    |> div(Enum.count(stories))
  end
end
