defmodule BankingWeb.UserControllerTest do
  use BankingWeb.ConnCase

  @user_attrs %{email: "foo@fakemail.com", username: "john", password: "12345678"}

  describe "create" do
    test "should create an user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), @user_attrs)

      assert %{
               "balance" => balance,
               "email" => email,
               "username" => username
             } = json_response(conn, 201)

      assert email == @user_attrs.email
      assert username == @user_attrs.username
      assert balance == 1000_00
    end
  end
end
