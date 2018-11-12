# Correios CEP
Find Brazilian addresses by zip code, directly from Correios database. No HTML parsers.

## Installation

The package can be installed by adding `correios_cep` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:correios_cep, "~> 0.1"}]
end
```

## Usage

```elixir
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

iex> Correios.CEP.find_address("00000-000")
{:error, %Correios.CEP.Error{reason: "CEP NAO ENCONTRADO"}}

iex> Correios.CEP.find_address!("54250-610")
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
```

Full documentation can be found at [https://hexdocs.pm/correios_cep](https://hexdocs.pm/correios_cep).

## Contributing

See the [contributing guide](https://github.com/prodis/correios-cep-elixir/blob/master/CONTRIBUTING.md).

## License

Correios CEP is released under the Apache 2.0 License. See the [LICENSE](https://github.com/prodis/correios-cep-elixir/blob/master/LICENSE) file.

## Author

[Fernando Hamasaki de Amorim (prodis)](https://github.com/prodis)

![Prodis Logo](https://camo.githubusercontent.com/c01a3ebca1c000d7586a998bb07316c8cb784ce5/687474703a2f2f70726f6469732e6e65742e62722f696d616765732f70726f6469735f3135302e676966)
