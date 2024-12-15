defmodule Chatbot.State do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def set_model(model_name) do
    GenServer.cast(__MODULE__, {:set_model, model_name})
  end

  def get_model() do
    GenServer.call(__MODULE__, :get_model)
  end

  def init(_) do
    {:ok, %{connected_model: nil}}
  end

  def handle_cast({:set_model, model_name}, state) do
    {:noreply, %{state | connected_model: model_name}}
  end

  def handle_call(:get_model, _from, state) do
    {:reply, state.connected_model, state}
  end
end
