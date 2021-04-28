defmodule BankingWeb.AccountView do
  use BankingWeb, :view

  def render("error.json", %{error: error}) do
    %{error: error}
  end

  def render("withdraw.json", %{account: account}) do
    %{balance: account.balance}
  end
end
