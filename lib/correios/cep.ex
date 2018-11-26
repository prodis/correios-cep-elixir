defmodule Correios.CEP do
  @moduledoc """
  Find Brazilian addresses by zipcode, directly from Correios database. No HTML parsers.
  """

  alias Correios.CEP.Parser

  @client Application.get_env(:correios_cep, :client)

  @doc """
  Find address by a given zip code.

  Zip codes with and without "-" separator are accepted.

  ## Options

    * `connection_timeout`: timeout for establishing a TCP or SSL connection, in milliseconds. Default is 5000.
    * `request_timeout`: timeout for receiving an HTTP response from the socket. Default is 5000.

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

      iex> Correios.CEP.find_address("54250-610", connection_timeout: 1000, request_timeout: 1000)
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
  def find_address(zipcode, options \\ []) when is_binary(zipcode) and is_list(options) do
    zipcode
    |> @client.request(options)
    |> parse()
  end

  defp parse({:ok, response}), do: {:ok, Parser.parse_response(response)}
  defp parse({:error, error}), do: {:error, Parser.parse_error(error)}

  @doc """
  Find address by a given zip code.

  Similar to `find_address/2` except it will unwrap the error tuple and raise in case of errors.

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

  When zip code is not found.

      iex> Correios.CEP.find_address("00000000")
      ** (Correios.CEP.Error) CEP NAO ENCONTRADO

  """
  def find_address!(zipcode, options \\ []) when is_binary(zipcode) and is_list(options) do
    zipcode
    |> find_address(options)
    |> case do
      {:ok, response} -> response
      {:error, error} -> raise(error)
    end
  end
end
