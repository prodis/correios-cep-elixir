defmodule Correios.CEP.Parser do
  @moduledoc """
  Parser for Correios API responses.
  """

  alias Correios.CEP.{Address, Error}

  import SweetXml, only: [sigil_x: 2, xpath: 2, xpath: 3]

  @address_map [
    street: "end",
    complement: "complemento",
    complement2: "complemento2",
    neighborhood: "bairro",
    city: "cidade",
    state: "uf",
    zipcode: "cep"
  ]

  @xmap_params for {new_key, old_key} <- @address_map,
                   into: [],
                   do: {new_key, ~x"./#{old_key}/text()"}

  @doc """
  Parses a successful Correios API response body to `#{inspect(Address)}` struct.

  ## Examples

      iex> #{inspect(__MODULE__)}.parse_response(response_body)
      %#{inspect(Address)}{ ... }

  """
  @spec parse_response(String.t()) :: Address.t()
  def parse_response(response) when is_binary(response) do
    response
    |> xpath(~x"//return", @xmap_params)
    |> Address.new()
  end

  @doc """
  Parses a Correios API response error to `#{inspect(Error)}` struct.

  ## Examples

      iex> #{inspect(__MODULE__)}.parse_error(response_body)
      %#{inspect(Error)}{ ... }

      iex> #{inspect(__MODULE__)}.parse_error(:timeout)
      %#{inspect(Error)}{reason: "timeout"}

  """
  @spec parse_error(any()) :: Error.t()
  def parse_error(response) when is_binary(response) do
    response
    |> xpath(~x"//faultstring/text()")
    |> Error.new()
  end

  def parse_error(response), do: Error.new(response)
end
