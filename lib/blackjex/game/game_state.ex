defmodule Blackjex.Game.GameState do
  alias Blackjex.Game.{Deck, Player}

  defstruct [:deck, :player]

  @doc ~S"""
  Creates a new game state with a deck and a player, when give an optional player name

  ## Examples

      iex> game = Blackjex.Game.GameState.init()
      iex> %Blackjex.Game.GameState{player: player, deck: deck} = game
      iex> player != nil && deck != nil
      true

  """
  def init(player_name \\ "Jack") do
    deck = Deck.new_deck()
    player = %Player{name: player_name}

    %__MODULE__{
      player: player,
      deck: deck
    }
  end

end
