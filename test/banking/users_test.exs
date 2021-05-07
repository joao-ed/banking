defmodule Banking.UsersTest do
  use Banking.DataCase, async: true

  alias Banking.Users
  alias Banking.Users.User

  import Banking.Factory

  @valid_attrs %{username: "Rob Halford", email: "rob@fakemail.com", password: "12345678"}
  @invalid_attrs %{username: nil, email: nil, password: "1"}

  defp user_factory(%{user_attrs: user_attrs}),
    do: {:ok, user: %{insert!(:user_with_account, user_attrs) | password: nil}}

  describe "register/1" do
    test "checks if the user has successfully registered" do
      {:ok, %User{} = user} = Users.register(@valid_attrs)
      assert user.email == @valid_attrs.email
      assert user.username == @valid_attrs.username
      assert {:ok, user} == Argon2.check_pass(user, @valid_attrs.password)
    end

    test "should fail because we provide invalid attributes" do
      assert {:error, %Ecto.Changeset{}} = Users.register(@invalid_attrs)
    end
  end

  describe "find_user_and_check_password/1" do
    setup :user_factory

    @tag user_attrs: @valid_attrs
    test "finds a specific user by email and password and checks if password is correct",
         %{user: user} do
      assert {:ok, ^user} =
               Users.find_user_and_check_password(%{
                 "email" => @valid_attrs.email,
                 "password" => @valid_attrs.password
               })
    end

    @tag user_attrs: %{@valid_attrs | email: "fake@fakemail.com"}
    test "finds a specific user providing an email written with uppercase", %{user: user} do
      assert {:ok, ^user} =
               Users.find_user_and_check_password(%{
                 "email" => "FAKE@FAKEMAIL.COM",
                 "password" => @valid_attrs.password
               })
    end

    @tag user_attrs: @valid_attrs
    test "should fail because email is wrong" do
      assert {:error, :user_not_found} =
               Users.find_user_and_check_password(%{
                 "email" => "john@test.com",
                 "password" => @valid_attrs.password
               })
    end

    @tag user_attrs: @valid_attrs
    test "should fail because password is wrong" do
      assert {:error, "invalid password"} =
               Users.find_user_and_check_password(%{
                 "email" => @valid_attrs.email,
                 "password" => "987654321"
               })
    end
  end
end
