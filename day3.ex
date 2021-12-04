defmodule Diagnostic do
  @moduledoc false

  alias ReadFile

  def input, do: ReadFile.parse("day3.txt", "\n")

  def part_one() do
    frequencies =
      input()
      |> groups()
      |> frequencies()

    gamma =
      frequencies
      |> most_common()
      |> string_list_to_integer()

    epsilon =
      frequencies
      |> least_common()
      |> string_list_to_integer()

    gamma * epsilon
  end

  def part_two() do
    input = input()
    frequencies =
      input
      |> groups()
      |> frequencies()

    most_frequent_with_index =
      frequencies
      |> most_common()
      |> Enum.with_index()
      |> Enum.map(fn {a, b} -> {b, a} end)
      |> Enum.into(%{})

    least_frequent_with_index =
      frequencies
      |> least_common()
      |> Enum.with_index()
      |> Enum.map(fn {a, b} -> {b, a} end)
      |> Enum.into(%{})

    o2 =
      input
      |> filter_binaries(:max, 0)
      |> String.to_integer(2)
    co2 =
      input
      |> filter_binaries(:min, 0)
      |> String.to_integer(2)

    {o2, co2}

  end


  def filter_binaries([binary], _, _) do
    binary
  end

  def filter_binaries(binaries, :max, i) do
    b_idx =
      binaries
      |> groups()
      |> frequencies()
      |> Enum.map(&
        if &1["0"] == &1["1"] do
          Map.delete(&1, "0")
        else
          &1
        end
      )
      |> IO.inspect(label: "MAX")
      |> most_common()
      |> Enum.with_index()
      |> Enum.map(fn {a, b} -> {b, a} end)
      |> Enum.into(%{})

    new_binaries = Enum.filter(binaries, fn x -> String.at(x, i) == b_idx[i] end)
    filter_binaries(new_binaries, :max, i + 1)
  end

  def filter_binaries(binaries, :min, i) do
    b_idx =
      binaries
      |> groups()
      |> frequencies()
      |> Enum.map(&
        if &1["0"] == &1["1"] do
          Map.delete(&1, "1")
        else
          &1
        end
      )
      |> IO.inspect(label: "MIN")
      |> least_common()
      |> Enum.with_index()
      |> Enum.map(fn {a, b} -> {b, a} end)
      |> Enum.into(%{})

    new_binaries = Enum.filter(binaries, fn x -> String.at(x, i) == b_idx[i] end)
    filter_binaries(new_binaries, :min, i + 1)
  end

  def groups(binaries) do
    binaries
    |> Enum.flat_map(&
      &1
      |> String.codepoints()
      |> Enum.with_index()
    )
    |> Enum.group_by(fn {_, index} -> index end)
  end

  def frequencies(groups) do
    groups
    |> Enum.map(fn {_, list} ->
      list
      |> Enum.flat_map(&
        &1
        |> Tuple.delete_at(1)
        |> Tuple.to_list()
      )
      |> Enum.frequencies()
    end)
  end

  def most_common(frequencies), do: get_rate(frequencies, :max)
  def least_common(frequencies), do: get_rate(frequencies, :min)

  def get_rate(frequencies, rate) do
    frequencies
    |> Enum.flat_map(&
      &1
      |> do_get_rate(rate)
      |> Tuple.delete_at(1)
      |> Tuple.to_list()
    )
  end

  def do_get_rate(map, :max), do: Enum.max_by(map, fn {_, y} -> y end)
  def do_get_rate(map, :min), do: Enum.min_by(map, fn {_, y} -> y end)

  def string_list_to_integer(list) do
    list
    |> List.to_string()
    |> String.to_integer(2)
  end
end
