defmodule FawkesWeb.RoomController do
  use FawkesWeb, :controller
  alias Fawkes.Chat
  alias FawkesWeb.Utils

  def list(conn, _params) do
    conn
    |> render("ack.json", %{success: true, data: Chat.list_rooms()})
  end

  def ping(conn, _params) do
    conn
    |> render("ack.json", %{success: true, message: "pong"})
  end

  def create(conn, params) do
    case Chat.create_room(params) do
      {:ok, _room} ->
        conn
        |> render("ack.json", %{success: true, message: "Room created"})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("errors.json", %{errors: Utils.format_changeset_errors(changeset)})

      true ->
        conn
        |> render("ack.json", %{succes: false, message: Utils.internal_srever_error()})
    end
  end
end
