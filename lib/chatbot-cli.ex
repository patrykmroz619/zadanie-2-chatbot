defmodule Chatbot.CLI do
  def main(args) do
    case parse_args(args) do
      {:ok, %{model: model, prompt: prompt}} ->
        run_model_prompt(model, prompt)

      {:ok, %{list: true}} ->
        list_models()

      {:ok, %{show: model}} ->
        show_model(model)

      {:ok, %{pull: model}} ->
        pull_model(model)

      :help ->
        IO.puts("""
        Usage:
          ./chatbot --model=<model_name> --prompt="<your prompt>"
          ./chatbot --list
          ./chatbot --show=<model_name>
          ./chatbot --pull=<model_name>
        """)

      _ ->
        IO.puts("Invalid arguments. Use --help for usage.")
    end
  end

  defp parse_args(args) do
    OptionParser.parse(args, switches: [model: :string, prompt: :string, list: :boolean, show: :string, pull: :string])
  end

  defp run_model_prompt(model, prompt) do
    case Chatbot.Ollama.run_model(model, prompt) do
      {:ok, response} -> IO.puts(response)
      {:error, reason} -> IO.puts("Error: #{reason}")
    end
  end

  defp list_models() do
    case Chatbot.Ollama.list_models() do
      {:ok, models} -> Enum.each(models, &IO.puts/1)
      {:error, reason} -> IO.puts("Error: #{reason}")
    end
  end

  defp show_model(model) do
    case Chatbot.Ollama.show_model(model) do
      {:ok, details} -> IO.inspect(details, pretty: true)
      {:error, reason} -> IO.puts("Error: #{reason}")
    end
  end

  defp pull_model(model) do
    case Chatbot.Ollama.pull_model(model) do
      {:ok, _} -> IO.puts("Model #{model} pulled successfully.")
      {:error, reason} -> IO.puts("Error: #{reason}")
    end
  end
end
