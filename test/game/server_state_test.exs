defmodule Blackjex.ServerStateTest do
  use ExUnit.Case
  doctest Blackjex.Game.ServerState

  alias Blackjex.Game.ServerState

  describe ".new_game" do
    test "given an id initialises a new game in the sever" do
      {:ok, server} =
        ServerState.init()
        |> ServerState.new_game("my-game")

      _games = server.game_states
      assert _games = %{"my-game" => %Blackjex.Game.GameState{}}
    end

    test "given an id of an existing game, returns an error" do
      {:ok, server} =
        ServerState.init()
        |> ServerState.new_game("my-game")

      assert {:error, "my-game", "game already exists"} == ServerState.new_game(server, "my-game")
    end
  end
end
