defmodule HttpcTest do
  use ExUnit.Case, async: false

  setup do
    proxy = [{:proxy, {{'localhost', 8888}, []}}]

    {:ok, proxy: proxy}
  end

  describe "httpstat.us" do
    setup do
      url = 'https://httpstat.us/201'
      headers = [{'Accept', 'application/json'}]
      content_type = 'application/json'
      body = '{"title": "foo", "body": "bar", "userId": 1}'

      {:ok, request: {url, headers, content_type, body}}
    end

    test "without proxy", %{request: request} do
      assert {:ok, {{'HTTP/1.1', 201, 'Created'}, _headers, _body} = response} =
               :httpc.request(:post, request, [], [])

      IO.inspect(response, label: "\n")
    end

    test "with proxy", %{request: request, proxy: proxy} do
      assert :httpc.set_options(proxy) == :ok

      assert {:ok, {{'HTTP/1.1', 201, 'Created'}, _headers, _body} = response} =
               :httpc.request(:post, request, [], [])

      IO.inspect(response, label: "\n")
    end
  end

  describe "Correios API" do
    setup do
      url = 'https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente'
      headers = [{'Accept', 'text/xmll'}]
      content_type = 'text/xml; charset=utf-8'

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

      http_options = [ssl: [ciphers: ['AES256-SHA256'], versions: [:"tlsv1.2"]]]

      {:ok, request: {url, headers, content_type, body}, http_options: http_options}
    end

    test "without proxy", %{request: request, http_options: http_options} do
      assert {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, body} = response} =
               :httpc.request(:post, request, http_options, [])

      IO.inspect(response, label: "\n")
      IO.puts(body)
    end

    test "with proxy", %{request: request, http_options: http_options, proxy: proxy} do
      assert :httpc.set_options(proxy) == :ok

      assert {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, body} = response} =
               :httpc.request(:post, request, http_options, [])

      IO.inspect(response, label: "\n")
      IO.puts(body)
    end
  end
end
