defmodule PhotosWeb.ImageController do
  use PhotosWeb, :controller

  alias Photos.Assets
  alias Photos.Assets.Image
  # import PhotosWeb.Controllers.PageController, only: [:set_user_info]

  def index_html(conn, _params) do
    images = Assets.list_images()
    render(conn, "index.html", images: images)
  end

  def index(conn, _params) do
    images = Assets.list_images()
    maybe_user =
      conn
      |> PhotosWeb.Controllers.PageController.set_user_info(_params)
    render(conn, "index.json", images: images, maybe_user: maybe_user)
  end

  def new(conn, _params) do
    changeset = Assets.change_image(%Image{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"image" => image_params}) do
    case Assets.create_image(image_params) do
      {:ok, image} ->
        conn
        |> put_flash(:info, "Image created successfully.")
        |> redirect(to: image_path(conn, :show, image))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    image = Assets.get_image!(id)
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
