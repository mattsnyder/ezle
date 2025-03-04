defmodule EzleWeb.DashboardLive.Index do
  use EzleWeb, :live_view

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
        :throughput -> %{type: :line, points: [1, 2, -1, 4, 5], labels: ["2025-06", "2025-07", "2025-08", "2025-09", "2025-10"]}
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

end
