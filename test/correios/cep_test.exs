defmodule Correios.CEPTest do
  use ExUnit.Case, async: true

  doctest Correios.CEP

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

  @invalid_zipcodes ~w(
    1234567
    123456789
    1234-5678
    12345-6789
    1234-567
    abcedfgh
    abced-fgh
  )

  @invalide_format_error %Error{
    reason: "zipcode in invalid format"
  }

  describe "find_address/1" do
    test "when zip code is valid and found returns address" do
      assert Subject.find_address("54250-610") == {:ok, @address}
    end

    test "when zip code is valid (no hyphen) and found returns address" do
      assert Subject.find_address("54250610") == {:ok, @address}
    end

    test "when zip code is valid and not found returns not found error" do
      assert Subject.find_address("00000-000") == {:error, %Error{reason: "CEP NAO ENCONTRADO"}}
    end

    test "when zip code is empty returns required error" do
      assert Subject.find_address("") == {:error, %Error{reason: "zipcode is required"}}
    end

    test "when zip code is not valid returns invalid format error" do
      @invalid_zipcodes
      |> Enum.each(fn zipcode ->
        assert Subject.find_address(zipcode) == {:error, @invalide_format_error}
      end)
    end
  end

  describe "find_address!/1" do
    test "when zip code is valid and found returns address" do
      assert Subject.find_address!("54250-610") == @address
    end

    test "when zip code is valid (no hyphen) and found returns address" do
      assert Subject.find_address!("54250610") == @address
    end

    test "when zip code is valid and not found raises error" do
      assert_raise Error, "CEP NAO ENCONTRADO", fn ->
        Subject.find_address!("00000-000")
      end
    end

    test "when zip code is empty returns required error" do
      assert_raise Error, "zipcode is required", fn ->
        Subject.find_address!("")
      end
    end

    test "when zip code is not valid returns invalid format error" do
      @invalid_zipcodes
      |> Enum.each(fn zipcode ->
        assert_raise Error, "zipcode in invalid format", fn ->
          Subject.find_address!(zipcode)
        end
      end)
    end
  end
end
