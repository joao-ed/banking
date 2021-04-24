defmodule BankingWeb.SessionController do
  use BankingWeb, :controller

  def index(conn, params) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(204, "")
  end
end
