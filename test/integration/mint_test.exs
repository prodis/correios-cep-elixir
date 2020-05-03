defmodule MintTest do
  use ExUnit.Case, async: false

  setup do
    proxy = {:http, "localhost", 8888, []}

    {:ok, proxy: proxy}
  end

  describe "httpstat.us" do
    setup do
      {:ok,
       host: "httpstat.us",
       path: "/201",
       headers: [
         {"Accept", "application/json"},
         {"Content-Type", "application/json; charset=utf-8"}
       ],
       body: ~s({"title": "foo", "body": "bar", "userId": 1})}
    end

    test "without proxy", %{host: host, path: path, headers: headers, body: body} do
      assert {:ok, conn} = Mint.HTTP.connect(:https, host, 443)
      assert {:ok, conn, _request_ref} = Mint.HTTP.request(conn, "POST", path, headers, body)

      receive do
        message ->
          {:ok, _conn, responses} = Mint.HTTP.stream(conn, message)
          IO.inspect(responses)
      end
    end

    test "with proxy", %{host: host, path: path, headers: headers, body: body, proxy: proxy} do
      assert {:ok, conn} = Mint.HTTP.connect(:https, host, 443, proxy: proxy)
      assert {:ok, conn, _request_ref} = Mint.HTTP.request(conn, "POST", path, headers, body)

      receive do
        message ->
          {:ok, _conn, responses} = Mint.HTTP.stream(conn, message)
          IO.inspect(responses)
      end
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

      options = [transport_opts: [ciphers: ['AES256-SHA256'], versions: [:"tlsv1.2"]]]

      {:ok,
       host: "apps.correios.com.br",
       path: "/SigepMasterJPA/AtendeClienteService/AtendeCliente",
       headers: [
         {"Accept", "text/xml"},
         {"Content-Type", "text/xml; charset=utf-8"}
       ],
       body: body,
       options: options}
    end

    test "without proxy", %{
      host: host,
      path: path,
      headers: headers,
      body: body,
      options: options
    } do
      assert {:ok, conn} = Mint.HTTP.connect(:https, host, 443, options)
      assert {:ok, conn, _request_ref} = Mint.HTTP.request(conn, "POST", path, headers, body)

      receive do
        message ->
          {:ok, _conn, responses} = Mint.HTTP.stream(conn, message)
          IO.inspect(responses)
      end
    end

    test "with proxy", %{
      host: host,
      path: path,
      headers: headers,
      body: body,
      options: options,
      proxy: proxy
    } do
      options = Keyword.put(options, :proxy, proxy)

      assert {:ok, conn} = Mint.HTTP.connect(:https, host, 443, options)
      assert {:ok, conn, _request_ref} = Mint.HTTP.request(conn, "POST", path, headers, body)

      receive do
        message ->
          {:ok, _conn, responses} = Mint.HTTP.stream(conn, message)
          IO.inspect(responses)
      end
    end
  end
end
