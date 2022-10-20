defmodule Messenger.MessagingServer do
  use GenServer

  use Messenger.StateAccess

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:sign_in, user, notify_fun}, _from, state) do
    public state do
      case :global.register_name({:user, user}, self()) do
        :yes ->
          {:reply, :ok, %{user: user, inbox: [], sent: [], notify_fun: notify_fun}}

        :no ->
          {:reply, {:error, :user_already_signed_in}, state}
      end
    end
  end

  def handle_call(:sign_out, _from, state) do
    private state do
      user = state[:user]
      :global.unregister_name({:user, user})

      {:reply, :ok, nil}
    end
  end

  def handle_call(:inbox, _from, state) do
    private state do
      inbox = state[:inbox]
      {:reply, {:ok, inbox}, state}
    end
  end

  def handle_call(:last_message, _from, state) do
    private state do
      case state[:inbox] do
        [last_message | _] ->
          {:reply, {:ok, last_message}, state}

        _inbox ->
          {:reply, {:ok, :empty}, state}
      end
    end
  end

  def handle_call(:sent, _from, state) do
    private state do
      {:reply, {:ok, state[:sent]}, state}
    end
  end

  def handle_call({:send, recipient, body}, _from, state) do
    private state do
      send_message(recipient, body, state)
    end
  end

  def handle_call(:whoami, _from, state) do
    private state do
      {:reply, {:ok, state[:user]}, state}
    end
  end

  def handle_info({:msg, from, body}, %{inbox: inbox} = state) do
    case state[:notify_fun] do
      nil ->
        notify(from)

      f ->
        f.(from)
    end

    message = {from, body}
    updated_state = %{state | inbox: [message | inbox]}

    {:noreply, updated_state}
  end

  defp send_message(recipient, body, state) do
    case :global.whereis_name({:user, recipient}) do
      :undefined ->
        {:reply, {:error, :recipient_not_found}, state}

      pid ->
        send(pid, {:msg, state[:user], body})

        sent = [{recipient, body} | state[:sent]]
        {:reply, :ok, Map.put(state, :sent, sent)}
    end
  end

  defp notify(from) do
    IO.puts("\n[!] New message from #{from}")
  end
end
