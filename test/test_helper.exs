ExUnit.start(exclude: :integration)

unless System.get_env("CORREIOS_CEP_TEST") == "integration" do
  Application.ensure_all_started(:bypass)
  Application.put_env(:correios_cep, :client, Correios.CEP.ClientFake)
end
