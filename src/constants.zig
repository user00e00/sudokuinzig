const std = @import("std");
const build_config = @import("build_config.zig");


pub const NUM_BOX = if(build_config.SUPER_SUDOKU_MODE) 4 else 3;
pub const NUM_SIDE = NUM_BOX * NUM_BOX;
pub const NUM_SQUARES = NUM_SIDE * NUM_SIDE;

pub const RawString = []const u8;

pub const BoardValue = std.meta.IntType(false,std.math.log2_int(u64,NUM_SQUARES));

pub const SudokuResultStatus = enum {
    NOT_SOLVABLE,
    SOLVED,
    BAD_INITIAL_BOARD,
    MAXITER_REACHED,
};

pub const SudokuResult = struct {
    boardValues: [NUM_SQUARES]BoardValue,
    resultStatus: SudokuResultStatus,
};

pub const SudokuSolverFn = fn ([NUM_SQUARES]BoardValue) SudokuResult;
