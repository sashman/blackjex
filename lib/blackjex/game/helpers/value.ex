defmodule Blackjex.Game.Helpers.Value do

  alias Blackjex.Game.{Player, Deck}

  @doc ~S"""
  Calculate player hand score

  ## Examples

      iex> %Player{hand: [
      ...>  %Card{rank: "ACE", suit: "Club"},
      ...> ]} |> Blackjex.Game.Helpers.Value.player_hand_score()
      1

      iex> %Player{hand: []} |> Blackjex.Game.Helpers.Value.player_hand_score()
      0

      iex> %Player{hand: [
      ...>  %Card{rank: "ACE", suit: "Club"},
      ...>  %Card{rank: "2", suit: "Club"},
      ...>  %Card{rank: "3", suit: "Club"},
      ...>  %Card{rank: "4", suit: "Club"},
      ...>  %Card{rank: "King", suit: "Club"},
      ...> ]} |> Blackjex.Game.Helpers.Value.player_hand_score()
      20

  """

  def player_hand_score(%Player{hand: []}), do: 0

  def player_hand_score(%Player{hand: hand})do
    hand
    |> Enum.reduce(0, fn card, total ->
      Deck.card_value(card) + total
    end)
  end

end
