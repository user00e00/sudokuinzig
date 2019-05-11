const std = @import("std");

const BoardInsert = struct {
    row: u8,
    col: u8,
    value: u8,
    guessAmount: u8, //cardinality of bitmask with guess options
    guessOptions: u16, //bit mask storing (remaining) guess candidates

    fn getBoardIdx() u8 {
        return 9 * row + col;
    }

    fn isGuess() bool {
        return guessOptions & (1 << value) != 0;
    }
};

const SolverState = struct {
    var solverBoard: [81]?BoardInsert = []?BoardInsert{null} ** 81;
    var branchPointer: u8 = 0;
};

const Range = struct {
    //all values are inclusive
    const start: u8;
    const end: u8;

    fn init(s: u8, e: u8) Range {
        return Range{
            .start = s,
            .end = e,
        };
    }
};

pub fn logicSolverStage1(board: [81]u8) SolverState {
    // Phase 1.
    // Check if valid, add all board initialized inserts
    var output = SolverState{};

    // Phase 1.
    // Check if valid, add non-guessed inserts
    var k: u8 = 0;
    var insertIdx: u8 = 0;
    while (k < 81) {
        const row = k / 9;
        const col = k % 9;
        if (board[k] != 0 and willConflict(board, row, col, board[k])) {
            return error.BadBoard;
        } else {
            output.solverBoard[insertIdx] = BoardInsert{
                .row = row,
                .col = col,
                .value = board[k],
                .guessAmount = 0,
                .guessOptions = 0,
            };
            insertIdx += 1;
        }

        k += 1;
    }
    output.branchPointer = insertIdx;

    return output;
}

pub fn logicSolverStage2(state: SolverState) SolverState {
    // Phase 2
    var toExamine = Range.init(state.insertIdx, 81);
    var k: u8 = toExamine.start;
    while (k < toExamine.end) : (k += 1) {}
}

pub fn findCandidates(state: SolverState, row, col) BoardInsert {}

pub fn logicSolver(board: [81]u8) ![81]u8 {

    // Phase 1.
    // Check if valid, add non-guessed inserts
    var k: u8 = 0;
    var insertIdx: u8 = 0;
    while (k < 81) {
        const row = k / 9;
        const col = k % 9;
        if (board[k] != 0 and willConflict(board, row, col, board[k])) {
            std.debug.warn("k:{}\n", k);
            std.debug.warn("v:{}\n", board[k]);
            std.debug.warn("r:{}\n", row);
            std.debug.warn("c:{}\n", col);
            return error.BadBoard;
        } else {
            SolverState.solverBoard[insertIdx] = BoardInsert{
                .row = row,
                .col = col,
                .value = board[k],
                .guessAmount = 0,
                .guessOptions = 0,
            };
            insertIdx += 1;
        }

        k += 1;
    }
    SolverState.branchPointer = insertIdx;

    // Phase 2
    // Add guesses and consolidate all unambigious ones
    k = u8(insertIdx);
    while (k < 81) : (k += 1) {
        var num: u8 = 1;
        while (num < 10) {
            num += 1;
        }
    }

    // Phase 3.
    // Make guess with least possible branches
    // Return to phase 2, but

    // Phase 4.
    // Reach this phase if conflict. Backtrace, and remove
    // last guess.

    return board;
}

fn determineCandidates() [2]u8 {}

fn willConflict(board: [81]u8, row: u8, col: u8, newval: u8) bool {
    var result = false;
    const ignoredIdx = row * 9 + col;
    for (rowToPositionarray(row)) |boardIdx, k| {
        const value = board[boardIdx];
        if (value == newval and boardIdx != ignoredIdx) return true;
    }
    for (colToPositionArray(col)) |boardIdx, k| {
        const value = board[boardIdx];
        if (value == newval and boardIdx != ignoredIdx) return true;
    }
    const square = rowcolToSquare(row, col);
    for (squareToPositionarray(square)) |boardIdx, k| {
        const value = board[boardIdx];
        if (value == newval and boardIdx != ignoredIdx) return true;
    }
    return false;
}

fn posToIdx(row: u8, col: u8) u8 {
    assert(isSudokuPos(row) and isSudokuPos(col));
    return row * 9 + col;
}

fn isSudokuNumber(num: u8) bool {
    return num > 1 and num < 10;
}

fn isSudokuPos(num: u8) bool {
    return num >= 0 and num < 9;
}

fn rowToPositionarray(row: u8) [9]u8 {
    const shift = row * 9;
    return []u8{
        0 + shift, 1 + shift, 2 + shift,
        3 + shift, 4 + shift, 5 + shift,
        6 + shift, 7 + shift, 8 + shift,
    };
}

fn colToPositionArray(col: u8) [9]u8 {
    const shift = col;
    return []u8{
        0 + shift,  9 + shift,  18 + shift,
        27 + shift, 36 + shift, 45 + shift,
        54 + shift, 63 + shift, 72 + shift,
    };
}

fn rowcolToSquare(row: u8, col: u8) u8 {
    return 3 * (row / 3) + col / 3;
}

fn squareToPositionarray(sqr: u8) [9]u8 {
    const colstart: u8 = switch (sqr) {
        0, 3, 6 => u8(0),
        1, 4, 7 => 1,
        2, 5, 8 => 2,
        else => 14,
    };
    const rowstart: u8 = switch (sqr) {
        0, 1, 2 => u8(0),
        3, 4, 5 => 1,
        6, 7, 8 => 2,
        else => 14,
    };
    const shift = colstart * 3 + rowstart * 27;
    return []u8{
        0 + shift,
        1 + shift,
        2 + shift,
        9 + shift,
        10 + shift,
        11 + shift,
        18 + shift,
        19 + shift,
        20 + shift,
    };
}

const squares: [9][9]u8 = []u8{
    0,  1,  2,  9,  10, 11, 18, 19, 20,
    3,  4,  5,  12, 13, 14, 21, 22, 23,
    6,  7,  8,  15, 16, 17, 24, 25, 26,
    27, 28, 29, 36, 37, 38, 45, 46, 47,
    30, 31, 32, 39, 40, 41, 48, 49, 50,
    33, 34, 35, 42, 43, 44, 51, 52, 53,
    54, 55, 56, 63, 64, 65, 72, 73, 74,
    57, 58, 59, 66, 67, 68, 75, 76, 77,
    60, 61, 62, 69, 70, 71, 78, 79, 80,
};
