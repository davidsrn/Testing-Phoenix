defmodule PhotosWeb.PageController do
  use PhotosWeb, :controller
  # require Intercom

  alias Photos.Auth
  alias Photos.Auth.User
  alias Photos.Auth.Guardian

  # plug :intercom

  def index(conn, _params) do
    changeset = Auth.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)
    
    maybe_user =
      if maybe_user != nil do
        maybe_user
        |> set_user_info
      else
        maybe_user
      end
    conn
      |> render("index.html", changeset: changeset, action: page_path(conn, :login), maybe_user: maybe_user)
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
    maybe_user =
      conn
      |> set_user_info
    render(conn, "secret.html", maybe_user: maybe_user)
  end

  def set_user_info(maybe_user) do
    key =
      if maybe_user != nil do
        :crypto.hmac(:sha256, "rc0Uv-tMH0Gy6faPXCa2tRf_9DVBqMylADkagtFV", maybe_user.email)
        |> Base.encode16
        |> String.downcase
    end

    final_map =
        maybe_user
        |> Map.merge(%{key: key})

  end

  # defp intercom(conn, _params) do
  #   {:ok, snippet} = Intercom.snippet(
  #     %{email: "bob@foo.com"},
  #     app_id: "<your app id>",
  #     secret: "<your secret>"
  #   )
  #   assign(conn, :intercom, snippet)
  # end
end
