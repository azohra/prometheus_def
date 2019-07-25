defmodule PrometheusDef.MixProject do
  use Mix.Project

  def project do
    [
      app: :prometheus_def,
      version: "0.0.0-alpha.1",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/azohra/prometheus_def",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "Quality of life improvements when working with Prometheus"
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{
        "Azohra" => "https://github.com/azohra"
      }
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:prometheus_ex, "~> 3.0", optional: true},
    ]
  end
end
