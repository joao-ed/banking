defmodule Banking.Users.Encryption do
  @moduledoc """
  A Module which works as an interface for Argon2 (lib for password hash)
  """
  @doc false
  def put_pass_hash(password), do: Argon2.add_hash(password)

  @doc false
  def verify_password(subject, password), do: Argon2.check_pass(subject, password)
end
