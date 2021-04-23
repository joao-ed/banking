defmodule Banking.Encryption do
  def put_pass_hash(password), do: Argon2.add_hash(password)

  def verify_password(password), do: Argon2.check_pass(password)
end
