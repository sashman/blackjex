defmodule Blackjex.GameStateTest do
  use ExUnit.Case
  alias Blackjex.Game.{GameState, Player, Card, Round}
  doctest Blackjex.Game.GameState

  @deck_size 12 * 4

  describe ".hit" do
    test "take a card from the deck and give it to the player" do
      game = %GameState{
        deck: %Blackjex.Game.Deck{
          cards: [
            %Card{rank: "ACE", suit: "Club"},
            %Card{rank: "ACE", suit: "Spade"}
          ]
        },
        player: %Player{
          name: "test",
          hand: []
        }
      }

      result = GameState.hit(game)
      assert result.deck.cards == [%Card{rank: "ACE", suit: "Spade"}]
      assert result.player.hand == [%Card{rank: "ACE", suit: "Club"}]
    end

    test "player score is updated" do
      game = %GameState{
        deck: %Blackjex.Game.Deck{
          cards: [
            %Card{rank: "King", suit: "Club"},
            %Card{rank: "ACE", suit: "Spade"}
          ]
        },
        player: %Player{
          name: "test",
          hand: []
        }
      }

      assert game.player.score == 0
      result = GameState.hit(game)
      assert result.player.score == 10
    end
  end

  describe ".stick" do
    test "records round results" do
      game = %GameState{
        deck: %Blackjex.Game.Deck{
          cards: [
            %Card{rank: "King", suit: "Club"},
            %Card{rank: "ACE", suit: "Spade"}
          ]
        },
        player: %Player{
          name: "test",
          hand: []
        }
      }

      game = GameState.hit(game)
      result = GameState.stick(game)

      assert result.rounds == [
               %Round{
                 score: 10,
                 hand: [
                   %Card{rank: "King", suit: "Club"}
                 ]
               }
             ]
    end

    test "resets deck and player hand and score" do
      game = %GameState{
        deck: %Blackjex.Game.Deck{
          cards: [
            %Card{rank: "King", suit: "Club"},
            %Card{rank: "ACE", suit: "Spade"}
          ]
        },
        player: %Player{
          name: "test",
          hand: []
        }
      }

      game = GameState.hit(game)
      result = GameState.stick(game)

      assert result.player.score == 0
      assert result.player.hand == []
      assert length(result.deck.cards) == @deck_size
    end
  end
end
