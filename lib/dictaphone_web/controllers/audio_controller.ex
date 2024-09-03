defmodule DictaphoneWeb.AudioController do
  use DictaphoneWeb, :controller

  alias DictaphoneWeb.Endpoint
  alias Dictaphone.Audio

  def get(conn, %{"name" => name}) do
    request = ExAws.S3.get_object(System.get_env("BUCKET_NAME"), name)
    response = request |> ExAws.request()
    case response do
      {:ok, %{body: body, headers: headers}} ->
        headers = headers |> Enum.into(%{})
        conn
        |> put_resp_content_type(headers["content-type"] || "application/octet-stream")
        |> Plug.Conn.send_resp(:ok, body)
      error ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: inspect(error)})
    end
  end

  def put(conn, %{"name" => name}) do
    case Audio.create_clip(%{name: name}) do
      {:ok, clip} ->
        content_type = get_req_header(conn, "content-type") |> List.first() || "application/octet-stream"
        {:ok, body, conn} = Plug.Conn.read_body(conn)

        request = ExAws.S3.put_object(System.get_env("BUCKET_NAME"), name, body, content_type: content_type)
        response = request |> ExAws.request()

        Endpoint.broadcast("clips", "clip_updated", %{})

        case response do
          {:ok, _} ->
            conn
            |> put_status(:created)
            |> json(clip)
          error ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{error: inspect(error)})
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset.errors})
    end
  end
end
