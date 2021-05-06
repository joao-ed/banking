defmodule Banking.UsersTest do
  use Banking.DataCase, async: true

  alias Banking.Users
  alias Banking.Users.User

  @valid_attrs %{username: "Rob Halford", email: "rob@fakemail.com", password: "12345678"}
  @invalid_attrs %{username: nil, email: nil, password: "1"}

  def user_fixture(user_attrs) do
    {:ok, user} = Users.register(user_attrs)
    # find a way to ignore virtual fields
    %{user | password: nil}
  end

  describe "register/1" do
    test "checks if the user has successfully registered" do
      {:ok, %User{} = user} = Users.register(@valid_attrs)
      assert user.email === @valid_attrs.email
      assert user.username === @valid_attrs.username
      assert {:ok, user} === Argon2.check_pass(user, @valid_attrs.password)
    end

    test "should fail because we provide invalid attributes" do
      assert {:error, %Ecto.Changeset{}} = Users.register(@invalid_attrs)
    end
  end

  describe "find_user_and_check_password/1" do
    test "finds a specific user by email and password and checks if password is correct" do
      user = user_fixture(@valid_attrs)

      assert {:ok, ^user} =
               Users.find_user_and_check_password(%{
                 "email" => @valid_attrs.email,
                 "password" => @valid_attrs.password
               })
    end

    test "finds a specific user providing an email written with uppercase" do
      user = user_fixture(%{@valid_attrs | email: "fake@fakemail.com"})

      assert {:ok, ^user} =
               Users.find_user_and_check_password(%{
                 "email" => "FAKE@FAKEMAIL.COM",
                 "password" => @valid_attrs.password
               })
    end

    test "should fail because email is wrong" do
      _ = user_fixture(@valid_attrs)

      assert {:error, :user_not_found} =
               Users.find_user_and_check_password(%{
                 "email" => "john@test.com",
                 "password" => @valid_attrs.password
               })
    end

    test "should fail because password is wrong" do
      _ = user_fixture(@valid_attrs)

      assert {:error, "invalid password"} =
               Users.find_user_and_check_password(%{
                 "email" => @valid_attrs.email,
                 "password" => "987654321"
               })
    end
  end
end
