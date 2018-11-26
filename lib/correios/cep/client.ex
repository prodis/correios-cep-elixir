defmodule Correios.CEP.Client do
  @moduledoc false

  @url "https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente"
  @headers [{"Content-Type", "text/xml; charset=utf-8"}]

  @body_template """
  <?xml version="1.0" encoding="UTF-8"?>
  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cli="http://cliente.bean.master.sigep.bsb.correios.com.br/">
    <soapenv:Header />
    <soapenv:Body>
      <cli:consultaCEP>
        <cep><%= zipcode %></cep>
      </cli:consultaCEP>
    </soapenv:Body>
  </soapenv:Envelope>
  """

  # Timeouts in miliseconds
  @options_config [
    %{cep: :connection_timeout, httpoison: :timeout, default: 5000},
    %{cep: :request_timeout, httpoison: :recv_timeout, default: 5000}
  ]

  def request(zipcode, options) do
    @url
    |> HTTPoison.post(body(zipcode), @headers, httpoison_options(options))
    |> response()
  end

  defp response({:ok, %{status_code: 200, body: body}}), do: {:ok, body}
  defp response({:ok, %{body: body}}), do: {:error, body}
  defp response({:error, %{reason: reason}}), do: {:error, reason}

  defp body(zipcode) do
    EEx.eval_string(@body_template, zipcode: zipcode)
  end

  defp httpoison_options(options) do
    Enum.map(@options_config, fn %{cep: cep, httpoison: httpoison, default: default} ->
      {httpoison, Keyword.get(options, cep, default)}
    end)
  end
end
