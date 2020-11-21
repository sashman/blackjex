defmodule Mix.Tasks.Play do
  use Mix.Task
  alias Blackjex.Client.{Client, Prompt}

  def run([sid, cookie]) do
    IO.puts("Welcome to Blackjex Blackjack!")

    sid = String.to_atom(sid)

    Client.connet(sid, cookie)
    Prompt.join_game(sid)

    Prompt.play_game(sid)
  end
end