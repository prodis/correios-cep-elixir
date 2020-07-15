defmodule Correios.CEP.ParserTest do
  use ExUnit.Case, async: true

  alias Correios.CEP.Parser, as: Subject

  alias Correios.CEP.{Address, Error}
  alias Correios.CEP.Test.Fixture

  describe "parse_ok/1" do
    test "returns the parsed address" do
      response = Fixture.response_body_ok()

      expected_address = %Address{
        street: "Rua Fernando Amorim",
        complement: "",
        neighborhood: "Cavaleiro",
        city: "Jaboatão dos Guararapes",
        state: "PE",
        postal_code: "54250610"
      }

      assert Subject.parse_ok(response) == expected_address
    end

    test "when body is empty, return not found error" do
      response = Fixture.response_body_empty()

      expected_error = %Error{
        type: :postal_code_not_found,
        message: "Postal code not found",
        reason: "CEP NAO ENCONTRADO"
      }

      assert Subject.parse_ok(response) == expected_error
    end
  end

  describe "parse_error/1" do
    test "returns the parsed error" do
      response = Fixture.response_body_error()

      expected_error = %Error{
        type: :postal_code_not_found,
        message: "Postal code not found",
        reason: "CEP NAO ENCONTRADO"
      }

      assert Subject.parse_error(response) == expected_error
    end

    test "when error is an atom, returns the parsed error" do
      assert Subject.parse_error(:timeout) == %Error{
               type: :request_timeout,
               message: "Request timeout",
               reason: "timeout"
             }
    end
  end
end
