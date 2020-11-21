defmodule Blackjex.Client.Client do
  def connet(sid, cookie) do
    {:ok, _} = Node.start(:client)

    sid = String.to_atom(sid)
    Node.set_cookie(String.to_atom(cookie))
    Node.connect(sid)
  end

  def call(sid, command) do
    GenServer.call({Blackjex.Server.Server, sid}, command)
  end
end
