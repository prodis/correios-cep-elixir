defmodule CurlTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, proxy: "localhost:8888"}
  end

  describe "JSON Placeholder" do
    setup do
      {:ok,
       url: "https://httpstat.us/201",
       header: "Accept: application/json",
       body: ~s({"title": "foo", "body": "bar", "userId": 1})}
    end

    test "without proxy", %{url: url, header: header, body: body} do
      "curl -v #{url} -H '#{header}' --data-raw '#{body}'"
      |> run()
    end

    test "with proxy", %{url: url, header: header, body: body, proxy: proxy} do
      "curl -v #{url} -H '#{header}' --data-raw '#{body}' --proxy #{proxy}"
      |> run()
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

      {:ok,
       url: "https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente",
       header: "Content-Type: text/xml; charset=utf-8",
       body: body}
    end

    test "without proxy", %{url: url, header: header, body: body} do
      "curl -v #{url} -H '#{header}' --data-raw '#{body}'"
      |> run()
    end

    test "with proxy", %{url: url, header: header, body: body, proxy: proxy} do
      "curl -v #{url} -H '#{header}' --data-raw '#{body}' --proxy #{proxy}"
      |> run()
    end
  end

  defp run(curl) do
    IO.puts("\n")

    curl
    |> IO.inspect()
    |> String.to_charlist()
    |> :os.cmd()
    |> to_string()
    |> String.split("\n")
    |> Enum.each(&IO.puts/1)
  end
end
