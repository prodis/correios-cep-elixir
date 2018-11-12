defmodule Correios.CEP.Parser do
  @moduledoc false

  import SweetXml

  alias Correios.CEP.{Address, Error}

  @address_map %{
    street: "end",
    complement: "complemento",
    complement2: "complemento2",
    neighborhood: "bairro",
    city: "cidade",
    state: "uf",
    zipcode: "cep"
  }

  @xmap_params for {new_key, old_key} <- @address_map,
                   into: [],
                   do: {new_key, ~x"./#{old_key}/text()"}

  def parse_response(response) when is_binary(response) do
    response
    |> xpath(~x"//return", @xmap_params)
    |> Address.new()
  end

  def parse_error(response) when is_atom(response) do
    Error.new(response)
  end

  def parse_error(response) when is_binary(response) do
    response
    |> xpath(~x"//faultstring/text()")
    |> Error.new()
  end
end
