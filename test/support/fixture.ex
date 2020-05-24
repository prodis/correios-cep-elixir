defmodule Correios.CEP.Test.Fixture do
  @moduledoc false

  def request_body do
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
  end

  def response_body_ok do
    "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" <>
      "<soap:Body>" <>
      "<ns2:consultaCEPResponse xmlns:ns2=\"http://cliente.bean.master.sigep.bsb.correios.com.br/\">" <>
      "<return>" <>
      "<bairro>Cavaleiro</bairro>" <>
      "<cep>54250610</cep>" <>
      "<cidade>Jaboatão dos Guararapes</cidade>" <>
      "<complemento2></complemento2>" <>
      "<end>Rua Fernando Amorim</end>" <>
      "<uf>PE</uf>" <>
      "</return>" <>
      "</ns2:consultaCEPResponse>" <>
      "</soap:Body>" <>
      "</soap:Envelope>"
  end

  def response_body_empty do
    "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" <>
      "<soap:Body>" <>
      "<ns2:consultaCEPResponse xmlns:ns2=\"http://cliente.bean.master.sigep.bsb.correios.com.br/\"/>" <>
      "</soap:Body>" <>
      "</soap:Envelope>"
  end

  def response_body_error do
    "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" <>
      "<soap:Body>" <>
      "<soap:Fault>" <>
      "<faultcode>soap:Server</faultcode>" <>
      "<faultstring>CEP NAO ENCONTRADO</faultstring>" <>
      "<detail>" <>
      "<ns2:SigepClienteException xmlns:ns2=\"http://cliente.bean.master.sigep.bsb.correios.com.br/\">CEP NAO ENCONTRADO</ns2:SigepClienteException>" <>
      "</detail>" <>
      "</soap:Fault>" <>
      "</soap:Body>" <>
      "</soap:Envelope>"
  end
end
