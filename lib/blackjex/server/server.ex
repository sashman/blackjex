defmodule Blackjex.Server.Server do
  use GenServer
  alias Blackjex.Game.ServerState
  alias Blackjex.Server.Helpers.GameId
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(_) do
    server_state = ServerState.init()
    {:ok, server_state}
  end

  def show_state() do
    GenServer.call(__MODULE__, {:show_state})
  end

  def join(player_name) do
    GenServer.call(__MODULE__, {:join, player_name})
  end

  def hit() do
    GenServer.call(__MODULE__, {:hit})
  end

  def stick() do
    GenServer.call(__MODULE__, {:stick})
  end

  def cards() do
    GenServer.call(__MODULE__, {:cards})
  end

  @impl true
  def handle_call({:show_state}, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:join, player_name}, from, state) do
    new_game_id = GameId.id_from_pid(from)

    with {:ok, state} <- ServerState.new_game(state, new_game_id, player_name) do
      {:reply, {:join, "Welcome #{player_name}!"}, state}
    else
      {:error, _, "game already exists"} ->
        {:reply, already_in_game_message(), state}
    end
  end

  @impl true
  def handle_call({:hit}, from, state) do
    game_id = GameId.id_from_pid(from)

    with {:ok, state} <- ServerState.hit(state, game_id) do
      {:reply, {:hit, get_players_game(state, game_id)}, state}
    else
      {:error, :no_game, _message} ->
        {:reply, no_game_message(), state}
    end
  end

  @impl true
  def handle_call({:stick}, from, state) do
    game_id = GameId.id_from_pid(from)

    with {:ok, state} <- ServerState.stick(state, game_id) do
      {:reply, {:stick, get_players_game(state, game_id)}, state}
    else
      {:error, :no_game, _message} ->
        {:reply, no_game_message(), state}
    end
  end

  def handle_call({:cards}, from, state) do
    game_id = GameId.id_from_pid(from)

    with {:ok, state, player} <- ServerState.cards(state, game_id) do
      {:reply, {:cards, player}, state}
    else
      {:error, :no_game, _message} ->
        {:reply, no_game_message(), state}
    end
  end

  defp get_players_game(state, game_id), do: state.game_states[game_id]

  defp already_in_game_message() do
    {:already_joined, "You are already in a game"}
  end

  defp no_game_message() do
    {:no_game, "You are not in a game, please join first"}
  end
end
