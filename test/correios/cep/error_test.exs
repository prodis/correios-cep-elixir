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

  describe "new/3" do
    test "creates a new error", %{error: expected_error} do
      assert Subject.new(:some_type, "Some message", "Catastrophic error!") == expected_error
    end

    test "creates a new error without reason", %{error: error} do
      expected_error = %{error | reason: nil}
      assert Subject.new(:some_type, "Some message") == expected_error
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

  describe "exception/1" do
    setup do
      error = %Subject{
        type: nil,
        message: "Some message",
        reason: nil
      }

      {:ok, error: error}
    end

    test "returns the error with the given message", %{error: expected_error} do
      assert Subject.exception("Some message") == expected_error
    end

    test "raises the correct error", %{error: expected_error} do
      try do
        raise Subject, "Some message"
      rescue
        error -> assert error == expected_error
      end
    end
  end
end
