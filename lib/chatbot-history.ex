defmodule Chatbot.History do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def save_message(message) do
    GenServer.call(__MODULE__, {:save_message, message})
  end

  def get_history do
    GenServer.call(__MODULE__, :get_history)
  end

  def init(_) do
    {:ok, []}
  end

  def handle_call({:save_message, message}, _from, state) do
    {:reply, :ok, [message | state]}
  end

  def handle_call(:get_history, _from, state) do
    {:reply, Enum.reverse(state), state}
  end
end
