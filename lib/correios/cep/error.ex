defmodule Correios.CEP.Error do
  @moduledoc """
  Error structure.
  """

  @enforce_keys [:reason]

  @type t() :: %__MODULE__{reason: String.t()}

  defexception @enforce_keys

  @doc """
  Create a new Correios.CEP.Error exception.

  ## Examples

      iex> Correios.CEP.Error.new("Catastrofic error!")
      %Correios.CEP.Error{reason: "Catastrofic error!"}

      iex> Correios.CEP.Error.new(:someerror)
      %Correios.CEP.Error{reason: "someerror"}

  """
  @spec new(String.t() | atom()) :: t()
  def new(reason) do
    %__MODULE__{reason: to_string(reason)}
  end

  @doc """
  Returns the reason message of the exception.

  ## Examples

      iex> Correios.CEP.Error.message(%Correios.CEP.Error{reason: "Catastrofic error!"})
      "Catastrofic error!"

  """
  @impl true
  def message(%__MODULE__{reason: reason}), do: to_string(reason)
end
