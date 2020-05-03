defmodule HackneyTest do
  use ExUnit.Case, async: false

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
       body: ~s({"title": "foo", "body": "bar", "userId": 1}),
       options: [with_body: true]}
    end

    test "without proxy", %{
      url: url,
      headers: headers,
      body: body,
      options: options
    } do
      assert {:ok, 201, _headers, _body} = response = :hackney.post(url, headers, body, options)

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

      assert {:ok, 201, _headers, _body} = response = :hackney.post(url, headers, body, options)

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

      options = [
        ssl_options: [ciphers: ['AES256-SHA256'], versions: [:"tlsv1.2"]],
        with_body: true
      ]

      {:ok,
       url: "https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente",
       headers: [
         {"Accept", "text/xml"},
         {"Content-Type", "text/xml; charset=utf-8"}
       ],
       body: body,
       options: options}
    end

    test "without proxy", %{
      url: url,
      headers: headers,
      body: body,
      options: options
    } do
      assert {:ok, 200, _headers, _body} = response = :hackney.post(url, headers, body, options)

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

      assert {:ok, 200, _headers, _body} = response = :hackney.post(url, headers, body, options)

      IO.inspect(response, label: "\n")
    end
  end
end
