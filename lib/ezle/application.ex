defmodule Ezle.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EzleWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:ezle, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Ezle.PubSub},
      # Start a worker by calling: Ezle.Worker.start_link(arg)
      # {Ezle.Worker, arg},
      # Start to serve requests, typically the last entry
      EzleWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ezle.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EzleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
