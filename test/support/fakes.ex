defmodule Correios.CEP.ClientFake do
  @moduledoc false

  def request("54250-610", options), do: request("54250610", options)

  def request("54250610", _options) do
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

  def request("00000-000", _options) do
    {:error, "<faultstring>CEP NAO ENCONTRADO</faultstring>"}
  end
end
