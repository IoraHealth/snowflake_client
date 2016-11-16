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

## Usage in Phoenix Apps!

### Configuration

```elixir
#config/dev.exs
config :snowflake_client, SnowflakeClient,
  client_id: "spookyid",
  client_secret: "spookysecret",
  redirect_uri: "http://localhost:4000/auth/icis/callback",
  site: "http://snowflake.dev/",
  token_url: "http://snowflake.dev/oauth/token",
  authorize_url: "http://snowflake.dev/oauth/authorize"
```

### Router

```elixir
scope "/auth", MyApp do
  pipe_through :browser

  get "/:provider", AuthController, :index
  get "/:provider/callback", AuthController, :callback
  delete "/logout", AuthController, :delete
end
```

### AuthController

```elixir
defmodule MyApp.AuthController do
  use MyApp.Web, :controller

  def index(conn, %{"provider" => "icis"}) do
    redirect(conn, external: SnowflakeClient.authorize_url!)
  end

  def delete(conn, _parameters) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(conn, %{"provider" => "icis", "code" => code}) do
    token = SnowflakeClient.get_token!(code: code)
    user = get_user!(token)

    conn
    |> put_session(:current_user, user)
    |> put_session(:access_token, token.access_token)
    |> redirect(to: "/")
  end

  defp get_user!(token) do
    {:ok, %{body: user}} = OAuth2.Client.get(token, "/api/v1/me")
    user
  end
end
```

### Some HTML

```eex
<main role="main">
  <%= if @current_user do %>
    <h2>Welcome, <%= @current_user["first_name"] %>!</h2>
    <%= link "Logout", to: auth_path(@conn, :delete), method: :delete, class: "btn btn-danger" %>
    <br/>
  <% else %>
    <a class="btn btn-primary btn-lg" href="<%= auth_path @conn, :index, "icis" %>">
      <i class="fa fa-github"></i>
      Sign in with GitHub
    </a>
  <% end %>
  <%= render @view_module, @view_template, assigns %>
</main>
```
