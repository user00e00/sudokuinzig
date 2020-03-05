const std = @import("std");
const process = std.process;
const warn = std.debug.warn;
usingnamespace @import("constants.zig");

const solve: SudokuSolverFn = @import("solver1/solver1.zig").solve;

pub fn main() anyerror!void {
    var args = process.args();

    var memory: [256]u8 = [_]u8{'0'} ** 256;
    var fixed_alloc = std.heap.FixedBufferAllocator.init(memory[0..]);
    var alloc: *std.mem.Allocator = &fixed_alloc.allocator;

    _ = try args.next(alloc) orelse {
        return error.BadArguments;
    };

    const puzzleFileName = try args.next(alloc) orelse {
        warn("Lacking file argument. Aborted.\n", .{});
        return;
    };
    warn("Trying to read puzzle from file: `{}`\n", .{puzzleFileName});

    const fileNameEndIdx = puzzleFileName.len - 1;

    const boardArray = import9x9(puzzleFileName) catch |e| switch (e) {
        error.FileNotFound => {
            warn("Got: {}\n", .{e});
            return;
        },
        else => {
            warn("Got: {}\n", .{e});
            return;
        },
    };

    printBoard9x9("Board init to:\n", boardArray);
    warn("Trying to solve it..\n", .{});

    const res = solve(boardArray);

    warn("Result status: {}\n", .{res.resultStatus});
    printBoard9x9("Board changed to:\n", res.boardValues);
}

fn printBoard9x9(prompt: []const u8, board: [81]u8) void {
    warn("{}", .{prompt[0..]});
    var i: usize = 0;
    while (i < 81) : (i += 1) {
        if (i == 0) {
            //do nothing
        } else if (i % 27 == 0) {
            warn("\n------+------+------\n", .{});
        } else if (i % 9 == 0) {
            warn("\n", .{});
        } else if (i % 3 == 0 and i != 0) {
            warn("| ", .{});
        }
        if (board[i] == 0) {
            warn(". ", .{});
        } else {
            warn("{} ", .{board[i]});
        }
    }
    warn("\n", .{});
}

fn import9x9(filename: []const u8) anyerror![81]u8 {
    const cwd = std.fs.cwd();
    const openFlag = std.fs.File.OpenFlags{};

    var memory: [4000]u8 = [_]u8{'0'} ** 4000;
    var fixed_alloc = std.heap.FixedBufferAllocator.init(memory[0..]);
    var alloc: *std.mem.Allocator = &fixed_alloc.allocator;

    const fileContents = try cwd.readFileAlloc(alloc, filename, 4000 - 1);

    var board: [81]u8 = [_]u8{0} ** 81;
    var i: usize = 0;
    var k: usize = 0;

    while (i < fileContents.len) : (i += 1) {
        const b = fileContents[i];
        const val = charToDigit(b, @as(u8, 0));
        if (val != 255) {
            board[k] = val;
            k += 1;
            if (k > 80) break;
        }
    }

    return board;
}

fn charToDigit(c: u8, base: u8) u8 {
    return switch (c) {
        '.' => @as(u8, 0),
        '0'...'9' => c - '0',
        else => return @as(u8, 255),
    };
}
