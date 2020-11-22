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
    # This can be changed to rely on the servers API to not have to look up using the sid
    GenServer.call({Blackjex.Server.Server, sid}, command)
  end
end
