defmodule Correios.CEP.IntegrationTest do
  use ExUnit.Case, async: true
  @moduletag :integration

  alias Correios.CEP, as: Subject

  alias Correios.CEP.{Address, Error}

  setup do
    address = %Address{
      street: "Avenida Paulista",
      complement: "- de 1047 a 1865 - lado ímpar",
      neighborhood: "Bela Vista",
      city: "São Paulo",
      state: "SP",
      postal_code: "01311200"
    }

    {:ok, address: address}
  end

  describe "not using proxy" do
    test "when the address is found, returns the address", %{address: expected_address} do
      assert Subject.find_address("01311-200") == {:ok, expected_address}
    end

    test "when the address is not found, returns not found error" do
      # Not asserting the error reason because Correios CEP API sometimes return an empty response
      # for postal codes not found.
      assert {:error,
              %Error{
                type: :postal_code_not_found,
                message: "Postal code not found"
              }} = Subject.find_address("09999-999")
    end
  end

  describe "using proxy" do
    setup do
      options = [
        proxy: {"localhost", 8888}
      ]

      {:ok, options: options}
    end

    test "when the address is found, returns the address", %{
      address: expected_address,
      options: options
    } do
      assert Subject.find_address("01311-200", options) == {:ok, expected_address}
    end

    test "when the address is not found, returns not found error", %{options: options} do
      # Not asserting the error reason because Correios CEP API sometimes return an empty response
      # for postal codes not found.
      assert {:error,
              %Error{
                type: :postal_code_not_found,
                message: "Postal code not found"
              }} = Subject.find_address("09999-999")
    end
  end

  describe "using proxy with authentication" do
    setup do
      options = [
        proxy: {"localhost", 8889},
        proxy_auth: {"pedrobo", "123pim"}
      ]

      {:ok, options: options}
    end

    test "when the address is found, returns the address", %{
      address: expected_address,
      options: options
    } do
      assert Subject.find_address("01311-200", options) == {:ok, expected_address}
    end

    test "when the address is not found, returns not found error", %{options: options} do
      # Not asserting the error reason because Correios CEP API sometimes return an empty response
      # for postal codes not found.
      assert {:error,
              %Error{
                type: :postal_code_not_found,
                message: "Postal code not found"
              }} = Subject.find_address("09999-999")
    end
  end
end
