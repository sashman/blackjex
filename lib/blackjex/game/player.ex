defmodule Blackjex.Game.Player do
  defstruct [:name, actions: [], hand: []]

  def receive_card(player = %__MODULE__{hand: hand}, card) do
    new_hand = hand ++ [card]

    %{player | hand: new_hand}
  end
end
