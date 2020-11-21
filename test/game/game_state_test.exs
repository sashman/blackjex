defmodule Blackjex.GameStateTest do
  use ExUnit.Case
  alias Blackjex.Game.{GameState, Player, Deck, Card}
  doctest Blackjex.Game.GameState

  describe ".hit" do
    test "take a card from the deck and give it to the player" do

      game = %GameState{
        deck: %Blackjex.Game.Deck{cards: [
          %Card{rank: "ACE", suit: "Club"},
          %Card{rank: "ACE", suit: "Spade"},
        ]},
        player: %Player{
          name: "test",
          hand: []
        }
      }

      result = GameState.hit(game)
      assert result.deck.cards == [%Card{rank: "ACE", suit: "Spade"}]
      assert result.player.hand == [%Card{rank: "ACE", suit: "Club"}]

    end
  end

end
