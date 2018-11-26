defmodule Correios.CEP.FakeClient do
  def request("54250-610") do
    response = """
    <return>
      <bairro>Cavaleiro</bairro>
      <cep>54250610</cep>
      <cidade>Jaboatão dos Guararapes</cidade>
      <end>Rua Fernando Amorim</end>
      <uf>PE</uf>
    </return>
    """

    {:ok, response}
  end

  def request("00000-000") do
    {:error, "<faultstring>CEP NAO ENCONTRADO</faultstring>"}
  end
end
