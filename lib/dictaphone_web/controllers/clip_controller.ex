defmodule DictaphoneWeb.ClipController do
  use DictaphoneWeb, :controller

  alias Dictaphone.Audio
  alias Dictaphone.Audio.Clip

  def index(conn, _params) do
    clips = Audio.list_clips()
    render(conn, :index, clips: clips)
  end

  def new(conn, _params) do
    changeset = Audio.change_clip(%Clip{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"clip" => clip_params}) do
    case Audio.create_clip(clip_params) do
      {:ok, clip} ->
        conn
        |> put_flash(:info, "Clip created successfully.")
        |> redirect(to: ~p"/clips/#{clip}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    clip = Audio.get_clip!(id)
    render(conn, :show, clip: clip)
  end

  def edit(conn, %{"id" => id}) do
    clip = Audio.get_clip!(id)
    changeset = Audio.change_clip(clip)
    render(conn, :edit, clip: clip, changeset: changeset)
  end

  def update(conn, %{"id" => id, "clip" => clip_params}) do
    clip = Audio.get_clip!(id)

    case Audio.update_clip(clip, clip_params) do
      {:ok, clip} ->
        conn
        |> put_flash(:info, "Clip updated successfully.")
        |> redirect(to: ~p"/clips/#{clip}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, clip: clip, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    clip = Audio.get_clip!(id)
    {:ok, _clip} = Audio.delete_clip(clip)

    conn
    |> put_flash(:info, "Clip deleted successfully.")
    |> redirect(to: ~p"/clips")
  end
end
