defmodule EzleWeb.DashboardLive.Index do
  use EzleWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
    {@chart_title} <canvas id="my-chart" phx-hook="ChartJS" data-points={Jason.encode!(@points)}></canvas>
      <div class="flex flex-row justify-center gap-4">
        <.button phx-click="change-data" phx-value-set="1">SET 1</.button>
        <.button phx-click="change-data" phx-value-set="2">SET 2</.button>
        <.button phx-click="change-data" phx-value-set="3">SET 3</.button>
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
      case set do
        "1" -> %{type: :line, points: [1, 2, -1, 4, 5], labels: ["2025-06", "2025-07", "2025-08", "2025-09", "2025-10"]}
        "2" -> %{type: :bar, points: [10, 2, 8, 3, 9], labels: ["2025-06", "2025-07", "2025-08", "2025-09", "2025-10"]}
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
