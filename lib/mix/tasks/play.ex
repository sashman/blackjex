defmodule Mix.Tasks.Play do
  use Mix.Task

  def run([sid, cookie]) do
    IO.puts("Welcome to Blackjex Blackjack!")
    {:ok, _} = Node.start(:client)

    sid = String.to_atom(sid)
    Node.set_cookie(String.to_atom(cookie))
    Node.connect(sid)

    name = ExPrompt.string("What is your name? ")

    call(sid, {:join, name})
    |> IO.inspect()

    start_loop(sid)
  end

  defp start_loop(sid) do
    ask_for_input(sid)
  end

  defp ask_for_input(sid) do
    options = [
      {
        "hit",
        :hit
      },
      {
        "stick",
        :stick
      },
      {
        "cards",
        :cards
      }
    ]

    answer = ExPrompt.choose("What is you move? ", options |> Enum.map(&(&1 |> elem(0))))
    answer = options |> Enum.at(answer) |> elem(1)

    call(sid, {answer})
    |> IO.inspect()

    ask_for_input(sid)
  end

  defp call(sid, command) do
    GenServer.call({Blackjex.Server.Server, sid}, command)
  end
end
