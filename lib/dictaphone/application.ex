defmodule Dictaphone.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    pubsub = case System.get_env("REDIS_URL") do
      nil ->
       {Phoenix.PubSub, name: Dictaphone.PubSub}
      url ->
       { Phoenix.PubSub,
         name: Dictaphone.PubSub,
         adapter: Phoenix.PubSub.Redis,
         url: url,
         node_name: System.get_env("NODE")
       }
    end

    children = [
      DictaphoneWeb.Telemetry,
      Dictaphone.Repo,
      {DNSCluster, query: Application.get_env(:dictaphone, :dns_cluster_query) || :ignore},
      pubsub,
      # Start the Finch HTTP client for sending emails
      {Finch, name: Dictaphone.Finch},
      # Start a worker by calling: Dictaphone.Worker.start_link(arg)
      # {Dictaphone.Worker, arg},
      # Start to serve requests, typically the last entry
      DictaphoneWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dictaphone.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DictaphoneWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
