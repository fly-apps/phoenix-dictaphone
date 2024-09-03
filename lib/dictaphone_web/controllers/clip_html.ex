defmodule DictaphoneWeb.ClipHTML do
  use DictaphoneWeb, :html

  embed_templates "clip_html/*"

  @doc """
  Renders a clip form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def clip_form(assigns)
end
