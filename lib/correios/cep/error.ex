defmodule Correios.CEP.Error do
  @moduledoc """
  Error structure.
  """

  @enforce_keys [:message]

  @type t() :: %__MODULE__{
          type: atom() | nil,
          message: String.t(),
          reason: String.t() | nil
        }

  defexception [:type, :message, :reason]

  @doc """
  Creates a new `#{inspect(__MODULE__)}` exception with the given `type`, `message` and `reason`.

  ## Examples

      iex> #{inspect(__MODULE__)}.new(:some_type, "Some message", "Catastrophic error!")
      %#{inspect(__MODULE__)}{
        type: :some_type,
        message: "Some message",
        reason: "Catastrophic error!"
      }

      iex> #{inspect(__MODULE__)}.new(:some_type, "Some message", 'Catastrophic error!')
      %#{inspect(__MODULE__)}{
        type: :some_type,
        message: "Some message",
        reason: "Catastrophic error!"
      }

      iex> #{inspect(__MODULE__)}.new(:some_type, "Some message")
      %#{inspect(__MODULE__)}{
        type: :some_type,
        message: "Some message",
        reason: nil
      }

  """
  @spec new(atom(), String.t(), any()) :: t()
  def new(type, message, reason \\ nil) when is_atom(type) and is_binary(message) do
    %__MODULE__{
      type: type,
      message: message,
      reason: maybe_to_string(reason)
    }
  end

  @spec maybe_to_string(any()) :: String.t() | nil
  defp maybe_to_string(nil), do: nil
  defp maybe_to_string(value) when is_binary(value), do: value
  defp maybe_to_string(value) when is_atom(value) or is_list(value), do: to_string(value)
  defp maybe_to_string(value), do: inspect(value)
end
