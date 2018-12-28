defmodule Correios.CEP do
  @moduledoc """
  Find Brazilian addresses by zipcode, directly from Correios database. No HTML parsers.
  """

  alias Correios.CEP.{Address, Error, Parser}

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

      iex> Correios.CEP.find_address("00000-000")
      {:error, %Correios.CEP.Error{reason: "CEP NAO ENCONTRADO"}}

      iex> Correios.CEP.find_address("1234567")
      {:error, %Correios.CEP.Error{reason: "zipcode in invalid format"}}

      iex> Correios.CEP.find_address("")
      {:error, %Correios.CEP.Error{reason: "zipcode is required"}}

  """
  @spec find_address(String.t(), list()) :: {:ok, Address.t()} | {:error, term()}
  def find_address(zipcode, options \\ [])

  def find_address("", _options) do
    {:error, %Error{reason: "zipcode is required"}}
  end

  def find_address(zipcode, options) when is_binary(zipcode) and is_list(options) do
    if valid_zipcode?(zipcode) do
      zipcode
      |> @client.request(options)
      |> parse()
    else
      {:error, %Error{reason: "zipcode in invalid format"}}
    end
  end

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

      iex> Correios.CEP.find_address!("00000-000")
      ** (Correios.CEP.Error) CEP NAO ENCONTRADO

      iex> Correios.CEP.find_address!("1234567")
      ** (Correios.CEP.Error) zipcode in invalid format

      iex> Correios.CEP.find_address!("")
      ** (Correios.CEP.Error) zipcode is required

  """
  @spec find_address!(String.t(), list()) :: Address.t()
  def find_address!(zipcode, options \\ []) when is_binary(zipcode) and is_list(options) do
    zipcode
    |> find_address(options)
    |> case do
      {:ok, response} -> response
      {:error, error} -> raise(error)
    end
  end

  @spec valid_zipcode?(String.t()) :: boolean()
  defp valid_zipcode?(zipcode) do
    String.match?(zipcode, ~r/^\d{5}-?\d{3}$/)
  end

  @spec parse({:ok, String.t()} | {:error, term()}) :: {:ok, Address.t()} | {:error, Error.t()}

  defp parse({:ok, response}), do: {:ok, Parser.parse_response(response)}
  defp parse({:error, error}), do: {:error, Parser.parse_error(error)}
end
