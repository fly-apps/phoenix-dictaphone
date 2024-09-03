defmodule DictaphoneWeb.AudioController do
  use DictaphoneWeb, :controller

  alias DictaphoneWeb.Endpoint
  alias Dictaphone.Audio

  def put(conn, %{"name" => name}) do
    case Audio.create_clip(%{name: name}) do
      {:ok, clip} ->
        Endpoint.broadcast("clips", "clip_updated", %{})
        json conn, clip

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset.errors})
    end
  end
end
