defmodule Correios.CEP.ParserTest do
  use ExUnit.Case, async: true

  alias Correios.CEP.Parser, as: Subject
  alias Correios.CEP.{Address, Error}

  describe "parse_response/1" do
    test "returns address" do
      response = """
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Body>
          <ns2:consultaCEPResponse xmlns:ns2="http://cliente.bean.master.sigep.bsb.correios.com.br/">
            <return>
              <bairro>Cavaleiro</bairro>
              <cep>54250610</cep>
              <cidade>Jaboatão dos Guararapes</cidade>
              <complemento2></complemento2>
              <end>Rua Fernando Amorim</end>
              <uf>PE</uf>
            </return>
          </ns2:consultaCEPResponse>
        </soap:Body>
      </soap:Envelope>
      """

      expected_address = %Address{
        city: "Jaboatão dos Guararapes",
        complement: "",
        neighborhood: "Cavaleiro",
        state: "PE",
        street: "Rua Fernando Amorim",
        zipcode: "54250610"
      }

      assert Subject.parse_response(response) == expected_address
    end
  end

  describe "parse_error/1 when error is atom" do
    test "returns error" do
      assert Subject.parse_error(:timeout) == %Error{reason: "timeout"}
    end
  end

  describe "parse_error/1 when error is binary" do
    test "returns error" do
      response = """
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Body>
          <soap:Fault>
            <faultcode>soap:Server</faultcode>
            <faultstring>CEP NAO ENCONTRADO</faultstring>
            <detail>
              <ns2:SigepClienteException xmlns:ns2="http://cliente.bean.master.sigep.bsb.correios.com.br/">CEP NAO ENCONTRADO</ns2:SigepClienteException>
            </detail>
          </soap:Fault>
        </soap:Body>
      </soap:Envelope>
      """

      assert Subject.parse_error(response) == %Error{reason: "CEP NAO ENCONTRADO"}
    end
  end
end
