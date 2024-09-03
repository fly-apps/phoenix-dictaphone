defmodule Dictaphone.AudioFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dictaphone.Audio` context.
  """

  @doc """
  Generate a clip.
  """
  def clip_fixture(attrs \\ %{}) do
    {:ok, clip} =
      attrs
      |> Enum.into(%{
        name: "some name",
        text: "some text"
      })
      |> Dictaphone.Audio.create_clip()

    clip
  end
end
