defmodule Correios.CEP.Error do
  @moduledoc """
  Error structure.
  """

  @enforce_keys [:type, :message, :reason]

  @type t() :: %__MODULE__{type: atom(), message: String.t(), reason: String.t()}

  defexception @enforce_keys

  @doc """
  Creates a new `#{inspect(__MODULE__)}` exception.

  ## Examples

      iex> #{inspect(__MODULE__)}.new(:some_type, "Some message", "Catastrophic error!")
      %#{inspect(__MODULE__)}{type: :some_type, message: "Some message", reason: "Catastrophic error!"}

      iex> #{inspect(__MODULE__)}.new(:some_type, 'Some message', "Catastrophic error!")
      %#{inspect(__MODULE__)}{type: :some_type, message: "Some message", reason: "Catastrophic error!"}

      iex> #{inspect(__MODULE__)}.new(:some_type, :some_message, "Catastrophic error!")
      %#{inspect(__MODULE__)}{type: :some_type, message: "some_message", reason: "Catastrophic error!"}

      iex> #{inspect(__MODULE__)}.new(:some_type, %{a: 123}, "Catastrophic error!")
      %#{inspect(__MODULE__)}{type: :some_type, message: "%{a: 123}", reason: "Catastrophic error!"}

      iex> #{inspect(__MODULE__)}.new(:some_type, "Some message", 'Catastrophic error!')
      %#{inspect(__MODULE__)}{type: :some_type, message: "Some message", reason: "Catastrophic error!"}

      iex> #{inspect(__MODULE__)}.new(:some_type, "Some message", :some_error)
      %#{inspect(__MODULE__)}{type: :some_type, message: "Some message", reason: "some_error"}

      iex> #{inspect(__MODULE__)}.new(:some_type, "Some message", %{a: 123})
      %#{inspect(__MODULE__)}{type: :some_type, message: "Some message", reason: "%{a: 123}"}

  """
  @spec new(any(), any(), any()) :: t()
  def new(type, message, reason) do
    %__MODULE__{
      type: type,
      message: convert_to_string(message),
      reason: convert_to_string(reason)
    }
  end

  @spec convert_to_string(any()) :: String.t()
  defp convert_to_string(message_or_reason) when is_binary(message_or_reason),
    do: message_or_reason

  defp convert_to_string(message_or_reason)
       when is_atom(message_or_reason) or is_list(message_or_reason),
       do: to_string(message_or_reason)

  defp convert_to_string(message_or_reason), do: inspect(message_or_reason)

  @doc """
  Returns the reason message of the exception.

  ## Examples

      iex> error = %#{inspect(__MODULE__)}{type: :some_type, message: "Some message", reason: "Catastrophic error!"}
      ...> #{inspect(__MODULE__)}.message(error)
      "Some message"

  """
  @impl true
  def message(%__MODULE__{message: message}), do: message

  @doc """
  Returns the reason message of the exception.

  ## Examples

      iex> error = %#{inspect(__MODULE__)}{type: :some_type, message: "Some message", reason: "Catastrophic error!"}
      ...> #{inspect(__MODULE__)}.reason(error)
      "Catastrophic error!"

  """
  @impl true
  def reason(%__MODULE__{reason: reason}), do: reason
end
