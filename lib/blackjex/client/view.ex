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
    "Jack" => "J",
    "Queen" => "Q",
    "King" => "K"
  }

  def render({:join, data}) do
    IO.puts(@border)
    IO.puts(data)
    IO.puts("You have no cards, hit to get some!")
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

  def render({:hit, :continue, data}) do
    cards = data.player.hand
    IO.puts(@border)
    render_cards(cards)
    IO.puts("Your score is: #{data.player.score}")
    IO.puts(@border)
  end

  def render({:hit, :loss, data}) do
    lost_round = List.last(data.rounds)
    IO.puts(@border)
    IO.puts("You lost!")
    render_cards(lost_round.hand)
    IO.puts("Your score was #{lost_round.score}")
    IO.puts("Your hand is now empty")
    IO.puts(@border)
  end

  def render({:hit, :max_score, data}) do
    lost_round = List.last(data.rounds)
    IO.puts(@border)
    render_cards(lost_round.hand)
    IO.puts("Your score was #{lost_round.score}! Congratulations!")
    IO.puts("Your hand is now empty")
    IO.puts(@border)
  end

  def render({:stick, data}) do
    IO.puts(@border)
    IO.puts("New round")
    IO.puts(@border)
  end

  def render({view, _data}) do
    IO.inspect(view, label: "rendering")
  end

  def render({view, _data, _}) do
    IO.inspect(view, label: "rendering")
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
end
