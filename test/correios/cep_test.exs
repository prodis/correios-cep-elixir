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

  describe "find_address/1" do
    test "when zip code is found returns address" do
      assert Subject.find_address("54250-610") == {:ok, @address}
    end

    test "when zip code is not found returns error" do
      assert Subject.find_address("00000-000") == {:error, @error}
    end
  end

  describe "find_address!/1" do
    test "when zip code is found returns address" do
      assert Subject.find_address!("54250-610") == @address
    end

    test "when zip code is not found raises error" do
      assert_raise Error, "CEP NAO ENCONTRADO", fn ->
        Subject.find_address!("00000-000")
      end
    end
  end
end
