defmodule Correios.CEP.Client do
  @moduledoc """
  HTTP client for Correios API.
  """

  alias HTTPoison.{Error, Response}

  @type t :: {:ok, String.t()} | {:error, String.t()}

  @default_url "https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente"

  @headers [
    {"Content-Type", "text/xml; charset=utf-8"},
    {"User-Agent", "correios-cep-elixir/#{Mix.Project.config()[:version]}"}
  ]

  @doc """
  Makes a HTTP request to Correios API using the given `zipcode` and `options`.

  ## Examples

      #{inspect(__MODULE__)}.request("54250-610", [])
      {:ok, "..."}

      #{inspect(__MODULE__)}.request("54250-610", [])
      {:error, "..."}

  """
  @spec request(String.t(), keyword()) :: t()
  def request(zipcode, options) do
    url = build_url(options)
    body = build_body(zipcode)
    http_options = build_http_options(options)

    url
    |> HTTPoison.post(body, @headers, http_options)
    |> handle_response()
  end

  @spec build_url(keyword()) :: String.t()
  defp build_url(options), do: Keyword.get(options, :url, @default_url)

  @spec build_body(String.t()) :: String.t()
  defp build_body(zipcode) do
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cli="http://cliente.bean.master.sigep.bsb.correios.com.br/">
      <soapenv:Header />
      <soapenv:Body>
        <cli:consultaCEP>
          <cep>#{zipcode}</cep>
        </cli:consultaCEP>
      </soapenv:Body>
    </soapenv:Envelope>
    """
  end

  @spec build_http_options(keyword()) :: keyword()
  defp build_http_options(options) do
    # Timeouts in miliseconds
    [
      timeout: Keyword.get(options, :connection_timeout, 5000),
      recv_timeout: Keyword.get(options, :request_timeout, 5000)
    ]
  end

  @spec handle_response({:ok, Response.t()} | {:error, Error.t()}) :: t()
  defp handle_response({:ok, %Response{status_code: 200, body: body}}), do: {:ok, body}
  defp handle_response({:ok, %Response{body: body}}), do: {:error, body}

  defp handle_response({:error, %Error{reason: reason}}) when is_binary(reason),
    do: {:error, reason}

  defp handle_response({:error, %Error{reason: reason}}),
    do: {:error, inspect(reason)}
end
