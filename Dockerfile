FROM elixir:1.11.2

RUN mix local.hex --force && \
  mix local.rebar --force

COPY . .

RUN mix deps.get && mix compile

CMD [ "iex", "--name", "server@server", "--cookie", "some-cookie-name", "-S", "mix" ]