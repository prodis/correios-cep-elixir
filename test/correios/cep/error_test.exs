defmodule Correios.CEP.ErrorTest do
  use ExUnit.Case, async: true

  alias Correios.CEP.Error, as: Subject

  doctest Subject

  setup do
    error = %Subject{
      type: :some_type,
      message: "Some message",
      reason: "Catastrophic error!"
    }

    {:ok, error: error}
  end

  describe "new/1" do
    test "creates a new error", %{error: expected_error} do
      assert Subject.new(:some_type, "Some message", "Catastrophic error!") == expected_error
    end

    test "when the message is a charlist, converts the message to string", %{
      error: expected_error
    } do
      assert Subject.new(:some_type, 'Some message', 'Catastrophic error!') == expected_error
    end

    test "when the message is an atom, converts the message to string", %{error: error} do
      expected_error = %{error | message: "some_message"}

      assert Subject.new(:some_type, :some_message, 'Catastrophic error!') == expected_error
    end

    test "when the message has another type, converts the message to string", %{error: error} do
      expected_error = %{error | message: "{:a, 123}"}

      assert Subject.new(:some_type, {:a, 123}, 'Catastrophic error!') == expected_error
    end

    test "when the reason is a charlist, converts the reason to string", %{error: expected_error} do
      assert Subject.new(:some_type, "Some message", 'Catastrophic error!') == expected_error
    end

    test "when the reason is an atom, converts the reason to string", %{error: error} do
      expected_error = %{error | reason: "some_error"}

      assert Subject.new(:some_type, "Some message", :some_error) == expected_error
    end

    test "when the reason has another type, converts the reason to string", %{error: error} do
      expected_error = %{error | reason: "{:a, 123}"}

      assert Subject.new(:some_type, "Some message", {:a, 123}) == expected_error
    end
  end

  describe "message/1" do
    test "returns the message of the error", %{error: error} do
      assert Subject.message(error) == "Catastrophic error!"
    end
  end
end
