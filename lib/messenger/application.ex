defmodule Messenger.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Messenger.MessagingServer
    ]

    opts = [strategy: :one_for_one, name: Messenger.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
