defmodule FawkesWeb.MessageController do
  use FawkesWeb, :controller
  alias Fawkes.Chat.Message, as: MessageRepo
  alias FawkesWeb.Utils
  alias Fawkes.Chat

  def create(conn, params) do
    room_id = params["room_id"]

    if is_nil(Chat.get_room(room_id)) do
      conn
      |> render("errors.json", %{errors: ["invalid room id"]})
    else
      case MessageRepo.create_message(params) do
        {:ok, _message} ->
          conn
          |> render("ack.json", %{success: true, message: "Message created"})

        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> render("errors.json", %{errors: Utils.format_changeset_errors(changeset)})

        true ->
          conn
          |> render("ack.json", %{succes: false, message: Utils.internal_srever_error()})
      end
    end
  end
end
