defmodule Messenger.Messaging do
  alias Messenger.MessagingServer

  def sign_in(user, notify_fun \\ nil) do
    GenServer.call(MessagingServer, {:sign_in, user, notify_fun})
  end

  def sign_out do
    GenServer.call(MessagingServer, :sign_out)
  end

  def send_message(user, message) do
    GenServer.call(MessagingServer, {:send, user, message})
  end

  def sent do
    GenServer.call(MessagingServer, :sent)
  end

  def inbox do
    GenServer.call(MessagingServer, :inbox)
  end

  def last_message do
    GenServer.call(MessagingServer, :last_message)
  end

  def whoami do
    GenServer.call(MessagingServer, :whoami)
  end
end
