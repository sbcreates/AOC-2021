defmodule Diagnostic do
  @moduledoc false

  def input do
    "day3.txt"
    |> File.read!()
    |> String.split("\n")
  end

  def part_one() do
    binaries = input()
    do_part_one(binaries)
  end

  defp do_part_one(binaries) do
    frequencies =
      binaries
      |> Enum.flat_map(&
        &1
        |> String.codepoints()
        |> Enum.with_index()
      )
      |> Enum.group_by(fn {_, index} -> index end)
      |> Enum.map(fn {_, list} ->
        list
        |> Enum.flat_map(&
          &1
          |> Tuple.delete_at(1)
          |> Tuple.to_list()
        )
        |> Enum.frequencies()
      end)

    gamma_rate = get_rate(frequencies, :gamma)
    epsilon_rate = get_rate(frequencies, :epsilon)

    gamma_rate * epsilon_rate
  end

  defp get_rate(frequencies, rate) do
    frequencies
    |> Enum.map(&
      &1
      |> do_get_rate(rate)
      |> Tuple.delete_at(1)
      |> Tuple.to_list()
    )
    |> List.flatten()
    |> List.to_string()
    |> String.to_integer(2)
  end

  defp do_get_rate(map, :gamma), do: Enum.max_by(map, fn {_, y} -> y end)
  defp do_get_rate(map, :epsilon), do: Enum.min_by(map, fn {_, y} -> y end)
end
