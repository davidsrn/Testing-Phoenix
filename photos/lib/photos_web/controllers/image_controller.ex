defmodule PhotosWeb.ImageController do
  use PhotosWeb, :controller

  alias Photos.Assets
  alias Photos.Assets.Image

  import Plug.Conn
  import Photos.Sessions

  require Intercom

  plug :intercom

  def index(conn, _params) do
    conn =
      conn
      |> set_user_info
      |> assign(:action, "<script>Intercom('trackEvent', 'see_photos');</script>")
    images = Assets.list_images()
    render(conn, "index.html", images: images)
  end

  def index_json(conn, _params) do
    images = Assets.list_images()
    conn =
      conn
      |> set_user_info
      |> assign(:action, "<script>Intercom('trackEvent', 'see_photos');</script>")
    render(conn, "index.json", images: images)
  end

  def new(conn, _params) do
    changeset = Assets.change_image(%Image{})
    conn =
      conn
      |> set_user_info
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"image" => image_params}) do
    case Assets.create_image(image_params) do
      {:ok, image} ->
        conn
        |> assign(:image, image)
        |> set_user_info
        conn
        |> put_flash(:info, "Image created successfully.")
        |> assign(:action, "<script>Intercom('trackEvent', 'add_photo');</script>")
        |> redirect(to: image_path(conn, :show, image))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    image = Assets.get_image!(id)
    conn =
      conn
      |> set_user_info
      |> assign(:action, "<script>Intercom('trackEvent', 'see_image_detail');</script>")
    render(conn, "show.html", image: image)
  end

  def edit(conn, %{"id" => id}) do
    image = Assets.get_image!(id)
    changeset = Assets.change_image(image)
    render(conn, "edit.html", image: image, changeset: changeset)
  end

  def update(conn, %{"id" => id, "image" => image_params}) do
    image = Assets.get_image!(id)

    case Assets.update_image(image, image_params) do
      {:ok, image} ->
        conn
        |> put_flash(:info, "Image updated successfully.")
        |> redirect(to: image_path(conn, :show, image))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", image: image, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    image = Assets.get_image!(id)
    {:ok, _image} = Assets.delete_image(image)

    conn
    |> put_flash(:info, "Image deleted successfully.")
    |> redirect(to: image_path(conn, :index))
  end

end
