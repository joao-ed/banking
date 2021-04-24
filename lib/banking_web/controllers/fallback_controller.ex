defmodule BankingWeb.FallbackController do
   use BankingWeb, :controller

   def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
      conn
      |> put_status(:unprocessable_entity)
      |> render(BankingWeb.ChangesetView, "error.json", changeset: changeset)
   end

   def call(conn, {:error, :unauthorized}) do
      conn
      |> put_status(:unauthorized)
      |> render(BankingWeb.ErrorView, ":403")
   end

end