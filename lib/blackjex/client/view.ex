defmodule Blackjex.Client.View do
  alias Blackjex.Game.{Card, Stats}

  @border "===================="
  @suit_unicode_map %{
    "Club" => "\u2663",
    "Spade" => "\u2660",
    "Heart" => "\u2661",
    "Diamond" => "\u2662"
  }

  @rank_map %{
    "ACE" => "A",
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
    border(fn ->
      IO.puts(data)
      IO.puts("You have no cards, hit to get some!")
    end)
  end

  def render({:already_joined, _}) do
    border(fn ->
      IO.puts("Welcome back!")
      IO.puts("Check your hand!")
    end)
  end

  def render({:cards, data}) do
    cards = data.hand

    border(fn ->
      render_cards(cards)
      IO.puts("Your score is: #{data.score}")
    end)
  end

  def render({:hit, :continue, data}) do
    cards = data.player.hand

    border(fn ->
      render_cards(cards)
      IO.puts("Your score is: #{data.player.score}")
    end)
  end

  def render({:hit, :loss, data}) do
    lost_round = List.last(data.rounds)

    border(fn ->
      IO.puts("You lost!")
      render_cards(lost_round.hand)
      IO.puts("Your score was #{lost_round.score}")
      IO.puts("Your hand is now empty")
    end)
  end

  def render({:hit, :max_score, data}) do
    lost_round = List.last(data.rounds)

    border(fn ->
      render_cards(lost_round.hand)
      IO.puts("Your score was #{lost_round.score}! Congratulations!")
      IO.puts("Your hand is now empty")
    end)
  end

  def render({:stick, _}) do
    border(fn ->
      IO.puts("New round")
    end)
  end

  def render({:stats, %Stats{average: average, max: max, limit_score_count: limit_score_count}}) do
    border(fn ->
      IO.puts("Your averge score is: #{average}")
      IO.puts("Your maximum score is: #{max}")
      IO.puts("You have hit 21 #{limit_score_count} time(s)")
    end)
  end

  def render({view, data}) do
    IO.inspect(view, label: "rendering")
  end

  def render({view, _data, _}) do
    IO.inspect(view, label: "rendering")
  end

  defp render_cards([]) do
    IO.puts("Your hand is empty")
  end

  defp border(fun) when is_function(fun) do
    IO.puts(@border)
    fun.()
    IO.puts(@border)
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
