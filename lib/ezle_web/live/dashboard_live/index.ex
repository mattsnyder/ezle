defmodule EzleWeb.DashboardLive.Index do
  use EzleWeb, :live_view
  alias Ezle.Flow.StoryCard

  @impl true
  def render(assigns) do
    ~H"""
    <div>
    {@chart_title} <canvas id="my-chart" phx-hook="ChartJS" data-points={Jason.encode!(@points)}></canvas>
      <div class="flex flex-row justify-center gap-4">
        <.button phx-click="change-data" phx-value-set="throughput">Throughput</.button>
        <.button phx-click="change-data" phx-value-set="planned">Planned vs Unplanned</.button>
        <.button phx-click="change-data" phx-value-set="predictability">Predictability</.button>
        <.button phx-click="change-data" phx-value-set="quality">Quality</.button>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(:chart_title, "Team Dashboard")
      |> assign(:points, [1, 2, 3, 4, 5])
      |> assign(:type, :bar)
    }
  end

  @impl true
  def handle_event("change-data", %{"set" => set}, socket) do
    options =
      case String.to_existing_atom(set) do
        :throughput -> throughput_completed(stories())
        :planned -> %{type: :line, points: [1, 2, -1, 4, 5], labels: ["2025-06", "2025-07", "2025-08", "2025-09", "2025-10"]}
        :predictability -> %{type: :bar, points: [10, 2, 8, 3, 9], labels: ["2025-06", "2025-07", "2025-08", "2025-09", "2025-10"]}
        :quality -> %{type: :bar, points: [10, 2, 8, 3, 9], labels: ["2025-06", "2025-07", "2025-08", "2025-09", "2025-10"]}
        _ -> %{type: :bar, points: [5, 4, 3, 2, 1], labels: ["2025-06", "2025-07", "2025-08", "2025-09", "2025-10"]}
      end

    {:noreply,
      socket
      |> push_event("update-chart", options)}
  end

  @impl true
  def handle_event(event, unsigned_params, socket) do
    dbg({event, unsigned_params})
    {:noreply, socket}
  end

  defp throughput_completed(stories) do
    data = Ezle.Flow.StoryBoard.completed_by_year_week(stories)

    %{
      type: :line,
      points: data |> Enum.map(fn ({_, count}) -> count end),
      labels: data |> Enum.map(fn ({yw, _}) -> yw end)
    }
  end

  defp stories do
    [
      %StoryCard{title: "Started", started_at: "2025-03-04T09:10:11Z"},
      %StoryCard{title: "Same Day", started_at: "2025-03-04T09:10:11Z", completed_at: "2005-03-04T09:10:11Z"},
      %StoryCard{title: "Same Day", started_at: "2025-03-04T09:10:11Z", completed_at: "2005-03-04T09:10:11Z"},
      %StoryCard{title: "Long time", started_at: "2025-03-15T09:10:11Z"},
      %StoryCard{title: "Last Week A", started_at: "2025-03-26T09:10:11Z"},
      %StoryCard{title: "Last Week B", started_at: "2025-03-24T09:10:11Z"},
      %StoryCard{title: "Last Week C", started_at: "2025-03-26T09:10:11Z", completed_at: "2025-03-28T09:10:11Z"},
      %StoryCard{title: "Mar Week 2", started_at: "2025-03-17T09:10:11Z", completed_at: "2025-03-21T09:10:11Z"},
      %StoryCard{title: "Mar Week 1", started_at: "2025-03-10T09:10:11Z", completed_at: "2025-03-14T09:10:11Z"},
      %StoryCard{title: "Mar Week 1", started_at: "2025-03-10T09:10:11Z", completed_at: "2025-03-14T09:10:11Z"},
      %StoryCard{title: "Mar Week 1", started_at: "2025-03-10T09:10:11Z", completed_at: "2025-03-14T09:10:11Z"},
      %StoryCard{title: "Feb Week 4", started_at: "2025-02-24T09:10:11Z", completed_at: "2025-02-28T09:10:11Z"},
      %StoryCard{title: "Feb Week 3", started_at: "2025-02-17T09:10:11Z", completed_at: "2025-02-21T09:10:11Z"},
      %StoryCard{title: "Feb Week 2", started_at: "2025-02-10T09:10:11Z", completed_at: "2025-02-14T09:10:11Z"},
      %StoryCard{title: "Feb Week 1", started_at: "2025-02-3T09:10:11Z", completed_at: "2025-02-07T09:10:11Z"},
      %StoryCard{title: "Feb Week 1", started_at: "2025-02-3T09:10:11Z", completed_at: "2025-02-07T09:10:11Z"}
    ]
  end
end
