defmodule Dictaphone.Audio.Clip do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :text, :inserted_at, :updated_at]}

  schema "clips" do
    field :name, :string
    field :text, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(clip, attrs) do
    clip
    |> cast(attrs, [:name, :text])
    |> validate_required([:name])
  end
end
