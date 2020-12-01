defmodule MineSweeper do
    def height(grid), do: Enum.count(grid) - 1
    def width(grid) do
        grid
        |> Enum.at(0)
        |> Enum.count()
        |> (fn x -> x - 1 end).()
    end

    def bomb?(_grid, [x,y]) when x < 0 or y < 0, do: false
    def bomb?(grid, [x,y]) do
      if x >= height(grid) or y >= width(grid) do
          false
      else
          grid
          |> Enum.at(y)
          |> Enum.at(x)
          |> String.equivalent?("*")
     end
    end

    def offsets do
      # Yeah it's dirty but i mean it works?
      # You could be really fancy and write a permutation calculator
      # but you'd be making your life hard for no reason
      [
        [-1, -1],
        [-1, 0],
        [-1, 1],
        [0, 1],
        [0, -1],
        [1, -1],
        [1, 0],
        [1, 1],
      ]
    end

    def coordinate_from_offset([x1, y1], [x2, y2]) do
      [x1+x2, y1+y2]
    end

    def adjacent_bombs(grid, coord) do
        offsets()
        |> Enum.map(&(coordinate_from_offset(coord, &1)))
        |> Enum.map(&(bomb?(grid, &1)))
        |> Enum.count(fn x -> x == true end)
    end

    def solve(grid) when is_binary(grid) do
        grid
        |> String.split("\n")
        |> Enum.reject(fn x -> String.length(x) == 0 end)
        |> Enum.map(fn x ->
            x
            |> String.split("")
            |> Enum.reject(fn x -> String.length(x) == 0 end)
        end)
        |> solve()
    end

    def solve(grid) do
        0..height(grid)
        |> Enum.map(fn y_index ->
            0..width(grid)
            |> Enum.map(
                fn x_index ->
                    if bomb?(grid, [x_index, y_index]) do
                        "*"
                    else
                        adjacent_bombs(grid, [x_index, y_index])
                    end
                end
            )
        end)
    end
end

grid = """
*...
....
.*..
....
"""

MineSweeper.solve(grid)
|> Enum.map(&(Enum.join(&1, " ")))
|> Enum.join("\n")
|> IO.puts
