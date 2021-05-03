defmodule Banking.Users.UserTest do
  use Banking.DataCase, async: true
  alias Banking.Accounts.User

  test "password must be at least 8 characters long" do
    changeset = User.changeset(%User{}, %{password: "123456"})
    assert %{password: ["should be at least 8 character(s)"]} = errors_on(changeset)
  end

  test "email can't be blank" do
    changeset = User.changeset(%User{}, %{username: "john", password: "123456789"})
    assert %{email: ["can't be blank"]} = errors_on(changeset)
  end

  test "email should have a valid format" do
    changeset = User.changeset(%User{}, %{email: "invalid.email"})
    assert %{email: ["has invalid format"]} = errors_on(changeset)
  end

  test "username can't be blank" do
    changeset = User.changeset(%User{}, %{password: "123456789", email: "john@email.com"})
    assert %{username: ["can't be blank"]} = errors_on(changeset)
  end
end
