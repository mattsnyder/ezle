defmodule Ezle.Flow.StoryBoardTest do
  use ExUnit.Case, async: true
  alias Ezle.Flow.StoryBoard
  alias Ezle.Flow.StoryCard


  test "No stories on the board" do
    assert StoryBoard.completed_by_year_week([]) == []
  end

  test "One complete story on the board" do
    stories = [
      %StoryCard{completed_at: "2025-01-01T04:50:34Z"}
    ]
    assert StoryBoard.completed_by_year_week(stories) == [
      {"2025-01", 1}
    ]
  end

  test "Two complete stories on the board in same week" do
    stories = [
      %StoryCard{completed_at: "2025-01-01T09:10:11Z"},
      %StoryCard{completed_at: "2025-01-01T04:50:34Z"}
    ]
    assert StoryBoard.completed_by_year_week(stories) == [
      {"2025-01", 2}
    ]
  end

  test "Two complete stories on the board in different weeks" do
    stories = [
      %StoryCard{completed_at: "2025-01-01T09:10:11Z"},
      %StoryCard{completed_at: "2025-07-11T04:50:34Z"}
    ]
    assert StoryBoard.completed_by_year_week(stories) == [
      {"2025-01", 1},
      {"2025-28", 1}
    ]
  end

  test "One incomplete story on the board" do
    stories = [
      %StoryCard{started_at: "2025-01-01T09:10:11Z"}
    ]
    assert StoryBoard.completed_by_year_week(stories) == []
  end
end
