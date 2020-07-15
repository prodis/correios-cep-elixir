defmodule Correios.CEPTest do
  use ExUnit.Case, async: true

  alias Correios.CEP, as: Subject

  alias Correios.CEP.{Address, Error}

  doctest Subject

  @invalid_postal_codes ~w(
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
      street: "Rua Fernando Amorim",
      complement: "",
      neighborhood: "Cavaleiro",
      city: "Jaboatão dos Guararapes",
      state: "PE",
      postal_code: "54250610"
    }

    {:ok, address: address}
  end

  describe "find_address/1" do
    test "when postal code is valid and address is found, returns the address", %{
      address: expected_address
    } do
      assert Subject.find_address("54250-610") == {:ok, expected_address}
    end

    test "when postal code is valid (no hyphen) and address is found, returns the address", %{
      address: expected_address
    } do
      assert Subject.find_address("54250610") == {:ok, expected_address}
    end

    test "when postal code is valid and address is not found, returns not found error" do
      expected_error = %Error{
        type: :postal_code_not_found,
        message: "Postal code not found",
        reason: "CEP NAO ENCONTRADO"
      }

      assert Subject.find_address("00000-000") == {:error, expected_error}
    end

    test "when postal code is empty, returns required error" do
      expected_error = %Error{
        type: :postal_code_required,
        message: "Postal code is required",
        reason: "postal_code is required"
      }

      assert Subject.find_address("") == {:error, expected_error}
    end

    test "when postal code has invalid format, returns invalid format error" do
      expected_error = %Error{
        type: :postal_code_invalid,
        message: "Postal code is invalid",
        reason: "postal code in invalid format"
      }

      Enum.each(@invalid_postal_codes, fn postal_code ->
        assert Subject.find_address(postal_code) == {:error, expected_error}
      end)
    end
  end

  describe "find_address!/1" do
    test "when postal code is valid and address is found, returns the address", %{
      address: expected_address
    } do
      assert Subject.find_address!("54250-610") == expected_address
    end

    test "when postal code is valid (no hyphen) and address is found, returns the address", %{
      address: expected_address
    } do
      assert Subject.find_address!("54250610") == expected_address
    end

    test "when postal code is valid and address is not found, raises not found error" do
      assert_raise Error, "CEP NAO ENCONTRADO", fn ->
        Subject.find_address!("00000-000")
      end
    end

    test "when postal code is empty, raises required error" do
      assert_raise Error, "postal_code is required", fn ->
        Subject.find_address!("")
      end
    end

    test "when postal code has invalid format, raises invalid format error" do
      Enum.each(@invalid_postal_codes, fn postal_code ->
        assert_raise Error, "postal code in invalid format", fn ->
          Subject.find_address!(postal_code)
        end
      end)
    end
  end
end
