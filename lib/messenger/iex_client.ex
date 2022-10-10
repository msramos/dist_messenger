defmodule Messenger.IExClient do
  alias Messenger.Messaging

  def signin(user) do
    case Messaging.sign_in(user) do
      :ok ->
        IO.puts("Signed in!")

      _error ->
        IO.puts("Error: Already signed in!")
    end
  end

  def signout do
    case Messaging.sign_out() do
      :ok ->
        IO.puts("Signed out!")

      _ ->
        IO.puts("Error: Not signed in.")
    end
  end

  def whoami do
    case Messaging.whoami() do
      {:ok, user} ->
        IO.puts("Signed in as #{user}")

      _ ->
        IO.puts("Not signed in!")
    end
  end

  def inbox do
    case Messaging.inbox() do
      {:ok, []} ->
        IO.puts("Inbox is empty!")

      {:ok, inbox} ->
        Enum.each(inbox, fn {from, msg} ->
          IO.puts("> from: #{from}\n> #{msg}\n---")
        end)

      _error ->
        IO.puts("Error: Not signed in!")
    end
  end

  def last_msg do
    case Messaging.last_message() do
      {:ok, :empty} ->
        IO.puts("Inbox is empty!")

      {:ok, {from, msg}} ->
        IO.puts("> from: #{from}\n> #{msg}\n---")

      _error ->
        IO.puts("Error: Not signed in!")
    end
  end

  def sent do
    case Messaging.sent() do
      {:ok, []} ->
        IO.puts("No messages sent")

      {:ok, msgs} ->
        Enum.each(msgs, fn {to, msg} ->
          IO.puts("> to: #{to}\n> #{msg}\n---")
        end)

      _error ->
        IO.puts("Error: Not signed in!")
    end
  end

  def msg(recipient, message) do
    case Messaging.send_message(recipient, message) do
      :ok ->
        IO.puts("Message sent!")

      {:error, :recipient_not_found} ->
        IO.puts("Error: Recipient not found!")

      {:error, :not_signed_in} ->
        IO.puts("Error: Not signed in!")
    end
  end

  def editor do
    case Messaging.whoami() do
      {:ok, _user} ->
        recipient = IO.gets("recipient: ") |> String.trim()
        message = IO.gets("message: ") |> String.trim()

        msg(recipient, message)

      _ ->
        IO.puts("Not signed in!")
    end
  end
end
