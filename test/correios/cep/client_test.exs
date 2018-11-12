defmodule Correios.CEP.ClientTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Correios.CEP.Client, as: Subject

  setup_all do
    HTTPoison.start()
  end

  describe "request/1 when response is 200 OK" do
    test "returns OK and response body" do
      expected_response_body =
        "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><ns2:consultaCEPResponse xmlns:ns2=\"http://cliente.bean.master.sigep.bsb.correios.com.br/\"><return><bairro>Cavaleiro</bairro><cep>54250610</cep><cidade>Jaboatão dos Guararapes</cidade><complemento2></complemento2><end>Rua Fernando Amorim</end><uf>PE</uf></return></ns2:consultaCEPResponse></soap:Body></soap:Envelope>"

      use_cassette "response_ok" do
        assert Subject.request("54250-610") == {:ok, expected_response_body}
      end
    end
  end

  describe "request/1 when response is not 200 OK" do
    test "returns error and response body" do
      expected_response_body =
        "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><soap:Fault><faultcode>soap:Server</faultcode><faultstring>CEP NAO ENCONTRADO</faultstring><detail><ns2:SigepClienteException xmlns:ns2=\"http://cliente.bean.master.sigep.bsb.correios.com.br/\">CEP NAO ENCONTRADO</ns2:SigepClienteException></detail></soap:Fault></soap:Body></soap:Envelope>"

      use_cassette "response_error" do
        assert Subject.request("00000-000") == {:error, expected_response_body}
      end
    end
  end

  describe "request/1 when response is not available" do
    test "returns error and reason" do
      use_cassette "response_timeout" do
        assert Subject.request("54250-610") == {:error, "timeout"}
      end
    end
  end
end
