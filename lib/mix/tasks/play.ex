defmodule Mix.Tasks.Play do
  use Mix.Task
  alias Blackjex.Client.{Client, Prompt}

  def run([sid, cookie]) do
    IO.puts("Welcome to Blackjex Blackjack!")

    sid = String.to_atom(sid)

    name = Prompt.ask_for_name()
    Client.connect(sid, cookie, name)
    Prompt.join_game(sid, name)

    Prompt.play_game(sid)
  end
end
