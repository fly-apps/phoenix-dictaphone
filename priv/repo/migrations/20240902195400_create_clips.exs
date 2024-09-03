defmodule Dictaphone.Repo.Migrations.CreateClips do
  use Ecto.Migration

  def change do
    create table(:clips) do
      add :name, :string
      add :text, :text

      timestamps(type: :utc_datetime)
    end
  end
end
