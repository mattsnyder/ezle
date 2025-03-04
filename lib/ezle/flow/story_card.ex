defmodule Ezle.Flow.StoryCard do
  @doc ~S"""

  ## Examples

      iex> %Ezle.Flow.StoryCard{title: "Feature A", started_at: "", completed_at: "", type_of_work: "Feature"}
      %Ezle.Flow.StoryCard{title: "Feature A", started_at: "", completed_at: "", type_of_work: "Feature"}

      iex> card = %Ezle.Flow.StoryCard{}
      iex> card.type_of_work
      :feature
  """
  defstruct [
    :title,
    :started_at,
    :completed_at,
    type_of_work: :feature
  ]
end
