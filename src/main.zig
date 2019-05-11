const std = @import("std");
const boardimport = @import("boardimport.zig");
const boardexport = @import("boardexport.zig");

const solver = @import("elimandguesssolver.zig").elimAndGuessSolver;
//const solver = @import("randomwrongsolver.zig").randomWrongSolver;



pub fn main() anyerror!void {
    std.debug.warn("Start..\n");
    const boardArray = try boardimport.import("sudoku.txt"[0..]);


    printBoard("\n#init:\n", boardArray);
    const solvedBoard = try solver(boardArray);
    printBoard("\n#solved:\n", solvedBoard);

    const result = boardexport.exportboard("sudoku_solved.txt"[0..], solvedBoard);
}

fn printBoard(prompt: []const u8, board: [81]u8) void {
    std.debug.warn("{}", prompt[0..]);
    var i: usize = 0;
    while (i < 81) : (i += 1) {
        if (i == 0) {
            //do nothing
        } else if (i % 27 == 0) {
            std.debug.warn("\n------+------+------\n");
        } else if (i % 9 == 0) {
            std.debug.warn("\n");
        } else if (i % 3 == 0 and i != 0) {
            std.debug.warn("| ");
        }
        if (board[i] == 0) {
            std.debug.warn(". ");
        } else {
            std.debug.warn("{} ", (board[i]));
        }
    }
    std.debug.warn("\n");
}
