defmodule BankingWeb.ErrorView do
  use BankingWeb, :view

  def render("404.json", _assigns) do
    %{errors: %{detail: "Page not found"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal server error"}}
  end

  def render("401.json", _assigns) do
    %{errors: %{detail: "Unauthorized"}}
  end

  def template_not_found(_template, assigns) do
    render("500.json", assigns)
  end
end
