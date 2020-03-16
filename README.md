# sudokuinzig

Simple and robust sudoku solver written in zig (version 0.5.0+ae99fabfe).

It combines:
- Heuristic 1: Sole candidate
- Heuristic 2: Unique candidate for a given group
- Branching when the above heuristics are insufficient
- Backtracking

The solver represents the sudoku board with an array of board values together with an ordered list of insertions that grows and shrinks as the algorithm explores the solution tree
until either an inconsistency, the full solution is found, or max iterations are reached.

It is possible to build a binary for solving either 9x9 or 16x16 puzzles.

## Interactive Sudoku solver:

Creates a binary that reads a sudoku puzzle from a file and attempts to solve it.

### Interactive regular Sudoku solver (9x9 build:
Set the following boolean values in build_config.zig:
```
pub const BUILD_FOR_PERFORMANCE_TEST = false;
pub const SUPER_SUDOKU_MODE = false;

```
Then:
```
zig build;
cd bin;
./sudokuinzig ../sudoku9x9.txt
```

## Interactive "super" Sudoku solver (16x16) build:
Set the following boolean values in build_config.zig:
```
pub const BUILD_FOR_PERFORMANCE_TEST = false;
pub const SUPER_SUDOKU_MODE = true;

```
Then:
```
zig build;
cd bin;
./sudokuinzig ../sudoku16x16.txt
```


Parsing the input file, this program ignores characters apart from `0`, `.`, `_` (treated as empty) and numbers `1` to `9`, and appends these until all 81 squares have been assigned to.


Some tests are included

```
zig test test_9x9.zig;
zig test test_9x9_hard_puzzles.zig;
zig test test_16x16.zig;
```

## Performance test for 9x9 sudoku puzzles

Set the following boolean values in build_config.zig:
```
pub const BUILD_FOR_PERFORMANCE_TEST = true;
pub const SUPER_SUDOKU_MODE = false; 

```

Example output:

```
Starting to solve 870 puzzles...
Done in x ms, puzzles/s = y
```

