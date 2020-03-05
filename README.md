# sudokuinzig

Simple and robust sudoku solver written in zig, version 0.5.0+ae99fabfe.

The solver algorithm uses a mix of regular candidate elimination in a depth first solution search, and uses additional group based elimination heuristic to prune the search tree.

The solver represents the sudoku board with an array of board positions together with an ordered list of insertions that grows and shrinks as the algorithm explores the solution tree
until either an inconsistency, the full solution is found, or max iterations are reached.

To try:

```
zig build;
cd bin;
./sudokuinzig ../sudoku.txt
```
Parsing the input file, this program ignores characters apart from `0`, `.`, `_` (treated as empty) and numbers `1` to `9`, and appends these until all 81 squares have been assigned to.

There is also an extensive test suite, run tests with

```
zig test test_multiple.zig;
zig test test_hard_puzzles.zig;
```
