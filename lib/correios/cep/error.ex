defmodule Correios.CEP.Error do
  @moduledoc """
  Error structure.
  """

  @enforce_keys [:reason]

  @type t() :: %__MODULE__{reason: String.t()}

  defexception @enforce_keys

  @doc """
  Creates a new `#{inspect(__MODULE__)}` exception.

  ## Examples

      iex> #{inspect(__MODULE__)}.new("Catastrophic error!")
      %#{inspect(__MODULE__)}{reason: "Catastrophic error!"}

      iex> #{inspect(__MODULE__)}.new('Catastrophic error!')
      %#{inspect(__MODULE__)}{reason: "Catastrophic error!"}

      iex> #{inspect(__MODULE__)}.new(:some_error)
      %#{inspect(__MODULE__)}{reason: "some_error"}

      iex> #{inspect(__MODULE__)}.new(%{a: 123})
      %#{inspect(__MODULE__)}{reason: "%{a: 123}"}

  """
  @spec new(any()) :: t()
  def new(reason), do: %__MODULE__{reason: reason_to_string(reason)}

  @spec reason_to_string(any()) :: String.t()
  defp reason_to_string(reason) when is_binary(reason), do: reason
  defp reason_to_string(reason) when is_atom(reason) or is_list(reason), do: to_string(reason)
  defp reason_to_string(reason), do: inspect(reason)

  @doc """
  Returns the reason message of the exception.

  ## Examples

      iex> error = %#{inspect(__MODULE__)}{reason: "Catastrophic error!"}
      ...> #{inspect(__MODULE__)}.message(error)
      "Catastrophic error!"

  """
  @impl true
  def message(%__MODULE__{reason: reason}), do: reason
end
