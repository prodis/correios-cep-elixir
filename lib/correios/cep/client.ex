defmodule Correios.CEP.Client do
  @moduledoc false

  @url "https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente"
  @headers [{"content-type", "text/xml; charset=utf-8"}]

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

  def request(zipcode) do
    @url
    |> HTTPoison.post(build_body(zipcode), @headers)
    |> response()
  end

  defp response({:ok, %{status_code: 200, body: body}}), do: {:ok, body}
  defp response({:ok, %{body: body}}), do: {:error, body}
  defp response({:error, %{reason: reason}}), do: {:error, reason}

  defp build_body(zipcode) do
    EEx.eval_string(@body_template, zipcode: zipcode)
  end
end
