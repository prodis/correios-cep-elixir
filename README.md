# Correios CEP

[![Hex.pm](https://img.shields.io/hexpm/v/correios_cep.svg)](https://hex.pm/packages/correios_cep)
[![Docs](https://img.shields.io/badge/hex-docs-542581.svg)](https://hexdocs.pm/correios_cep)
[![Build Status](https://travis-ci.org/prodis/correios-cep-elixir.svg?branch=master)](https://travis-ci.org/prodis/correios-cep-elixir)
[![Coverage Status](https://coveralls.io/repos/github/prodis/correios-cep-elixir/badge.svg?branch=master)](https://coveralls.io/github/prodis/correios-cep-elixir?branch=master)
[![License](https://img.shields.io/hexpm/l/correios_cep.svg)](LICENSE)

![Correios Logo](http://prodis.net.br/images/ruby/2015/correios_logo.png)

Find Brazilian addresses by postal code, directly from Correios API. No HTML parsers.

## DEPRECATION NOTE

`Correios.CEP.Address.zipcode` was removed in the version `0.6.0`. Use `Correios.CEP.Address.postal_code` instead.

## Installation

The package can be installed by adding `correios_cep` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:correios_cep, "~> 0.6.0"}
  ]
end
```

## Usage

```elixir
iex> Correios.CEP.find_address("54250610")
{:ok,
 %Correios.CEP.Address{
   street: "Rua Fernando Amorim",
   neighborhood: "Cavaleiro",
   complement: "",
   city: "Jaboatão dos Guararapes",
   state: "PE",
   postal_code: "54250610"
 }}

iex> Correios.CEP.find_address("00000-000")
{:error,
 %Correios.CEP.Error{
   type: :postal_code_not_found,
   message: "Postal code not found",
   reason: "CEP NAO ENCONTRADO"
 }}

iex> Correios.CEP.find_address!("54250-610")
%Correios.CEP.Address{
  street: "Rua Fernando Amorim",
  neighborhood: "Cavaleiro",
  complement: "",
  city: "Jaboatão dos Guararapes",
  state: "PE",
  postal_code: "54250610"
}

iex> Correios.CEP.find_address!("00000-000")
** (Correios.CEP.Error) Postal code not found
```

### Options

There are some supported options that can be added to the request, as timeouts, proxy and URL
configuration.

The example below shows the use of `request_timeout` and `proxy` options:

```elixir
iex> Correios.CEP.find_address("54250610", request_timeout: 3000, proxy: {"localhost", 8888})
{:ok,
 %Correios.CEP.Address{
   street: "Rua Fernando Amorim",
   neighborhood: "Cavaleiro",
   complement: "",
   city: "Jaboatão dos Guararapes",
   state: "PE",
   postal_code: "54250610"
 }}
```

See [`Correios.CEP.find_address/2`](https://hexdocs.pm/correios_cep/Correios.CEP.html#find_address/2)
documentation to check the details of the available options.

## Documentation

The full documentation is available at [https://hexdocs.pm/correios_cep](https://hexdocs.pm/correios_cep).

## Contributing

See the [contributing guide](https://github.com/prodis/correios-cep-elixir/blob/master/CONTRIBUTING.md).

## License

Correios CEP is released under the Apache 2.0 License. See the [LICENSE](https://github.com/prodis/correios-cep-elixir/blob/master/LICENSE) file.

Copyright © 2018-2020 Fernando Hamasaki de Amorim

## Author

[Fernando Hamasaki de Amorim (prodis)](https://github.com/prodis)

![Prodis Logo](https://camo.githubusercontent.com/c01a3ebca1c000d7586a998bb07316c8cb784ce5/687474703a2f2f70726f6469732e6e65742e62722f696d616765732f70726f6469735f3135302e676966)
