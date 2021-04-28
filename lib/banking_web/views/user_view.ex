defmodule BankingWeb.UserView do
  use BankingWeb, :view

  def render("error.json", %{message: message}) do
    %{message: message}
  end

  def render("user-created.json", %{user: user}) do
    %{username: user.username, email: user.email, balance: user.account.balance}
  end
end
