defmodule PhotosWeb.PageController do
  use PhotosWeb, :controller

  alias Photos.Auth
  alias Photos.Auth.User
  alias Photos.Auth.Guardian

  import Photos.Sessions

  def index(conn, _params) do
    changeset = Auth.change_user(%User{})
    conn =
      conn
      |> set_user_info
      |> assign(:action, "<script>Intercom('trackEvent', 'see_user');</script>")
    conn
      |> render("index.html", changeset: changeset, action: page_path(conn, :login))
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    Auth.authenticate_user(username, password)
    |> login_reply(conn)
  end

  defp login_reply({:error, error}, conn) do
    conn
    |> put_flash(:error, error)
    |> redirect(to: "/user")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:success, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/user")
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:success, "Logged Out!")
    |> redirect(to: "/user")
  end

  def secret(conn, _params) do
    conn =
      conn
      |> set_user_info
    render(conn, "secret.html")
  end

end
