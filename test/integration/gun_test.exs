defmodule GunTest do
  use ExUnit.Case, async: false

  describe "httpstat.us" do
    setup do
      {:ok,
       host: 'httpstat.us',
       path: '/201',
       headers: [
         {'Accept', 'application/json'},
         {'Content-Type', 'application/json; charset=utf-8'}
       ],
       body: '{"title": "foo", "body": "bar", "userId": 1}'}
    end

    test "without proxy", %{host: host, path: path, headers: headers, body: body} do
      assert {:ok, conn} = :gun.open(host, 443)
      assert {:ok, :http} = :gun.await_up(conn)

      ref = :gun.post(conn, path, headers, body)
      assert {:response, :nofin, 201, response_headers} = :gun.await(conn, ref)
      assert {:ok, response_body} = :gun.await_body(conn, ref)

      IO.inspect(response_headers, label: "\n")
      IO.puts(response_body)
    end
  end

  describe "Correios API" do
    setup do
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

      options = %{tls_opts: [ciphers: ['AES256-SHA256'], versions: [:"tlsv1.2"]]}

      {:ok,
       host: 'apps.correios.com.br',
       path: '/SigepMasterJPA/AtendeClienteService/AtendeCliente',
       headers: [
         {'Accept', 'text/xml'},
         {'Content-Type', 'text/xml; charset=utf-8'}
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
      assert {:ok, conn} = :gun.open(host, 443, options)
      assert {:ok, :http} = :gun.await_up(conn)

      ref = :gun.post(conn, path, headers, body)
      assert {:response, :nofin, 200, response_headers} = :gun.await(conn, ref)
      assert {:ok, response_body} = :gun.await_body(conn, ref)

      IO.inspect(response_headers, label: "\n")
      IO.puts(response_body)
    end
  end
end
