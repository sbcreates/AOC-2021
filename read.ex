defmodule ReadFile do
  @moduledoc false

  def parse(file, split) do
    file
    |> read_file
    |> String.split(split)
  end

  def read_file(file) do
    File.read!(file)
  end

end
