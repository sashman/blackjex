# Blackjex

Blackjack implementation for the spec https://gist.github.com/lepoetemaudit/de55dfdbdbe9767e8e387ea8d058f400

The game of blackjack is ran on a dedicated server and supports multiple players playing a game each. At it's core is a GenServer which accepts commands from a client and manages state of the game.

## Usage

Install deps:

```
mix deps.get
```

Run tests with:

```
mix test
```

Start server with:

```bash
iex --name server@127.0.0.1 \
    --cookie some-cookie-name -S mix
```

Play with:

```bash
mix play server@127.0.0.1 some-cookie-name
```

## Approach

I began by implementing the `GameState` module while lead to a very smooth functional implementation. I consciously avoided thinking about GenServer part of the implementation which allowed for easy testing of state and game logic. The `GameState` was further wrapped in a `ServerState` which was created to server at top level state to be used by the GenServer.

Once I was able to drive the game through the interactive console I was sure that I could being with the GenServer integration. This was made very easy due to the `ServerState` being available. The GenServer layer performs some very basic translation in the protocol which can be pushed into a different service layer.

The GenServer also includes some helpers for local server debugging.

Once the game was playable in the interactive console via the GenServer, I began implementing a client. This took some research as this was my first implementation of calling GenServers remotely. I chose to use a mix task with an interactive prompt for the client. For user input I used `ex_prompt` package, however this was probably over kill as its features were really that great.

Finally the client was split into communication, prompt and view modules. The communication sent messages to the server, prompt drove the user input loop and view was responsible for rendering the message responses.

## ACE value calculation

As the total value of the hand is calculated, make sure the multi-value cards (ACEs) are sorted towards the end. When deciding if which value of the ACE to use, check if adding the high value of the ACE is going to take the total over the limit (21), if no, use the hight value, otherwise use the low value.

## Room for improvement

Given time to improve, I would tackle the following areas:

- Improve test coverage in the client modules.
- Improve the interface for communicating with the server
  - Switch to using `GenServer.start_link({:global, __MODULE__}, %{}, name: __MODULE__)` namer registration to prevent multiple servers running by both client and server. This would also prevent the client needing to use `sid` (server id), every time it wants to send a command
  - Push the command interface into the server itself, so the client can call a clean `Server.join(...)`, `Server.join()`, etc calls.
- Some refactoring of constants in the Game module, e.g. score limit of 21 is spread through out a few modules.
- Try including the server into a Phoenix app and see if it could be integrated via Endpoint and enable HTTP clients.
