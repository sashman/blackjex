defmodule Blackjex.Game.GameState do
  alias Blackjex.Game.{Deck, Player, Round}

  defstruct [:deck, :player, rounds: []]

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

  @doc ~S"""
  Get a card from the deck and give it to the player
  """
  def hit(game_state = %__MODULE__{deck: deck, player: player}) do
    {:ok, card, new_deck} =
      deck
      |> Deck.take_card()

    new_player = Player.receive_card(player, card)

    %{game_state | deck: new_deck, player: new_player}
  end

  def stick(game_state = %__MODULE__{}) do
    game_state
    |> record_round()
    |> reset_for_new_round()
  end

  def record_round(game_state = %__MODULE__{rounds: rounds, player: player}) do
    %Player{score: score, hand: hand} = player
    new_rounds = rounds ++ [%Round{score: score, hand: hand}]
    %{game_state | rounds: new_rounds}
  end

  def reset_for_new_round(game_state = %__MODULE__{player: player}) do
    new_deck = Deck.new_deck()

    new_player =
      player
      |> Player.reset_hand()
      |> Player.reset_score()

    %{game_state | player: new_player, deck: new_deck}
  end

  def show_player(game_state) do
    game_state.player
  end
end
