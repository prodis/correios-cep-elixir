use Mix.Config

config :correios_cep,
  client:
    Module.concat(
      Correios.CEP,
      if(Mix.env() == :test, do: FakeClient, else: Client)
    )
