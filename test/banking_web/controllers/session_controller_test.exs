defmodule BankingWeb.SessionControllerTest do
  use BankingWeb.ConnCase
  import Banking.Factory

  defp user_factory(_context), do: {:ok, user: insert!(:user_with_account)}

  describe "create" do
    setup :user_factory

    test "should autenticate an user when valid credentials are provided", %{
      conn: conn,
      user: %{email: email, password: password}
    } do
      conn = post(conn, Routes.session_path(conn, :create), %{email: email, password: password})

      assert %{"token" => _token} = json_response(conn, 200)
    end

    test "login should fail because invalid password are provided", %{
      conn: conn,
      user: %{email: email}
    } do
      conn = post(conn, Routes.session_path(conn, :create), %{email: email, password: "76951657"})
      assert %{"message" => message} = json_response(conn, 401)
      assert message == "invalid password"
    end

    test "login should fail because invalid user are provided", %{
      conn: conn,
      user: %{password: password}
    } do
      conn =
        post(conn, Routes.session_path(conn, :create), %{
          email: "fakemail@foo.com",
          password: password
        })

      assert %{"message" => message} = json_response(conn, 404)
      assert message == "User not found. Check your credentials and try again"
    end
  end
end
