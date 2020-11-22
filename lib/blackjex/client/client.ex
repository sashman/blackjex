defmodule Blackjex.Client.Client do
  def connect(sid, cookie, player_name) when is_atom(sid) do
    {:ok, _} =
      player_name
      |> String.replace(~r/[\/:]/, "_")
      |> String.to_atom()
      |> Node.start()

    Node.set_cookie(String.to_atom(cookie))
    Node.connect(sid)
  end

  def call(sid, command) when is_atom(sid) do
    GenServer.call({Blackjex.Server.Server, sid}, command)
  end
end
