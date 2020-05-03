defmodule HTTPoisonTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, proxy: {"localhost", 8888}}
  end

  describe "httpstat.us" do
    setup do
      {:ok,
       url: "https://httpstat.us/201",
       headers: [
         {"Accept", "application/json"},
         {"Content-Type", "application/json; charset=utf-8"}
       ],
       body: ~s({"title": "foo", "body": "bar", "userId": 1})}
    end

    test "without proxy", %{url: url, headers: headers, body: body} do
      assert {:ok, %HTTPoison.Response{status_code: 201} = response} =
               HTTPoison.post(url, body, headers)

      IO.inspect(response, label: "\n")
    end

    test "with proxy", %{url: url, headers: headers, body: body, proxy: proxy} do
      assert {:ok, %HTTPoison.Response{status_code: 201} = response} =
               HTTPoison.post(url, body, headers, proxy: proxy)

      IO.inspect(response, label: "\n")
    end
  end

  describe "Correios API" do
    setup do
      body = """
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

      options = [ssl: [ciphers: ['AES256-SHA256'], versions: [:"tlsv1.2"]]]

      {:ok,
       url: "https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente",
       headers: [
         {"Accept", "text/xml"},
         {"Content-Type", "text/xml; charset=utf-8"}
       ],
       body: body,
       options: options}
    end

    test "without proxy and default SSL options", %{
      url: url,
      headers: headers,
      body: body
    } do
      assert {:ok, %HTTPoison.Response{status_code: 200} = response} =
               HTTPoison.post(url, body, headers)

      IO.inspect(response, label: "\n")
    end

    test "without proxy and custom SSL options", %{
      url: url,
      headers: headers,
      body: body,
      options: options
    } do
      assert {:ok, %HTTPoison.Response{status_code: 200} = response} =
               HTTPoison.post(url, body, headers, options)

      IO.inspect(response, label: "\n")
    end

    test "with proxy", %{
      url: url,
      headers: headers,
      body: body,
      options: options,
      proxy: proxy
    } do
      options = Keyword.put(options, :proxy, proxy)

      assert {:ok, %HTTPoison.Response{status_code: 200} = response} =
               HTTPoison.post(url, body, headers, options)

      IO.inspect(response, label: "\n")
    end
  end
end
