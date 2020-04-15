defmodule Correios.CEP.MixProject do
  use Mix.Project

  @version "0.3.0"
  @github_url "https://github.com/prodis/correios-cep-elixir"

  def project do
    [
      app: :correios_cep,
      name: "Correios CEP",
      version: @version,
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: dialyzer(),
      description: description(),
      package: package(),
      docs: docs(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.travis": :test
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      # Common
      {:httpoison, "~> 1.6"},
      {:sweet_xml, "~> 0.6"},

      # Devlopment
      {:credo, "~> 1.3", only: :dev, runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},

      # Test
      {:exvcr, "~> 0.10", only: :test},
      {:excoveralls, "~> 0.12", only: :test}
    ]
  end

  defp description do
    """
    Find Brazilian addresses by zip code, directly from Correios database. No HTML parsers.
    """
  end

  defp dialyzer do
    [
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end

  defp package do
    [
      files: ~w(lib mix.exs README.md CHANGELOG.md LICENSE),
      maintainers: ["Fernando Hamasaki de Amorim"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => @github_url}
    ]
  end

  defp docs() do
    [
      main: "readme",
      extras: ~w(README.md CHANGELOG.md),
      source_ref: "v#{@version}",
      source_url: @github_url,
      canonical: "http://hexdocs.pm/correios_cep"
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
