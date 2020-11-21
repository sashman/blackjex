defmodule Blackjex.Game.Helpers.WinCondition do
  alias Blackjex.Game.GameState

  @score_limit 21

  def round_over?(game_state = %GameState{}) do
    current_score = game_state.player.score

    cond do
      current_score > @score_limit -> {:loss, current_score, game_state.player}
      current_score == @score_limit -> {:max_score, current_score, game_state.player}
      true -> {:no_round_over}
    end
  end
end
