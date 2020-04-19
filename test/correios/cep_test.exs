defmodule Correios.CEPTest do
  use ExUnit.Case, async: true

  alias Correios.CEP, as: Subject

  # Correios.CEP.ClientFake is injected in test/test_helper.exs.
  alias Correios.CEP.{Address, Error}

  doctest Subject

  @invalid_zipcodes ~w(
    1234567
    123456789
    1234-5678
    12345-6789
    1234-567
    abcedfgh
    abced-fgh
  )

  setup do
    address = %Address{
      city: "Jaboatão dos Guararapes",
      complement: "",
      neighborhood: "Cavaleiro",
      state: "PE",
      street: "Rua Fernando Amorim",
      zipcode: "54250610"
    }

    {:ok, address: address}
  end

  describe "find_address/1" do
    test "when zip code is valid and address is found, returns the address", %{
      address: expected_address
    } do
      assert Subject.find_address("54250-610") == {:ok, expected_address}
    end

    test "when zip code is valid (no hyphen) and address is found, returns the address", %{
      address: expected_address
    } do
      assert Subject.find_address("54250610") == {:ok, expected_address}
    end

    test "when zip code is valid and address is not found, returns not found error" do
      expected_error = %Error{reason: "CEP NAO ENCONTRADO"}

      assert Subject.find_address("00000-000") == {:error, expected_error}
    end

    test "when zip code is empty, returns required error" do
      expected_error = %Error{reason: "zipcode is required"}

      assert Subject.find_address("") == {:error, expected_error}
    end

    test "when zip code has invalid format, returns invalid format error" do
      expected_error = %Error{reason: "zipcode in invalid format"}

      Enum.each(@invalid_zipcodes, fn zipcode ->
        assert Subject.find_address(zipcode) == {:error, expected_error}
      end)
    end
  end

  describe "find_address!/1" do
    test "when zip code is valid and address is found, returns the address", %{
      address: expected_address
    } do
      assert Subject.find_address!("54250-610") == expected_address
    end

    test "when zip code is valid (no hyphen) and address is found, returns the address", %{
      address: expected_address
    } do
      assert Subject.find_address!("54250610") == expected_address
    end

    test "when zip code is valid and address is not found, raises not found error" do
      assert_raise Error, "CEP NAO ENCONTRADO", fn ->
        Subject.find_address!("00000-000")
      end
    end

    test "when zip code is empty, raises required error" do
      assert_raise Error, "zipcode is required", fn ->
        Subject.find_address!("")
      end
    end

    test "when zip code has invalid format, raises invalid format error" do
      Enum.each(@invalid_zipcodes, fn zipcode ->
        assert_raise Error, "zipcode in invalid format", fn ->
          Subject.find_address!(zipcode)
        end
      end)
    end
  end
end
