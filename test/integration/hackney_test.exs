defmodule HackneyTest do
  use ExUnit.Case, async: false

  setup do
    {:ok, proxy: {"localhost", 8888}}
  end

  describe "JSON Placeholder" do
    setup do
      {:ok,
       url: "https://jsonplaceholder.typicode.com/todos",
       headers: [{"Content-Type", "application/json; charset=utf-8"}],
       body: ~s({"title": "foo", "body": "bar", "userId": 1})}
    end

    test "without proxy", %{url: url, headers: headers, body: body} do
      assert {:ok, 201, _, response_body} =
               :hackney.post(url, headers, body,
                 with_body: true,
                 recv_timeout: :infinity
               )

      IO.puts("\n#{response_body}\n")
    end

    test "with proxy", %{url: url, headers: headers, body: body, proxy: proxy} do
      assert {:ok, 201, _, response_body} =
               :hackney.post(url, headers, body,
                 proxy: proxy,
                 with_body: true,
                 recv_timeout: :infinity
               )

      IO.puts("\n#{response_body}\n")
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
            <cep>13212-070</cep>
          </cli:consultaCEP>
        </soapenv:Body>
      </soapenv:Envelope>
      """

      {:ok,
       url: "https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente",
       headers: [{"Content-Type", "text/xml; charset=utf-8"}],
       body: body}
    end

    test "with proxy", %{url: url, headers: headers, body: body, proxy: proxy} do
      assert {:ok, 200, _, response_body} =
               :hackney.post(url, headers, body,
                 proxy: proxy,
                 with_body: true,
                 recv_timeout: :infinity
               )

      IO.puts("\n#{response_body}\n")
    end

    test "without proxy", %{url: url, headers: headers, body: body} do
      assert {:ok, 200, _, response_body} =
               :hackney.post(url, headers, body,
                 with_body: true,
                 recv_timeout: :infinity
               )

      IO.puts("\n#{response_body}\n")
    end
  end
end
