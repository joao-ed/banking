defmodule Banking.UsersTest do
  use Banking.DataCase, async: true

  alias Banking.Users.{User, Encryption}
  alias Banking.Users

  @valid_attrs %{username: "Rob Halford", email: "rob@fakemail.com", password: "12345678"}
  @invalid_attrs %{username: nil, email: nil, password: "1"}

  def user_fixture(user_attrs) do
    {:ok, user} = Users.register(user_attrs)
    user
  end

  test "register/1 with valid information" do
    assert {:ok, %User{} = user} = Users.register(@valid_attrs)
    assert user.email === @valid_attrs.email
    assert user.username === @valid_attrs.username
    assert {:ok, user} === Encryption.verify_password(user, @valid_attrs.password)
  end

  test "register/1 with invalid information that returns changeset error" do
    assert {:error, %Ecto.Changeset{}} = Users.register(@invalid_attrs)
  end

  test "find_user_and_check_password/1 with an valid user" do
    _ = user_fixture(@valid_attrs)

    assert {:ok, _user} =
             Users.find_user_and_check_password(%{
               "email" => @valid_attrs.email,
               "password" => @valid_attrs.password
             })
  end

  test "find_user_and_check_password/1 with an valid user (downcase scenario)" do
    _ = user_fixture(%{@valid_attrs | email: "fake@fakemail.com"})

    assert {:ok, _user} =
             Users.find_user_and_check_password(%{
               "email" => "FAKE@FAKEMAIL.COM",
               "password" => @valid_attrs.password
             })
  end

  test "find_user_and_check_password/1 with invalid email" do
    _ = user_fixture(@valid_attrs)

    assert {:error, :user_not_found} =
             Users.find_user_and_check_password(%{
               "email" => "john@test.com",
               "password" => @valid_attrs.password
             })
  end

  test "find_user_and_check_password/1 with wrong password" do
    _ = user_fixture(@valid_attrs)

    assert {:error, "invalid password"} =
             Users.find_user_and_check_password(%{
               "email" => @valid_attrs.email,
               "password" => "987654321"
             })
  end
end
