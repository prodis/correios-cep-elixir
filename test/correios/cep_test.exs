defmodule Correios.CEPTest do
  use ExUnit.Case, async: true

  alias Correios.CEP, as: Subject
  alias Correios.CEP.{Address, Error}

  @address %Address{
    city: "Jaboatão dos Guararapes",
    complement: "",
    neighborhood: "Cavaleiro",
    state: "PE",
    street: "Rua Fernando Amorim",
    zipcode: "54250610"
  }

  @error %Error{
    reason: "CEP NAO ENCONTRADO"
  }

  defmodule FakeClient do
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

  describe "find_address/1 when zip code is found" do
    test "returns address" do
      assert Subject.find_address("54250-610", FakeClient) == {:ok, @address}
    end
  end

  describe "find_address/1 when zip code is not found" do
    test "returns error" do
      assert Subject.find_address("00000-000", FakeClient) == {:error, @error}
    end
  end

  describe "find_address!/1 when zip code is found" do
    test "returns address" do
      assert Subject.find_address!("54250-610", FakeClient) == @address
    end
  end

  describe "find_address!/1 when zip code is not found" do
    test "raises error" do
      assert_raise Error, "CEP NAO ENCONTRADO", fn ->
        Subject.find_address!("00000-000", FakeClient)
      end
    end
  end
end
