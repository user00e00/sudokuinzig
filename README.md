# sudokuinzig

Simple sudoku solver written in zig. 

Imports a sudoku puzzle from a "sudoku.txt" file, and if the puzzle is solvable, creates a file "sudoku_solved.txt" with the solution.
Prints some information to terminal while running, but does not currently give any detailed information on unsolvable sudokus.

The solver represents the sudoku board with an array of board positions, where the portion of it that is "filled in" grows and shrinks
as the solver runs. Does elimination of invalid candidate numbers, and will create "guessing branches" if there's no position on the board
where a number can be inserted unambiguously. 

To run: "zig build run"

