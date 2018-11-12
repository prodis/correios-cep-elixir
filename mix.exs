defmodule Correios.CEP.MixProject do
  use Mix.Project

  @version "0.1.0"
  @github_url "https://github.com/prodis/correios-cep-elixir"

  def project do
    [
      app: :correios_cep,
      name: "Correios CEP",
      version: @version,
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.4"},
      {:sweet_xml, "~> 0.6.5"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:exvcr, "~> 0.10", only: :test}
    ]
  end

  defp description do
    """
    Find Brazilian addresses by zip code, directly from Correios database. No HTML parsers.
    """
  end

  defp package do
    [
      maintainers: ["Fernando Hamasaki de Amorim"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => @github_url,
        "Vai Corinthians!" => "https://www.corinthians.com.br/assets/svg/logo.svg"
      }
    ]
  end

  defp docs() do
    [
      main: "readme",
      extras: ["README.md", "CHANGELOG.md"],
      source_ref: "v#{@version}",
      source_url: @github_url,
      canonical: "http://hexdocs.pm/correios_cep"
    ]
  end
end
