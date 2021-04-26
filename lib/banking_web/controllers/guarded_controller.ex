defmodule BankingWeb.GuardedController do
  @moduledoc """
  This module inject the subject as an argument
  ## Usage example
  defmodule BankingWeb.MyController do
    use BankingWeb, :controller
    use BankingWeb.GuardedController
    plug Guardian.Plug.EnsureAuthenticated
    def index(conn, params, user) do
      # ..code..
    end
  end
  """

  defmacro __using__(_opts \\ []) do
    quote do
      def action(conn, _opts) do
        apply(__MODULE__, action_name(conn), [
          conn,
          conn.params,
          BankingWeb.Guardian.Plug.current_resource(conn)
        ])
      end
    end
  end
end
