defmodule Correios.CEP do
  @moduledoc """
  Find Brazilian addresses by zipcode, directly from Correios database. No HTML parsers.
  """

  alias Correios.CEP.{Client, Parser}

  @doc """
  Find address by a given zip code.

  ## Examples

      iex> Correios.CEP.find_address("54250610")
      {:ok,
       %Correios.CEP.Address{
         city: "Jaboatão dos Guararapes",
         complement: "",
         neighborhood: "Cavaleiro",
         state: "PE",
         street: "Rua Fernando Amorim",
         zipcode: "54250610"
       }}

      iex> Correios.CEP.find_address("54250-610")
      {:ok,
       %Correios.CEP.Address{
         city: "Jaboatão dos Guararapes",
         complement: "",
         neighborhood: "Cavaleiro",
         state: "PE",
         street: "Rua Fernando Amorim",
         zipcode: "54250610"
       }}

  When zip code is not found.

      iex> Correios.CEP.find_address("00000000")
      {:error, %Correios.CEP.Error{reason: "CEP NAO ENCONTRADO"}}

  """
  def find_address(zipcode, client \\ Client) when is_binary(zipcode) do
    zipcode
    |> client.request()
    |> parse()
  end

  defp parse({:ok, response}), do: {:ok, Parser.parse_response(response)}
  defp parse({:error, error}), do: {:error, Parser.parse_error(error)}

  @doc """
  Find address by a given zip code.

  ## Examples

      iex> Correios.CEP.find_address!("54250610")
      %Correios.CEP.Address{
        city: "Jaboatão dos Guararapes",
        complement: "",
        neighborhood: "Cavaleiro",
        state: "PE",
        street: "Rua Fernando Amorim",
        zipcode: "54250610"
      }

      iex> Correios.CEP.find_address!("54250-610")
      %Correios.CEP.Address{
        city: "Jaboatão dos Guararapes",
        complement: "",
        neighborhood: "Cavaleiro",
        state: "PE",
        street: "Rua Fernando Amorim",
        zipcode: "54250610"
      }

  When zip code is not found.

      iex> Correios.CEP.find_address("00000000")
      ** (Correios.CEP.Error) CEP NAO ENCONTRADO

  """
  def find_address!(zipcode, client \\ Client) when is_binary(zipcode) do
    zipcode
    |> find_address(client)
    |> case do
      {:ok, response} -> response
      {:error, error} -> raise(error)
    end
  end
end
