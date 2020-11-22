defmodule Blackjex.Game.Helpers.Value do
  alias Blackjex.Game.{Player, Deck}

  @doc ~S"""
  Calculate player hand score

  ## Examples

      iex> %Player{hand: [
      ...>  %Card{rank: "ACE", suit: "Club"},
      ...> ]} |> Blackjex.Game.Helpers.Value.player_hand_score()
      11

      iex> %Player{hand: [
      ...>  %Card{rank: "ACE", suit: "Club"},
      ...>  %Card{rank: "ACE", suit: "Club"},
      ...>  %Card{rank: "ACE", suit: "Club"},
      ...> ]} |> Blackjex.Game.Helpers.Value.player_hand_score()
      13

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

  def player_hand_score(%Player{hand: hand}) do
    hand
    |> sort_double_scores()
    |> Enum.reduce(0, fn card, total ->
      value =
        Deck.card_value(card)
        |> pick_best_value(total)

      value + total
    end)
  end

  def pick_best_value({min, max}, total) do
    cond do
      total + max > 21 -> min
      true -> max
    end
  end

  def pick_best_value(value, _) when is_integer(value), do: value

  @doc ~S"""
  Sorts the variable scored ranks towrds the end of the list

  ## Examples

      iex> [
      ...>  %Card{rank: "ACE", suit: "Club"},
      ...>  %Card{rank: "King", suit: "Club"},
      ...> ] |> Blackjex.Game.Helpers.Value.sort_double_scores()
      [%Card{rank: "King", suit: "Club"}, %Card{rank: "ACE", suit: "Club"}]

      iex> [
      ...>  %Card{rank: "ACE", suit: "Club"},
      ...>  %Card{rank: "King", suit: "Club"},
      ...>  %Card{rank: "ACE", suit: "Club"},
      ...>  %Card{rank: "2", suit: "Club"},
      ...>  %Card{rank: "Queen", suit: "Club"},
      ...> ] |> Blackjex.Game.Helpers.Value.sort_double_scores()
      [
        %Blackjex.Game.Card{rank: "King", suit: "Club"},
        %Blackjex.Game.Card{rank: "2", suit: "Club"},
        %Blackjex.Game.Card{rank: "Queen", suit: "Club"},
        %Blackjex.Game.Card{rank: "ACE", suit: "Club"},
        %Blackjex.Game.Card{rank: "ACE", suit: "Club"}
      ]

  """
  def sort_double_scores(hand) when is_list(hand) do
    Enum.sort(hand, fn cardA, cardB ->
      a = Deck.card_value(cardA)
      b = Deck.card_value(cardB)

      case {a, b} do
        {{_, _}, {_, _}} -> true
        {{_, _}, _} -> false
        {_, {_, _}} -> true
        _ -> true
      end
    end)
  end
end
