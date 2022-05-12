defmodule ExAssistantWeb.PageController do
  use ExAssistantWeb, :controller
  alias FrontierSilicon.Constants

  def index(conn, _params) do
    connection = FrontierSilicon.Worker.connect()

    params =
      Constants.get
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {param, index} -> {index, param, get_param(connection, param)} end)
    lists = 
      Constants.list
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {param, index} -> {index, param, get_list(connection, param)} end)

    render(conn, "index.html", params: params ++ lists)
  end

  defp get_list(connection, param) do
    try do
      connection
      |> FrontierSilicon.Worker.handle_list(param)
      |> inspect()
    rescue
      error ->
        IO.inspect(error)
        :error
    end
  end
  defp get_param(connection, param) do
    try do
      FrontierSilicon.Worker.handle_get(connection, param)
    rescue
      error ->
        IO.inspect(error)
        :error
    end
  end
end
