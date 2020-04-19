defmodule Correios.CEP.ClientTest do
  use ExUnit.Case, async: true

  alias Correios.CEP.Client, as: Subject

  alias Correios.CEP.Test.Fixture
  alias Plug.Conn

  setup do
    bypass = Bypass.open()
    options = [url: "http://localhost:#{bypass.port}/correios/cep"]

    {:ok, bypass: bypass, options: options}
  end

  describe "request/2" do
    test "when response is 200 OK, returns OK and response body", %{
      bypass: bypass,
      options: options
    } do
      response_body = Fixture.response_body_ok()

      assert_conn(bypass, 200, response_body)
      assert Subject.request("54250-610", options) == {:ok, response_body}
    end

    test "when response is not 200 OK, returns error and response body", %{
      bypass: bypass,
      options: options
    } do
      response_body = Fixture.response_body_error()

      assert_conn(bypass, 500, response_body)
      assert Subject.request("54250-610", options) == {:error, response_body}
    end

    test "when the server is down, returns error and reason", %{
      bypass: bypass,
      options: options
    } do
      Bypass.down(bypass)

      assert Subject.request("54250-610", options) == {:error, :econnrefused}
    end
  end

  defp assert_conn(bypass, status_code, response_body) do
    Bypass.expect_once(bypass, fn conn ->
      assert conn.method == "POST"
      assert conn.host == "localhost"
      assert conn.request_path == "/correios/cep"

      [
        {"content-type", "text/xml; charset=utf-8"},
        {"user-agent", "correios-cep-elixir/#{Mix.Project.config()[:version]}"}
      ]
      |> Enum.each(fn header ->
        assert header in conn.req_headers
      end)

      {:ok, body, _conn} = Conn.read_body(conn)
      assert body == Fixture.request_body()

      Conn.resp(conn, status_code, response_body)
    end)
  end
end
