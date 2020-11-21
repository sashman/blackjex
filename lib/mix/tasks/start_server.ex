defmodule Mix.Tasks.StartServer do
  use Mix.Task

  def run(_) do
    IO.puts("Starting Blackjex")
    IO.inspect(Node.self())
  end
end
