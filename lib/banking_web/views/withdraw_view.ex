defmodule BankingWeb.WithdrawView do
  use BankingWeb, :view

  def render("error.json", %{message: message}) do
    %{message: message}
  end

  def render("index.json", %{message: message}) do
    %{message: message}
  end
end
