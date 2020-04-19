ExUnit.start()
Application.ensure_all_started(:bypass)

Application.put_env(:correios_cep, :client, Correios.CEP.ClientFake)
