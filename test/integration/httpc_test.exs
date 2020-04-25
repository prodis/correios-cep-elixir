defmodule HttpcTest do
  use ExUnit.Case, async: false

  setup do
    :inets.start()
    :ssl.start()
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
              <cep>13212-070</cep>
            </cli:consultaCEP>
          </soapenv:Body>
        </soapenv:Envelope>
        """
        |> String.to_charlist()

      {:ok, request: {url, headers, content_type, body}}
    end

    test "without proxy", %{request: request} do
      assert {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, _body} = response} =
               :httpc.request(:post, request, [], [])

      IO.inspect(response, label: "\n")
    end

    test "with proxy", %{request: request, proxy: proxy} do
      assert :httpc.set_options(proxy) == :ok

      assert {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, _body} = response} =
               :httpc.request(:post, request, [], [])

      IO.inspect(response, label: "\n")
    end
  end
end
