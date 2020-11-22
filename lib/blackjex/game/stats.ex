defmodule Blackjex.Game.Stats do
  defstruct average: 0, limit_score_count: 0, max: 0
  alias Blackjex.Game.{GameState, Round}

  @score_limit 21

  @doc ~S"""
  Calculate player hand score

  ## Examples

      iex> %GameState{rounds: [
      ...> ]} |> Blackjex.Game.Stats.stats
      %Blackjex.Game.Stats{average: 0, limit_score_count: 0, max: 0}

      iex> %GameState{rounds: [
      ...>  %Round{loss: false, score: 1, hand: []}
      ...> ]} |> Blackjex.Game.Stats.stats
      %Blackjex.Game.Stats{average: 1.0, limit_score_count: 0, max: 1}

      iex> %GameState{rounds: [
      ...>  %Round{loss: false, score: 1, hand: []},
      ...>  %Round{loss: false, score: 21, hand: []},
      ...>  %Round{loss: true, score: 28, hand: []}
      ...> ]} |> Blackjex.Game.Stats.stats
      %Blackjex.Game.Stats{average: 11.0, limit_score_count: 1, max: 21}

  """

  def stats(%GameState{rounds: []}), do: %__MODULE__{}

  def stats(%GameState{rounds: rounds}) do
    no_loss_rounds =
      rounds
      |> Enum.filter(fn
        %Round{loss: false} -> true
        _ -> false
      end)

    no_loss_rounds_score_total =
      no_loss_rounds |> Stream.map(fn %Round{score: score} -> score end) |> Enum.sum()

    average = no_loss_rounds_score_total / length(no_loss_rounds)

    max =
      no_loss_rounds
      |> Stream.map(fn %Round{score: score} -> score end)
      |> Enum.max()

    limit_score_count =
      no_loss_rounds
      |> Enum.filter(fn
        %Round{score: @score_limit} -> true
        _ -> false
      end)
      |> length()

    %__MODULE__{average: average, max: max, limit_score_count: limit_score_count}
  end
end
