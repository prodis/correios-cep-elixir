defmodule Correios.CEP.MixProject do
  use Mix.Project

  def project do
    [
      app: :correios_cep,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.4"},
      {:sweet_xml, "~> 0.6.5"},
      {:exvcr, "~> 0.10", only: :test}
    ]
  end
end
