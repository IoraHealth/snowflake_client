defmodule SnowflakeClient.Mixfile do
  use Mix.Project

  def project do
    [app: :snowflake_client,
     version: "0.1.0",
     elixir: "~> 1.1",
     description: "A OAuth 2.0 client for Snowflake.",
     deps: deps,
     package: package]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:oauth2, :logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:oauth2, "~> 0.5"},
     {:earmark, "~> 0.2", only: :dev},
     {:ex_doc, "~> 0.11", only: :dev}]
  end

  defp package do
    [maintainers: ["Patrick Robertson"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/IoraHealth/snowflake_client"}]
  end
end
