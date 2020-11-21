defmodule Blackjex.Game.Player do
  alias Blackjex.Game.Helpers.Value

  defstruct [:name, actions: [], hand: [], score: 0]

  def receive_card(player = %__MODULE__{hand: hand}, card) do
    new_hand = hand ++ [card]

    new_player = %{player | hand: new_hand}
    score = Value.player_hand_score(new_player)

    %{new_player | score: score}
  end

end
