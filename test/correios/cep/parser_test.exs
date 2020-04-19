defmodule Correios.CEP.ParserTest do
  use ExUnit.Case, async: true

  alias Correios.CEP.Parser, as: Subject

  alias Correios.CEP.{Address, Error}
  alias Correios.CEP.Test.Fixture

  describe "parse_response/1" do
    test "returns the parsed address" do
      response = Fixture.response_body_ok()

      expected_address = %Address{
        city: "Jaboatão dos Guararapes",
        complement: "",
        neighborhood: "Cavaleiro",
        state: "PE",
        street: "Rua Fernando Amorim",
        zipcode: "54250610"
      }

      assert Subject.parse_response(response) == expected_address
    end
  end

  describe "parse_error/1" do
    test "returns the parsed error" do
      response = Fixture.response_body_error()

      expected_error = %Error{reason: "CEP NAO ENCONTRADO"}

      assert Subject.parse_error(response) == expected_error
    end

    test "when error is an atom, returns the parsed error" do
      assert Subject.parse_error(:timeout) == %Error{reason: "timeout"}
    end
  end
end
