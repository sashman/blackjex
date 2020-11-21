defmodule Blackjex.Server.Helpers.GameId do
  def random_id() do
    :os.system_time(:millisecond) |> Integer.to_string()
  end

  def id_from_pid(pid) do
    {pid, _} = pid
    pid |> inspect()
  end
end
