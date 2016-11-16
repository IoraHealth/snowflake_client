defmodule SnowflakeClient do
  @moduledoc """
  An OAuth2 strategy for Snowflake.
  """
  use OAuth2.Strategy

  alias OAuth2.Strategy.AuthCode

  defp config do
    [strategy: SnowflakeClient,
     site: "https://snowflake.icisapp.com",
     authorize_url: "https://snowflake.icisapp.com/oauth/authorize",
     token_url: "https://snowflake.icisapp.com/oauth/access_token"]
  end

  # Public API

  @doc """
  Returns a client that has the configuration values set based upon configuration
  settings in your application.
  """
  def client do
    config()
    |> Keyword.merge(Application.get_env(:snowflake_client, SnowflakeClient))
    |> OAuth2.Client.new()
  end

  @doc """
  Returns the appropriate authorization URL based upon passed in params
  and the client configuration.
  """
  def authorize_url!(params \\ []) do
    client()
    |> put_param(:scope, "user")
    |> OAuth2.Client.authorize_url!(params)
  end

  @doc """
  performs a client HTTP request and grabs the access token.
  """
  def get_token!(params \\ [], headers \\ []) do
    client()
    |> put_header("Accept", "application/json")
    |> put_param(:client_secret, client.client_secret)
    |> OAuth2.Client.get_token!(params, headers)
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  # def get_token(client, params \\ [], headers \\ [], opts \\ []) do
  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> put_param(:client_secret, client.client_secret)
    |> AuthCode.get_token(params, headers)
  end
end
