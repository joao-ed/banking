defmodule Banking.Users.Encryption do
  @doc false
  def put_pass_hash(password), do: Argon2.add_hash(password, hash_key: :password)

  @doc false
  def verify_password(subject, password),
    do: Argon2.check_pass(subject, password, hash_key: :password)
end
