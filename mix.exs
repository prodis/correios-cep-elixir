defmodule Correios.CEP.MixProject do
  use Mix.Project

  @version "0.2.0"
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
        "coveralls.html": :test
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
      {:httpoison, "~> 1.4"},
      {:sweet_xml, "~> 0.6.5"},

      # Dev
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},

      # Test
      {:exvcr, "~> 0.10", only: :test},

      # Dev and Test
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end

  defp description do
    """
    Find Brazilian addresses by zip code, directly from Correios database. No HTML parsers.
    """
  end

  defp dialyzer do
    [
      ignore_warnings: "dialyzer.ignore"
    ]
  end

  defp package do
    [
      maintainers: ["Fernando Hamasaki de Amorim"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => @github_url}
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

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
