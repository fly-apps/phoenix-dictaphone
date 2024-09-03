defmodule Dictaphone.AudioTest do
  use Dictaphone.DataCase

  alias Dictaphone.Audio

  describe "clips" do
    alias Dictaphone.Audio.Clip

    import Dictaphone.AudioFixtures

    @invalid_attrs %{name: nil, text: nil}

    test "list_clips/0 returns all clips" do
      clip = clip_fixture()
      assert Audio.list_clips() == [clip]
    end

    test "get_clip!/1 returns the clip with given id" do
      clip = clip_fixture()
      assert Audio.get_clip!(clip.id) == clip
    end

    test "create_clip/1 with valid data creates a clip" do
      valid_attrs = %{name: "some name", text: "some text"}

      assert {:ok, %Clip{} = clip} = Audio.create_clip(valid_attrs)
      assert clip.name == "some name"
      assert clip.text == "some text"
    end

    test "create_clip/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Audio.create_clip(@invalid_attrs)
    end

    test "update_clip/2 with valid data updates the clip" do
      clip = clip_fixture()
      update_attrs = %{name: "some updated name", text: "some updated text"}

      assert {:ok, %Clip{} = clip} = Audio.update_clip(clip, update_attrs)
      assert clip.name == "some updated name"
      assert clip.text == "some updated text"
    end

    test "update_clip/2 with invalid data returns error changeset" do
      clip = clip_fixture()
      assert {:error, %Ecto.Changeset{}} = Audio.update_clip(clip, @invalid_attrs)
      assert clip == Audio.get_clip!(clip.id)
    end

    test "delete_clip/1 deletes the clip" do
      clip = clip_fixture()
      assert {:ok, %Clip{}} = Audio.delete_clip(clip)
      assert_raise Ecto.NoResultsError, fn -> Audio.get_clip!(clip.id) end
    end

    test "change_clip/1 returns a clip changeset" do
      clip = clip_fixture()
      assert %Ecto.Changeset{} = Audio.change_clip(clip)
    end
  end
end
