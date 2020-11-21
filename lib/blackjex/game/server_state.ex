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
      iex> result = Blackjex.Game.ServerState.new_game(server, "new-game")
      iex> with {:ok, %Blackjex.Game.ServerState{}} <- result, do: :passed
      :passed

  ## Examples

      iex> server = Blackjex.Game.ServerState.init()
      iex> {:ok, server} = Blackjex.Game.ServerState.new_game(server, "new-game")
      iex> result = Blackjex.Game.ServerState.new_game(server, "new-game")
      iex> with {:error, "new-game", "game already exists"} <- result, do: :passed
      :passed

  """
  def new_game(server_state = %__MODULE__{}, game_id, player_name \\ nil) do
    cond do
      game_exists?(server_state, game_id) ->
        {:error, game_id, "game already exists"}

      true ->
        {:ok, create_new_game(server_state, player_name, game_id)}
    end
  end

  defp create_new_game(server_state = %__MODULE__{game_states: game_states}, player_name, game_id) do
    game = GameState.init(player_name)

    game_states = Map.put(game_states, game_id, game)
    %{server_state | game_states: game_states}
  end

  def hit(server_state = %__MODULE__{}, game_id) do
    guard_for_existing_game(
      server_state,
      game_id,
      fn ->
        {resolution, game_state} =
          server_state.game_states[game_id]
          |> GameState.hit()
          |> GameState.apply_win_condition()

        {:ok, server_state |> update_game_state(game_id, game_state), resolution}
      end
    )
  end

  def stick(server_state = %__MODULE__{}, game_id) do
    guard_for_existing_game(
      server_state,
      game_id,
      fn ->
        game_state =
          server_state.game_states[game_id]
          |> GameState.stick()

        {:ok, server_state |> update_game_state(game_id, game_state)}
      end
    )
  end

  def cards(server_state = %__MODULE__{}, game_id) do
    guard_for_existing_game(
      server_state,
      game_id,
      fn ->
        player =
          server_state.game_states[game_id]
          |> GameState.show_player()

        {:ok, server_state, player}
      end
    )
  end

  defp update_game_state(server_state = %__MODULE__{}, game_id, game_state) do
    game_states =
      server_state.game_states
      |> Map.put(game_id, game_state)

    %{server_state | game_states: game_states}
  end

  defp game_exists?(server_state, game_id), do: Map.has_key?(server_state.game_states, game_id)

  defp guard_for_existing_game(server_state, game_id, fun) when is_function(fun) do
    cond do
      game_exists?(server_state, game_id) ->
        fun.()

      true ->
        {:error, :no_game, "Game #{game_id} does not exist"}
    end
  end
end
