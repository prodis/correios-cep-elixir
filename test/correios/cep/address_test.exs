defmodule Correios.CEP.AddressTest do
  use ExUnit.Case, async: true

  alias Correios.CEP.Address, as: Subject

  doctest Subject

  describe "new/1" do
    setup do
      params = %{
        street: 'Street',
        complement: ' complement one',
        complement2: nil,
        neighborhood: 'Neighborhood',
        city: 'City',
        state: 'ST',
        postal_code: '12345678'
      }

      {:ok, params: params}
    end

    test "creates a new address", %{params: params} do
      expected_address = %Subject{
        street: "Street",
        complement: "complement one",
        neighborhood: "Neighborhood",
        city: "City",
        state: "ST",
        postal_code: "12345678"
      }

      assert Subject.new(params) == expected_address
    end

    test "when complement2 is given, joins it to the complement", %{params: params} do
      params = %{params | complement2: "complement two"}

      expected_address = %Subject{
        street: "Street",
        complement: "complement one complement two",
        neighborhood: "Neighborhood",
        city: "City",
        state: "ST",
        postal_code: "12345678"
      }

      assert Subject.new(params) == expected_address
    end
  end
end
