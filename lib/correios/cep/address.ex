defmodule Correios.CEP.Address do
  @moduledoc """
  Address structure.
  """

  @enforce_keys [:street, :complement, :neighborhood, :city, :state, :postal_code, :zipcode]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{
          street: String.t(),
          complement: String.t(),
          neighborhood: String.t(),
          city: String.t(),
          state: String.t(),
          postal_code: String.t(),
          zipcode: String.t()
        }
  @typep complement :: charlist() | nil

  @doc """
  Creates a new `#{inspect(__MODULE__)}` struct with the given values.

  The values will be converted to string, and `complement` and `complement2` keys will be joined
  into the `complement` field.

  ## Examples

      iex> #{inspect(__MODULE__)}.new(%{
      ...>   street: 'Street',
      ...>   neighborhood: 'Neighborhood',
      ...>   complement: ' complement one',
      ...>   complement2: 'complement two ',
      ...>   city: 'City',
      ...>   state: 'ST',
      ...>   postal_code: '12345678'
      ...> })
      %#{inspect(__MODULE__)}{
        city: "City",
        complement: "complement one complement two",
        neighborhood: "Neighborhood",
        state: "ST",
        street: "Street",
        postal_code: "12345678",
        zipcode: "12345678"
      }

  """
  @spec new(map()) :: t()
  def new(%{
        street: street,
        complement: complement1,
        complement2: complement2,
        neighborhood: neighborhood,
        city: city,
        state: state,
        postal_code: postal_code
      }) do
    %__MODULE__{
      street: to_string(street),
      neighborhood: to_string(neighborhood),
      city: to_string(city),
      state: to_string(state),
      postal_code: to_string(postal_code),
      zipcode: to_string(postal_code),
      complement: build_complement(complement1, complement2)
    }
  end

  @spec build_complement(complement(), complement()) :: String.t()
  defp build_complement(complement1, complement2) do
    [complement1, complement2]
    |> Enum.join(" ")
    |> String.trim()
  end
end
