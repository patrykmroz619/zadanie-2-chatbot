defmodule Chatbot.Ollama do
  @base_url "http://localhost:11434/api"
  @headers [{"Content-Type", "application/json"}]

  def run_model(model, prompt) do
    url = "#{@base_url}/generate"
    body = %{"model" => model, "prompt" => prompt, "stream" => false}

    options = [
      recv_timeout: 50_000 # 50 seconds
    ]

    case HTTPoison.post(url, Jason.encode!(body), @headers, options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)["response"]}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def list_models() do
    url = "#{@base_url}/tags"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)["models"]}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def show_model(model) do
    url = "#{@base_url}/show"
    requestBody = %{"model" => model}

    case HTTPoison.post(url, Jason.encode!(requestBody), @headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Map.take(Jason.decode!(body), ["details", "model_info"])}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def pull_model(model) do
    url = "#{@base_url}/pull"
    body = %{"model" => model, "stream" => false}

      options = [
        recv_timeout: :infinity
      ]

      case HTTPoison.post(url, Jason.encode!(body), @headers, options) do
        {:ok, %HTTPoison.Response{status_code: 200}} ->
          {:ok, :pulled}

        {:error, %HTTPoison.Error{reason: reason}} ->
          {:error, reason}
      end
    end
end
