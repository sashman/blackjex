defmodule Blackjex.Client.Prompt do
  alias Blackjex.Client.{Client, View}

  @options [
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
    },
    {
      "stats",
      :stats
    }
  ]

  def ask_for_name() do
    ExPrompt.string_required("What is your name? ")
  end

  def join_game(sid, name) when is_atom(sid) do
    Client.call(sid, {:join, name})
    |> View.render()
  end

  def play_game(sid) when is_atom(sid) do
    ask_for_input(sid)
  end

  defp ask_for_input(sid) do
    answer = ExPrompt.choose("What is you move? ", @options |> Enum.map(&(&1 |> elem(0))))
    answer = @options |> Enum.at(answer) |> elem(1)

    Client.call(sid, {answer})
    |> View.render()

    ask_for_input(sid)
  end
end
