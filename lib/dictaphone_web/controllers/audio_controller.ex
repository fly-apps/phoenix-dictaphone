defmodule DictaphoneWeb.AudioController do
  use DictaphoneWeb, :controller

  alias DictaphoneWeb.Endpoint
  alias Dictaphone.Audio

  def get(conn, %{"name" => name}) do
    request = ExAws.S3.get_object(System.get_env("BUCKET_NAME"), name)

    case request |> ExAws.request() do
      {:ok, %{body: body, headers: headers}} ->
        content_type =
          Enum.find(
            headers,
            fn {name, _} -> String.downcase(name) == "content-type" end
          )
          |> elem(1)

        conn
        |> put_resp_content_type(content_type || "application/octet-stream")
        |> send_resp(200, body)

      error ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: inspect(error)})
    end
  end

  def put(conn, %{"name" => name}) do
    case Audio.create_clip(%{name: name}) do
      {:ok, clip} ->
        content_type =
          get_req_header(conn, "content-type") |> List.first() || "application/octet-stream"

        {:ok, body, conn} = Plug.Conn.read_body(conn)

        bucket = System.get_env("BUCKET_NAME")
        request = ExAws.S3.put_object(bucket, name, body, content_type: content_type)
        response = request |> ExAws.request()

        Endpoint.broadcast("clips", "clip_updated", %{})

        whisper_url = System.get_env("WHISPER_URL")

        if whisper_url != nil do
          spawn(fn ->
            {:ok, clip_url} =
              ExAws.Config.new(:s3)
              |> ExAws.S3.presigned_url(:get, bucket, name, expires_in: 3600)

            input = %{input: %{audio: clip_url}}

            whisper_url = URI.parse(whisper_url)
            |> Map.put(:path, "/predictions")
            |> URI.to_string()

            %{body: response} =
              Req.put!(whisper_url,
                inet6: true,
                headers: %{content_type: "application/json"},
                json: %{input: input}
              )

            {:ok, _} = Audio.update_clip(clip, %{text: response["output"]["transcription"]})
            Endpoint.broadcast("clips", "clip_updated", %{})
          end)
        end

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
