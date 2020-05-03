defmodule IbrowseTest do
  use ExUnit.Case, async: false

  setup do
    proxy_options = [proxy_host: 'localhost', proxy_port: 8888]

    {:ok, proxy_options: proxy_options}
  end

  describe "httpstat.us" do
    setup do
      url = 'https://httpstat.us/201'

      headers = [
        {'Accept', 'application/json'},
        {'Content-Type', 'application/json; charset=utf-8'}
      ]

      body = '{"title": "foo", "body": "bar", "userId": 1}'

      {:ok, url: url, headers: headers, body: body}
    end

    test "without proxy", %{url: url, headers: headers, body: body} do
      assert {:ok, '201', _headers, _body} =
               response = :ibrowse.send_req(url, headers, :post, [body])

      IO.inspect(response, label: "\n")
    end

    test "with proxy", %{url: url, headers: headers, body: body, proxy_options: proxy_options} do
      assert {:ok, '201', _headers, _body} =
               response = :ibrowse.send_req(url, headers, :post, [body], proxy_options)

      IO.inspect(response, label: "\n")
    end
  end

  describe "Correios API" do
    setup do
      url = 'https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente'

      headers = [
        {'Accept', 'text/xmll'},
        {'Content-Type', 'text/xml; charset=utf-8'}
      ]

      body =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cli="http://cliente.bean.master.sigep.bsb.correios.com.br/">
          <soapenv:Header />
          <soapenv:Body>
            <cli:consultaCEP>
              <cep>54250-610</cep>
            </cli:consultaCEP>
          </soapenv:Body>
        </soapenv:Envelope>
        """
        |> String.to_charlist()

      options = [ssl_options: [ciphers: ['AES256-SHA256'], versions: [:"tlsv1.2"]]]

      {:ok, url: url, headers: headers, body: body, options: options}
    end

    test "without proxy", %{url: url, headers: headers, body: body, options: options} do
      assert {:ok, '200', _headers, response_body} =
               response = :ibrowse.send_req(url, headers, :post, [body], options)

      IO.inspect(response, label: "\n")
      IO.puts(response_body)
    end

    test "with proxy", %{
      url: url,
      headers: headers,
      body: body,
      options: options,
      proxy_options: proxy_options
    } do
      options = Keyword.merge(options, proxy_options)

      assert {:ok, '200', _headers, response_body} =
               response = :ibrowse.send_req(url, headers, :post, [body], options)

      IO.inspect(response, label: "\n")
      IO.puts(response_body)
    end
  end
end
