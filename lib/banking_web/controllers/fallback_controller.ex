defmodule BankingWeb.FallbackController do
  use BankingWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(BankingWeb.ChangesetView, "error.json", changeset: changeset)
  end

  # devo remover ?
  def call(conn, {:error, :forbidden}) do
    conn
    |> put_status(:forbidden)
    |> render(BankingWeb.ErrorView, ":403")
  end
end
