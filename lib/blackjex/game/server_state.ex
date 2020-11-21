defmodule Blackjex.Game.ServerState do
  alias Blackjex.Game.GameState

  defstruct game_states: %{}

  @doc ~S"""
  Creates a new server state

  ## Examples

      iex> Blackjex.Game.ServerState.init()
      %Blackjex.Game.ServerState{}

  """
  def init do
    %__MODULE__{}
  end

  @doc ~S"""
  Given an id and a server, creates a new game, if one doesn't already exist

  ## Examples

      iex> server = Blackjex.Game.ServerState.init()
      iex> server = Blackjex.Game.ServerState.new_game(server, "new-game")
      iex> with {:ok, %Blackjex.Game.ServerState{}} <- server, do: :passed
      :passed

  """
  def new_game(server_state = %__MODULE__{}, game_id, player_name \\ nil) do
    cond do
      Map.has_key?(server_state, game_id) -> {:error, game_id, "game already exists"}
      true -> game = GameState.init(player_name)
        {:ok, Map.put(server_state, game_id, game)}
    end
  end

end
