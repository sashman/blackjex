defmodule Blackjex.Helpers.WinConditionTest do
  use ExUnit.Case
  alias Blackjex.Game.Helpers.WinCondition
  alias Blackjex.Game.{Player, Card, GameState}

  describe ".round_over?" do
    test "round is no over when the player has less than score limit" do
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
      assert WinCondition.round_over?(game) == {:no_round_over}
    end

    test "round is over when the player is over the score limit" do
      game = %GameState{
        deck: %Blackjex.Game.Deck{
          cards: [
            %Card{rank: "King", suit: "Club"},
            %Card{rank: "King", suit: "Spades"},
            %Card{rank: "King", suit: "Hearts"}
          ]
        },
        player: %Player{
          name: "test",
          hand: []
        }
      }

      game = GameState.hit(game)
      game = GameState.hit(game)
      game = GameState.hit(game)

      assert WinCondition.round_over?(game) = {:loss, 30, _}
    end
  end
end
