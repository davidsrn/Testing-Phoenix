defmodule Photos.Assets.Image do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset


  schema "images" do
    field :filename, Photos.ImageFile.Type
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:name, :filename])
    |> validate_required([:name, :filename])
  end
end
