# SnowflakeClient

An OAuth 2.0 client for Elixir web applications.

## Installation

  1. Add snowflake_client to your list of dependencies in `mix.exs`:

        def deps do
          [{:snowflake_client, "~> 0.1.0"}]
        end

  2. Ensure snowflake_client is started before your application:

        def application do
          [applications: [:snowflake_client]]
        end
