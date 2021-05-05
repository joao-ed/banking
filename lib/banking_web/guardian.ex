defmodule BankingWeb.Guardian do
  @moduledoc """
  Guardian "implementation module". A module which includes Guardian's functionality and the code for encondig and decoding token's value
  """
  use Guardian, otp_app: :banking

  alias Banking.Repo
  alias Banking.Users.User

  def subject_for_token(%User{} = user, _claims), do: {:ok, to_string(user.id)}
  def subject_for_token(_, _), do: {:error, "Unknown resource type"}

  def resource_from_claims(%{"sub" => user_id}), do: {:ok, Repo.get(User, user_id)}
  def resource_from_claims(_claims), do: {:error, "Unknown resource type"}
end
