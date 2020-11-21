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

  @doc ~S"""
  Create a shuffled list of cards of suit(4) x rank(12) number of cards

  ## Examples

      iex> deck = Blackjex.Game.Deck.new_deck()
      iex> is_list(deck.cards) && length(deck.cards) == (4 * 12)
      true

  """

  def new_deck() do
    cards =
      @suits
      |> Enum.flat_map(fn suit ->
        @value_map
        |> Map.keys()
        |> Enum.map(fn rank ->
          %Card{rank: rank, suit: suit}
        end)
      end)
      |> Enum.shuffle()

    %__MODULE__{cards: cards}
  end

  @doc ~S"""
  Take card from top of the deck, errors if no more cards are left

  ## Examples

      iex> %Blackjex.Game.Deck{cards: []} |> Blackjex.Game.Deck.take_card()
      {:error, "no more cards left"}

      iex> %Blackjex.Game.Deck{cards: [
      ...>  %Card{rank: "ACE", suit: "Club"},
      ...>  %Card{rank: "ACE", suit: "Spade"},
      ...>  %Card{rank: "ACE", suit: "Diamond"}
      ...> ]} |> Blackjex.Game.Deck.take_card()
      {:ok, %Card{rank: "ACE", suit: "Club"}, %Blackjex.Game.Deck{cards: [%Card{rank: "ACE", suit: "Spade"}, %Card{rank: "ACE", suit: "Diamond"}]}}

  """
  def take_card(%__MODULE__{cards: cards}) when length(cards) < 1,
    do: {:error, "no more cards left"}

  def take_card(deck) do
    {card, new_cards} = List.pop_at(deck.cards, 0)
    new_deck = %{deck | cards: new_cards}

    {:ok, card, new_deck}
  end

  def put_cards_back(deck = %__MODULE__{cards: cards}, cards_to_put) when is_list(cards_to_put) do
    cards = cards ++ cards_to_put

    %{deck | cards: cards}
  end

  def card_value(card = %Card{}) do
    @value_map[card.rank]
  end
end
