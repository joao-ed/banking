defmodule BankingWeb.SessionView do
  use BankingWeb, :view

  def render("error.json", %{message: message}) do
    %{message: message}
  end

  def render("login.json", %{jwt: jwt}) do
    %{token: jwt}
  end

  def render("logout.json", %{message: message}) do
    %{message: message}
  end
end
