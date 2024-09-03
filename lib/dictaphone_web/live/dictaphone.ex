# lib/pento_web/live/wrong_live.ex
defmodule DictaphoneWeb.Dictaphone do
  use DictaphoneWeb, :live_view

  alias Dictaphone.Audio
  alias DictaphoneWeb.Endpoint

  def mount(_params, _session, socket) do
    if connected?(socket), do: Endpoint.subscribe("clips")

    {:ok, assign(socket, clips: Audio.list_clips())}
  end

  def handle_info(%{event: "clip_updated"}, socket) do
    {:noreply, assign(socket, clips: Audio.list_clips())}
  end

  def handle_event("delete_clip", %{"id" => id}, socket) do
    clip = Audio.get_clip!(id)
    ExAws.S3.delete_object(System.get_env("BUCKET_NAME"), clip.name) |> ExAws.request()
    {:ok, _clip} = Audio.delete_clip(clip)
    Endpoint.broadcast("clips", "clip_updated", %{})
    {:noreply, assign(socket, clips: Audio.list_clips())}
  end

  def handle_event("rename_clip", %{"id" => id, "name" => name}, socket) do
    clip = Audio.get_clip!(id)
    bucket = System.get_env("BUCKET_NAME")

    if name != clip.name do
      ExAws.S3.put_object_copy(bucket, name, bucket, clip.name) |> ExAws.request()
      ExAws.S3.delete_object(bucket, clip.name) |> ExAws.request()
      {:ok, _clip} = Audio.update_clip(clip, %{name: name})
      Endpoint.broadcast("clips", "clip_updated", %{})
    end

    {:noreply, assign(socket, clips: Audio.list_clips())}
  end
end
