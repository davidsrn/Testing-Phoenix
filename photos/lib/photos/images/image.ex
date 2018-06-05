defmodule Photos.Images.Image do
  use Ecto.Schema
  import Ecto.Changeset


  schema "images" do
    field :image, :string

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:image])
    |> validate_required([:image])
  end
end
