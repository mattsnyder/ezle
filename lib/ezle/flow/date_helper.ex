defmodule Ezle.Flow.DateHelper do
  use Timex
  alias Timex.Parse.DateTime.Parser

  @doc ~S"""
      iex> "2025-01-01T04:50:34Z" |> Ezle.Flow.DateHelper.year_week
      "2025-01"

      iex> "2025-01-06T13:50:34Z" |> Ezle.Flow.DateHelper.year_week
      "2025-02"

      iex> "2025-11-04T13:50:34Z" |> Ezle.Flow.DateHelper.year_week
      "2025-45"

      iex> "" |> Ezle.Flow.DateHelper.year_week
      nil

      iex> nil |> Ezle.Flow.DateHelper.year_week
      nil
  """
  def year_week(nil), do: nil
  def year_week(""), do: nil

  def year_week(date) do
    date
    |> Parser.parse!("{ISO:Extended:Z}")
    |> Timex.iso_week
    |> format_year_week
  end

  defp format_year_week({year, week_num}) do
    [
      Integer.to_string(year),
      String.pad_leading(Integer.to_string(week_num), 2, "0")
    ] |> Enum.join("-")
  end
end
