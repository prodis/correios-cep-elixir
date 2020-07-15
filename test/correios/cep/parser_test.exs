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
        reason: "Empty response"
      }

      assert Subject.parse_ok(response) == expected_error
    end
  end

  describe "parse_error/1" do
    test "when the error is 'CEP NAO ENCONTRADO', returns postal code not found error" do
      response = Fixture.response_body_cep_not_found_error()

      expected_error = %Error{
        type: :postal_code_not_found,
        message: "Postal code not found",
        reason: "CEP NAO ENCONTRADO"
      }

      assert Subject.parse_error(response) == expected_error
    end

    test "when the error is unknown, returns other error" do
      response = Fixture.response_body_other_error()

      expected_error = %Error{
        type: :unknown,
        message: "Unknown error",
        reason: "ANY OTHER ERROR"
      }

      assert Subject.parse_error(response) == expected_error
    end

    test "when error is an atom, returns request error" do
      expected_error = %Error{
        type: :request_error,
        message: "Request error",
        reason: "timeout"
      }

      assert Subject.parse_error(:timeout) == expected_error
    end
  end
end
