defmodule Bingo do
  @moduledoc false

  def parse(file, split) do
    file
    |> read_file
    |> String.split(split)
  end

  def read_file(file) do
    File.read!(file)
  end

  def boards do
    "day4_boards.txt"
    |> parse("\n\n")
    |> Enum.map(&
      &1
      |> String.split("\n")
      |> Enum.flat_map(fn b ->
        b
        |> String.splitter(["  ", " "])
        |> Enum.take(25)
      end)
    )
  end

  def numbers, do: parse("day4_nums.txt", ",")

  def part_one() do
    boards = boards()
    numbers = numbers()

    {winning_board, num} = play(boards, numbers)

    winning_sum(winning_board, num)
  end

  def play(boards, nums) do
    {num, new_nums} = draw_num(nums)
    boards = Enum.map(boards, &check_board(&1, num))
    winning_board = check_winner(boards)

    if winning_board do
      {winning_board, num}
    else
      play(boards, new_nums)
    end
  end

  def winning_sum(board, num) do
    board_sum =
      board
      |> Enum.filter(& &1 != "x")
      |> Enum.map(&String.to_integer(&1))
      |> Enum.sum

    board_sum * String.to_integer(num)
  end

  def draw_num(nums) do
    num = List.first(nums)
    new_nums = List.delete_at(nums, 0)

    {num, new_nums}
  end

  def check_board(board, num) do
    Enum.map(board, & (if &1 == num, do: "x", else: &1))
  end

  def check_winner(boards) do
    boards
    |> Enum.filter(&winner?(&1))
    |> case do
      [board] -> board
      _ -> nil
    end
  end

  defp winner?([
    "x","x","x","x","x",
    _, _, _, _, _,
    _, _, _, _, _,
    _, _, _, _, _,
    _, _, _, _, _
  ]), do: true

  defp winner?([
    _, _, _, _, _,
    "x","x","x","x","x",
    _, _, _, _, _,
    _, _, _, _, _,
    _, _, _, _, _
  ]), do: true

  defp winner?([
    _, _, _, _, _,
    _, _, _, _, _,
   "x","x","x","x","x",
    _, _, _, _, _,
    _, _, _, _, _
  ]), do: true

  defp winner?([
    _, _, _, _, _,
    _, _, _, _, _,
    _, _, _, _, _,
   "x","x","x","x","x",
    _, _, _, _, _
  ]), do: true

  defp winner?([
    _, _, _, _, _,
    _, _, _, _, _,
    _, _, _, _, _,
    _, _, _, _, _,
   "x","x","x","x","x"
  ]), do: true

  defp winner?([
    "x", _, _, _, _,
    "x", _, _, _, _,
    "x", _, _, _, _,
    "x", _, _, _, _,
    "x", _, _, _, _
  ]), do: true

  defp winner?([
    _, "x", _, _, _,
    _, "x", _, _, _,
    _, "x", _, _, _,
    _, "x", _, _, _,
    _, "x", _, _, _
  ]), do: true

  defp winner?([
    _, _, "x", _, _,
    _, _, "x", _, _,
    _, _, "x", _, _,
    _, _, "x", _, _,
    _, _, "x", _, _
  ]), do: true

  defp winner?([
    _, _, _, "x", _,
    _, _, _, "x", _,
    _, _, _, "x", _,
    _, _, _, "x", _,
    _, _, _, "x", _
  ]), do: true

  defp winner?([
    _, _, _, _, "x",
    _, _, _, _, "x",
    _, _, _, _, "x",
    _, _, _, _, "x",
    _, _, _, _, "x"
  ]), do: true

  defp winner?(_), do: false

end
