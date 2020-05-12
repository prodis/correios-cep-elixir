defmodule Correios.CEP.Parser do
  @moduledoc """
  Parser for Correios API responses.
  """

  import SweetXml, only: [sigil_x: 2, xpath: 2, xpath: 3]

  alias Correios.CEP.{Address, Error}

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

  When the response body is empty, returns a not found `#{inspect(Error)}` struct.

  ## Examples

      iex> #{inspect(__MODULE__)}.parse_ok(response_body)
      %#{inspect(Address)}{ ... }

      iex> #{inspect(__MODULE__)}.parse_ok(response_body)
      %#{inspect(Error)}{reason: "CEP NAO ENCONTRADO"}

  """
  @spec parse_ok(String.t()) :: Address.t() | Error.t()
  def parse_ok(response) when is_binary(response) do
    response
    |> xpath(~x"//return"o, @xmap_params)
    |> build_response()
  end

  @spec build_response(map() | nil) :: Address.t() | Error.t()
  defp build_response(nil), do: Error.new("CEP NAO ENCONTRADO")
  defp build_response(response) when is_map(response), do: Address.new(response)

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
