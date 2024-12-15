defmodule Chatbot.Commands do
  defp ensure_state_started do
    case Process.whereis(Chatbot.State) do
      nil -> Chatbot.State.start_link(nil)
      _ -> :ok
    end
  end

  def model(model_name) do
    ensure_state_started()
    case Chatbot.Ollama.list_models() do
      {:ok, modelsData} ->
        models = Enum.map(modelsData, fn model -> model["name"] end)
        if Enum.member?(models, model_name) do
          Chatbot.State.set_model(model_name)
          IO.puts("Model #{model_name} został wybrany.")
        else
          IO.puts("Model #{model_name} nie został jeszcze pobrany. Pobierz model za pomocą komendy 'pull(#{model_name})'.")
        end
      {:error, reason} -> IO.puts("Błąd w pobraniu listy modeli: #{reason}")
    end
  end

  def ask(prompt) do
    ensure_state_started()
    case Chatbot.State.get_model() do
      nil -> IO.puts("Nie wybrano modelu. Wybierz model za pomocą komendy 'model(<model_name>)'.")
      model ->
        case Chatbot.Ollama.run_model(model, prompt) do
          {:ok, response} ->
            IO.puts("Odpowiedź modelu:")
            IO.puts(response)

          {:error, reason} -> IO.puts("Error: #{reason}")
        end
    end
  end

  def list do
    case Chatbot.Ollama.list_models() do
      {:ok, models} ->
        IO.puts("Lista dostępnych modeli:")
        Enum.each(models, fn model -> IO.puts(model["name"]) end)
      {:error, reason} -> IO.puts("Błąd w pobraniu listy modeli: #{reason}")
    end
  end

  def show(model_name) do
    case Chatbot.Ollama.show_model(model_name) do
      {:ok, details} ->
        IO.puts("Szczegóły modelu #{model_name}:")
        IO.inspect(details, pretty: true)
      {:error, reason} -> IO.puts("Błąd w pobraniu szczegółów modelu: #{reason}")
    end
  end

  def pull(model_name) do
    IO.puts("Rozpoczęto pobieranie modelu o nazwie #{model_name}...")
    case Chatbot.Ollama.pull_model(model_name) do
      {:ok, _} -> IO.puts("Pomyślnie pobrano model o nazwie #{model_name}.")
      {:error, reason} -> IO.puts("Błąd podczas pobierania modelu: #{reason}")
    end
  end
end
