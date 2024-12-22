defmodule Chatbot.CLI do
  def main(args) do
    {parsed_args, _positional_args, _invalid_args} = parse_args(args)

    case parsed_args do
      [model: model, prompt: prompt] when is_binary(model) and is_binary(prompt) ->
        Chatbot.Commands.ask_with_model(model, prompt)

      [list: true] ->
        Chatbot.Commands.list()

      [show: model] when is_binary(model) ->
        Chatbot.Commands.show(model)

      [pull: model] when is_binary(model) ->
        Chatbot.Commands.pull(model)

      [help: true] ->
        IO.puts("""
        Użycie:
          ./chatbot --model=<nazwa_modelu> --prompt="<twoja wiadomość>"
          ./chatbot --list
          ./chatbot --show=<nazwa_modelu>
          ./chatbot --pull=<nazwa_modelu>
        """)

      _ ->
        IO.puts("Nieprawidłowe argumenty. Użyj --help, aby uzyskać pomoc.")
    end
  end

  defp parse_args(args) do
    OptionParser.parse(args, switches: [model: :string, prompt: :string, list: :boolean, show: :string, pull: :string, help: :boolean])
  end
end
