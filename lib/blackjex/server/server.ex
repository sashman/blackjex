defmodule Blackjex.Server.Server do
  use GenServer
  alias Blackjex.Game.ServerState
  alias Blackjex.Server.Helpers.GameId

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

  @impl true
  def handle_call({:show_state}, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:join, player_name}, from, state) do
    new_game_id = GameId.id_from_pid(from)

    with {:ok, state} <- ServerState.new_game(state, new_game_id, player_name) do
      {:reply, {"Welcome #{player_name}!", new_game_id}, state}
    else
      {:error, _, "game already exists"} ->
        {:reply, "You area already in a game", state}
    end
  end

  @impl true
  def handle_call({:hit}, from, state) do
    game_id = GameId.id_from_pid(from)

    with {:ok, state} <- ServerState.hit(state, game_id) do
      {:reply, {state, "Hit!"}, state}
    else
      {:error, :no_game, _message} ->
        {:reply, "You are not in a game, please join first", state}
    end
  end
end
