defmodule Blackjex.GameStateTest do
  use ExUnit.Case
  alias Blackjex.Game.{GameState, Player, Card, Round}
  doctest Blackjex.Game.GameState

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
                 ],
                 loss: false
               }
             ]
    end

    test "resets player hand and score" do
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
    end

    test "resets player hand back to deck" do
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

      assert result.deck.cards == [
               %Card{rank: "ACE", suit: "Spade"},
               %Card{rank: "King", suit: "Club"}
             ]
    end
  end

  describe ".round_lost" do
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
      result = GameState.round_lost(game)

      assert result.rounds == [
               %Round{
                 score: 10,
                 hand: [
                   %Card{rank: "King", suit: "Club"}
                 ],
                 loss: true
               }
             ]
    end

    test "resets deck and player hand and score" do
      cards = [
        %Card{rank: "King", suit: "Club"},
        %Card{rank: "ACE", suit: "Spade"}
      ]

      game = %GameState{
        deck: %Blackjex.Game.Deck{
          cards: cards
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
      assert length(result.deck.cards) == length(cards)
    end
  end

  describe ".apply_win_condition" do
    test "does not reset game when no loss" do
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
      {:continue, result} = GameState.apply_win_condition(game)

      assert result.rounds == []
    end

    test "resets game when round is lost" do
      cards = [
        %Card{rank: "King", suit: "Club"},
        %Card{rank: "King", suit: "Spade"},
        %Card{rank: "King", suit: "Hearts"}
      ]

      game = %GameState{
        deck: %Blackjex.Game.Deck{
          cards: cards
        },
        player: %Player{
          name: "test",
          hand: []
        }
      }

      game = GameState.hit(game)
      game = GameState.hit(game)
      game = GameState.hit(game)
      {:loss, result} = GameState.apply_win_condition(game)

      _rounds = result.rounds

      assert result.player.score == 0
      assert result.player.hand == []
      assert length(result.deck.cards) == length(cards)
      assert _rounds = [%Round{loss: true}]
    end

    test "resets game when max score is hit" do
      cards = [
        %Card{rank: "King", suit: "Club"},
        %Card{rank: "9", suit: "Spade"},
        %Card{rank: "2", suit: "Hearts"}
      ]

      game = %GameState{
        deck: %Blackjex.Game.Deck{
          cards: cards
        },
        player: %Player{
          name: "test",
          hand: []
        }
      }

      game = GameState.hit(game)
      game = GameState.hit(game)
      game = GameState.hit(game)
      {:max_score, result} = GameState.apply_win_condition(game)

      _rounds = result.rounds

      assert result.player.score == 0
      assert result.player.hand == []
      assert length(result.deck.cards) == length(cards)
      assert _rounds = [%Round{loss: false, score: 21}]
    end
  end
end
