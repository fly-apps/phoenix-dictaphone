defmodule Dictaphone.Repo do
  use Ecto.Repo,
    otp_app: :dictaphone,
    adapter: Ecto.Adapters.Postgres
end
