defmodule BankingWeb.AccountView do
  use BankingWeb, :view

  def render("error.json", %{error: error}) do
    %{error: error}
  end

  def render("withdraw.json", %{account: account}) do
    %{balance: account.balance}
  end

  def render("transfers.json", %{
        from: from,
        to: to,
        amount: amount,
        balance: balance
      }) do
    %{from: from, to: to, amount: amount, balance: balance}
  end
end
