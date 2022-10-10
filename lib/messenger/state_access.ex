defmodule Messenger.StateAccess do
  defmacro __using__(_) do
    quote do
      require Messenger.StateAccess
      import Messenger.StateAccess
    end
  end

  defmacro public(state, do: block) do
    quote do
      case unquote(state) do
        %{} ->
          {:reply, {:error, :already_signed_in}, unquote(state)}

        _ ->
          unquote(block)
      end
    end
  end

  defmacro private(state, do: block) do
    quote do
      case unquote(state) do
        nil ->
          {:reply, {:error, :not_signed_in}, unquote(state)}

        _ ->
          unquote(block)
      end
    end
  end
end
