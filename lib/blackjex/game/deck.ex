defmodule Blackjex.Game.Deck do
  alias Blackjex.Game.Card

  defstruct cards: []

  @suits [
    "Club",
    "Spade",
    "Heart",
    "Diamond"
  ]

  @value_map %{
    "ACE" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "Jack" => 10,
    "Queen" => 10,
    "King" => 10
  }

  def new_deck() do
    @suits
    |> Enum.flat_map(fn suit ->
      @value_map
      |> Map.keys()
      |> Enum.map(fn rank ->
        %Card{rank: rank, suit: suit}
      end)
    end)
    |> Enum.shuffle()
  end
end
