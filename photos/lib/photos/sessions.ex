defmodule Photos.Sessions do

  alias Photos.Auth
  alias Photos.Auth.User
  alias Photos.Auth.Guardian

  import Plug.Conn

  def set_user_info(conn) do
    maybe_user = Guardian.Plug.current_resource(conn)
    # image =
    #   if Map.has_key?(conn, :image) != false do
    #     IO.puts("----------------------------------")
    #     IO.puts("Conn trae Imagen")
    #     image = conn.image.inserted_at
    #   else
    #     nil
    #   end
    # IO.inspect(image)
    # key =
    #   if maybe_user != nil do
    #     :crypto.hmac(:sha256, "rc0Uv-tMH0Gy6faPXCa2tRf_9DVBqMylADkagtFV", maybe_user.email)
    #     |> Base.encode16
    #     |> String.downcase
    #   end
    #
    # final_map =
    #   if maybe_user != nil do
    #     maybe_user
    #     |> Map.merge(%{key: key})
    #   # else
    #   #   maybe_user
    #   #   |> Map.merge(%{key: nil})
    #   end

    # final_map =
    #   if image != nil do
    #     final_map
    #     |> Map.merge(%{image: image})
    #   else
    #     final_map
    #     |> Map.merge(%{image: nil})
    #   end
    conn =
      conn
      |> assign(:maybe_user, maybe_user)
  end

  def intercom(conn, _params) do
    is_user = Guardian.Plug.current_resource(conn)
    {:ok, snippet} =
      case is_user do
        nil ->
          Intercom.snippet(
            %{},
            app_id: "f4l65qly",
          )
        _ ->
          Intercom.snippet(
            %{email: is_user.email},
            app_id: "f4l65qly",
            secret: "rc0Uv-tMH0Gy6faPXCa2tRf_9DVBqMylADkagtFV"
          )
      end
    assign(conn, :intercom, snippet)
  end

end
