defmodule Blackjex.Client.Client do
  def connet(sid, cookie) when is_atom(sid) do
    {:ok, _} = Node.start(:client)
    Node.set_cookie(String.to_atom(cookie))
    Node.connect(sid)
  end

  def call(sid, command) when is_atom(sid) do
    GenServer.call({Blackjex.Server.Server, sid}, command)
  end
end
