

/// Switch between building an executable for interactive use, or to test performance only.
/// true => binary solves a predetermined set of puzzles and prints the time used
/// false => binary takes a file argument, and tries to parse and then solve the puzzle contained in the file
pub const BUILD_FOR_PERFORMANCE_TEST = false;

/// switch between 9x9 sudoku and 16x16 sudoku
/// true => 16x16 puzzles
/// false => 9x9 puzzles
pub const SUPER_SUDOKU_MODE = false;
