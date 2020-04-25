defmodule HTTPoisonTest do
  use ExUnit.Case, async: true

  setup do
    {
      :ok,
      json_url: "https://jsonplaceholder.typicode.com/todos/44",
      correios_url:
        "https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente",
      headers: [{"User-Agent", "curl/7.47.0"}]
    }
  end

  describe "HTTPoison without proxy" do
    test "makes a GET request to JSON Placeholder", %{json_url: url, headers: headers} do
      assert {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(url, headers)
      assert %{"id" => 44} = Jason.decode!(body)
    end

    test "makes a GET request to Correios API", %{correios_url: url, headers: headers} do
      assert {:ok, %HTTPoison.Response{body: body, status_code: 405}} =
               HTTPoison.get(url, headers)

      assert body == "HTTP GET not supported"
    end
  end

  describe "HTTPoison with proxy" do
    setup do
      {:ok, proxy: {"localhost", 8888}}
    end

    test "makes a GET request to JSON Placeholder", %{
      json_url: url,
      headers: headers,
      proxy: proxy
    } do
      assert {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(url, headers, proxy: proxy)
      assert %{"id" => 44} = Jason.decode!(body)
    end

    test "makes a GET request to Correios API", %{
      correios_url: url,
      headers: headers,
      proxy: proxy
    } do
      assert {:ok, %HTTPoison.Response{body: body, status_code: 405}} =
               HTTPoison.get(url, headers, proxy: proxy)

      assert body == "HTTP GET not supported"
    end
  end

  describe "curl without proxy" do
    test "makes a GET request to JSON Placeholder", %{json_url: url} do
      "curl -v #{url}"
      |> String.to_charlist()
      |> :os.cmd()
      |> to_string()
      |> String.split("\n")
      |> Enum.each(&IO.puts/1)
    end

    test "makes a GET request to Correios API", %{correios_url: url} do
      "curl -v #{url}"
      |> String.to_charlist()
      |> :os.cmd()
      |> to_string()
      |> String.split("\n")
      |> Enum.each(&IO.puts/1)
    end
  end

  describe "curl with proxy" do
    setup do
      {:ok, proxy: "localhost:8888"}
    end

    test "makes a GET request to JSON Placeholder", %{json_url: url, proxy: proxy} do
      "curl -v --proxy #{proxy} #{url}"
      |> String.to_charlist()
      |> :os.cmd()
      |> to_string()
      |> String.split("\n")
      |> Enum.each(&IO.puts/1)
    end

    test "makes a GET request to Correios API", %{correios_url: url, proxy: proxy} do
      "curl -v --proxy #{proxy} #{url}"
      |> String.to_charlist()
      |> :os.cmd()
      |> to_string()
      |> String.split("\n")
      |> Enum.each(&IO.puts/1)
    end
  end
end
