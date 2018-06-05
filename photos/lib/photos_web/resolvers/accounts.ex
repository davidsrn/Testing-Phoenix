defmodule PhotosWeb.Resolvers.Accounts do

  def find_user(_parent, %{id: id}, _resolution) do

    case Photos.Accounts.find_user(id) do
      nil ->
        {:error, "User ID #{id} not found"}
      user ->
        {:ok, user}
    end

  end
end