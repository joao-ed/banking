defmodule BankingWeb.ChangesetView do
  use BankingWeb, :view

  @doc """
  Traverses and translates changeset errors.
  See `Ecto.Changeset.traverse_errors/2` and
  `BankingWeb.ErrorHelpers.translate_error/1` for more details.
  """
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def render("error.json", %{changeset: changeset}) when is_map(changeset) do
    %{errors: translate_errors(changeset)}
  end

  def render("error.json", %{changeset: changeset}) when is_binary(changeset) do
    %{errors: changeset}
  end
end
