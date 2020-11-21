defmodule Blackjex.Client.View do
  alias Blackjex.Game.Card

  @border "===================="
  @suit_unicode_map %{
    "Club" => "\u2663",
    "Spade" => "\u2660",
    "Heart" => "\u2661",
    "Diamond" => "\u2662"
  }

  @rank_map %{
    "ACE" => "1",
    "2" => "2",
    "3" => "3",
    "4" => "4",
    "5" => "5",
    "6" => "6",
    "7" => "7",
    "8" => "8",
    "9" => "9",
    "Jack" => "B",
    "Queen" => "D",
    "King" => "E"
  }

  @spec render({any, any}) :: any
  def render({:join, data}) do
    IO.puts(@border)
    IO.puts(data)
    IO.puts(@border)
  end

  def render({:already_joined, data}) do
    IO.puts(@border)
    IO.puts(data)
    IO.puts("Check your hand!")
    IO.puts(@border)
  end

  def render({:cards, data}) do
    cards = data.hand
    IO.puts(@border)
    render_cards(cards)
    IO.puts("Your score is: #{data.score}")
    IO.puts(@border)
  end

  defp render_cards([]) do
    IO.puts("Your hand is empty")
  end

  defp render_cards(cards) do
    IO.write("|")

    cards
    |> Enum.map(fn %Card{rank: rank, suit: suit} ->
      "#{@rank_map[rank]}#{@suit_unicode_map[suit]}"
    end)
    |> Enum.join("|")
    |> IO.write()

    IO.puts("|")
  end

  def render({view, _data}) do
    IO.inspect(view, label: "rendering")
  end
end
