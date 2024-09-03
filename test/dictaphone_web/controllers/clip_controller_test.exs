defmodule DictaphoneWeb.ClipControllerTest do
  use DictaphoneWeb.ConnCase

  import Dictaphone.AudioFixtures

  @create_attrs %{name: "some name", text: "some text"}
  @update_attrs %{name: "some updated name", text: "some updated text"}
  @invalid_attrs %{name: nil, text: nil}

  describe "index" do
    test "lists all clips", %{conn: conn} do
      conn = get(conn, ~p"/clips")
      assert html_response(conn, 200) =~ "Listing Clips"
    end
  end

  describe "new clip" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/clips/new")
      assert html_response(conn, 200) =~ "New Clip"
    end
  end

  describe "create clip" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/clips", clip: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/clips/#{id}"

      conn = get(conn, ~p"/clips/#{id}")
      assert html_response(conn, 200) =~ "Clip #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/clips", clip: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Clip"
    end
  end

  describe "edit clip" do
    setup [:create_clip]

    test "renders form for editing chosen clip", %{conn: conn, clip: clip} do
      conn = get(conn, ~p"/clips/#{clip}/edit")
      assert html_response(conn, 200) =~ "Edit Clip"
    end
  end

  describe "update clip" do
    setup [:create_clip]

    test "redirects when data is valid", %{conn: conn, clip: clip} do
      conn = put(conn, ~p"/clips/#{clip}", clip: @update_attrs)
      assert redirected_to(conn) == ~p"/clips/#{clip}"

      conn = get(conn, ~p"/clips/#{clip}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, clip: clip} do
      conn = put(conn, ~p"/clips/#{clip}", clip: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Clip"
    end
  end

  describe "delete clip" do
    setup [:create_clip]

    test "deletes chosen clip", %{conn: conn, clip: clip} do
      conn = delete(conn, ~p"/clips/#{clip}")
      assert redirected_to(conn) == ~p"/clips"

      assert_error_sent 404, fn ->
        get(conn, ~p"/clips/#{clip}")
      end
    end
  end

  defp create_clip(_) do
    clip = clip_fixture()
    %{clip: clip}
  end
end
