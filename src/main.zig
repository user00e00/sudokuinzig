const std = @import("std");
const process = std.process;
const warn = std.debug.warn;
usingnamespace @import("constants.zig");

const solve: SudokuSolverFn = @import("solver1/solver1.zig").solve;

const performanceTesting = false;
pub const main = if(performanceTesting) solveMultiplePuzzles else solvePuzzleFromFile;


/// main function for normal usage
fn solvePuzzleFromFile() anyerror!void {
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

/// main function for performance testing
fn solveMultiplePuzzles() anyerror!void {
    var x : SudokuResult = undefined;
    x = solve(charArrayLen81ToPuzzle("4.....8.5.3..........7......2.....6.....8.4......1.......6.3.7.5..2.....1.4......"));
    x = solve(charArrayLen81ToPuzzle("52...6.........7.13...........4..8..6......5...........418.........3..2...87....."));
    x = solve(charArrayLen81ToPuzzle("6.....8.3.4.7.................5.4.7.3..2.....1.6.......2.....5.....8.6......1...."));
    x = solve(charArrayLen81ToPuzzle("48.3............71.2.......7.5....6....2..8.............1.76...3.....4......5...."));
    x = solve(charArrayLen81ToPuzzle("....14....3....2...7..........9...3.6.1.............8.2.....1.4....5.6.....7.8..."));
    x = solve(charArrayLen81ToPuzzle("......52..8.4......3...9...5.1...6..2..7........3.....6...1..........7.4.......3."));
    x = solve(charArrayLen81ToPuzzle("6.2.5.........3.4..........43...8....1....2........7..5..27...........81...6....."));
    x = solve(charArrayLen81ToPuzzle(".524.........7.1..............8.2...3.....6...9.5.....1.6.3...........897........"));
    x = solve(charArrayLen81ToPuzzle("6.2.5.........4.3..........43...8....1....2........7..5..27...........81...6....."));
    x = solve(charArrayLen81ToPuzzle(".923.........8.1...........1.7.4...........658.........6.5.2...4.....7.....9....."));
    x = solve(charArrayLen81ToPuzzle("6..3.2....5.....1..........7.26............543.........8.15........4.2........7.."));
    x = solve(charArrayLen81ToPuzzle(".6.5.1.9.1...9..539....7....4.8...7.......5.8.817.5.3.....5.2............76..8..."));
    x = solve(charArrayLen81ToPuzzle("..5...987.4..5...1..7......2...48....9.1.....6..2.....3..6..2.......9.7.......5.."));
    x = solve(charArrayLen81ToPuzzle("3.6.7...........518.........1.4.5...7.....6.....2......2.....4.....8.3.....5....."));
    x = solve(charArrayLen81ToPuzzle("1.....3.8.7.4..............2.3.1...........958.........5.6...7.....8.2...4......."));
    x = solve(charArrayLen81ToPuzzle("6..3.2....4.....1..........7.26............543.........8.15........4.2........7.."));
    x = solve(charArrayLen81ToPuzzle("....3..9....2....1.5.9..............1.2.8.4.6.8.5...2..75......4.1..6..3.....4.6."));
    x = solve(charArrayLen81ToPuzzle("45.....3....8.1....9...........5..9.2..7.....8.........1..4..........7.2...6..8.."));
    x = solve(charArrayLen81ToPuzzle(".237....68...6.59.9.....7......4.97.3.7.96..2.........5..47.........2....8......."));
    x = solve(charArrayLen81ToPuzzle("..84...3....3.....9....157479...8........7..514.....2...9.6...2.5....4......9..56"));
    x = solve(charArrayLen81ToPuzzle(".98.1....2......6.............3.2.5..84.........6.........4.8.93..5...........1.."));
    x = solve(charArrayLen81ToPuzzle("..247..58..............1.4.....2...9528.9.4....9...1.........3.3....75..685..2..."));
    x = solve(charArrayLen81ToPuzzle("4.....8.5.3..........7......2.....6.....5.4......1.......6.3.7.5..2.....1.9......"));
    x = solve(charArrayLen81ToPuzzle(".2.3......63.....58.......15....9.3....7........1....8.879..26......6.7...6..7..4"));
    x = solve(charArrayLen81ToPuzzle("1.....7.9.4...72..8.........7..1..6.3.......5.6..4..2.........8..53...7.7.2....46"));
    x = solve(charArrayLen81ToPuzzle("4.....3.....8.2......7........1...8734.......6........5...6........1.4...82......"));
    x = solve(charArrayLen81ToPuzzle(".......71.2.8........4.3...7...6..5....2..3..9........6...7.....8....4......5...."));
    x = solve(charArrayLen81ToPuzzle("6..3.2....4.....8..........7.26............543.........8.15........8.2........7.."));
    x = solve(charArrayLen81ToPuzzle(".47.8...1............6..7..6....357......5....1..6....28..4.....9.1...4.....2.69."));
    x = solve(charArrayLen81ToPuzzle("......8.17..2........5.6......7...5..1....3...8.......5......2..4..8....6...3...."));
    x = solve(charArrayLen81ToPuzzle("38.6.......9.......2..3.51......5....3..1..6....4......17.5..8.......9.......7.32"));
    x = solve(charArrayLen81ToPuzzle("...5...........5.697.....2...48.2...25.1...3..8..3.........4.7..13.5..9..2...31.."));
    x = solve(charArrayLen81ToPuzzle(".2.......3.5.62..9.68...3...5..........64.8.2..47..9....3.....1.....6...17.43...."));
    x = solve(charArrayLen81ToPuzzle(".8..4....3......1........2...5...4.69..1..8..2...........3.9....6....5.....2....."));
    x = solve(charArrayLen81ToPuzzle("..8.9.1...6.5...2......6....3.1.7.5.........9..4...3...5....2...7...3.8.2..7....4"));
    x = solve(charArrayLen81ToPuzzle("4.....5.8.3..........7......2.....6.....5.8......1.......6.3.7.5..2.....1.8......"));
    x = solve(charArrayLen81ToPuzzle("1.....3.8.6.4..............2.3.1...........958.........5.6...7.....8.2...4......."));
    x = solve(charArrayLen81ToPuzzle("1....6.8..64..........4...7....9.6...7.4..5..5...7.1...5....32.3....8...4........"));
    x = solve(charArrayLen81ToPuzzle("249.6...3.3....2..8.......5.....6......2......1..4.82..9.5..7....4.....1.7...3..."));
    x = solve(charArrayLen81ToPuzzle("...8....9.873...4.6..7.......85..97...........43..75.......3....3...145.4....2..1"));
    x = solve(charArrayLen81ToPuzzle("...5.1....9....8...6.......4.1..........7..9........3.8.....1.5...2..4.....36...."));
    x = solve(charArrayLen81ToPuzzle("......8.16..2........7.5......6...2..1....3...8.......2......7..3..8....5...4...."));
    x = solve(charArrayLen81ToPuzzle(".476...5.8.3.....2.....9......8.5..6...1.....6.24......78...51...6....4..9...4..7"));
    x = solve(charArrayLen81ToPuzzle(".....7.95.....1...86..2.....2..73..85......6...3..49..3.5...41724................"));
    x = solve(charArrayLen81ToPuzzle(".4.5.....8...9..3..76.2.....146..........9..7.....36....1..4.5..6......3..71..2.."));
    x = solve(charArrayLen81ToPuzzle(".834.........7..5...........4.1.8..........27...3.....2.6.5....5.....8........1.."));
    x = solve(charArrayLen81ToPuzzle("..9.....3.....9...7.....5.6..65..4.....3......28......3..75.6..6...........12.3.8"));
    x = solve(charArrayLen81ToPuzzle(".26.39......6....19.....7.......4..9.5....2....85.....3..2..9..4....762.........4"));
    x = solve(charArrayLen81ToPuzzle("2.3.8....8..7...........1...6.5.7...4......3....1............82.5....6...1......."));
    x = solve(charArrayLen81ToPuzzle("6..3.2....1.....5..........7.26............843.........8.15........8.2........7.."));
    x = solve(charArrayLen81ToPuzzle("1.....9...64..1.7..7..4.......3.....3.89..5....7....2.....6.7.9.....4.1....129.3."));
    x = solve(charArrayLen81ToPuzzle(".........9......84.623...5....6...453...1...6...9...7....1.....4.5..2....3.8....9"));
    x = solve(charArrayLen81ToPuzzle(".2....5938..5..46.94..6...8..2.3.....6..8.73.7..2.........4.38..7....6..........5"));
    x = solve(charArrayLen81ToPuzzle("9.4..5...25.6..1..31......8.7...9...4..26......147....7.......2...3..8.6.4.....9."));
    x = solve(charArrayLen81ToPuzzle("...52.....9...3..4......7...1.....4..8..453..6...1...87.2........8....32.4..8..1."));
    x = solve(charArrayLen81ToPuzzle("53..2.9...24.3..5...9..........1.827...7.........981.............64....91.2.5.43."));
    x = solve(charArrayLen81ToPuzzle("1....786...7..8.1.8..2....9........24...1......9..5...6.8..........5.9.......93.4"));
    x = solve(charArrayLen81ToPuzzle("....5...11......7..6.....8......4.....9.1.3.....596.2..8..62..7..7......3.5.7.2.."));
    x = solve(charArrayLen81ToPuzzle(".47.2....8....1....3....9.2.....5...6..81..5.....4.....7....3.4...9...1.4..27.8.."));
    x = solve(charArrayLen81ToPuzzle("......94.....9...53....5.7..8.4..1..463...........7.8.8..7.....7......28.5.26...."));
    x = solve(charArrayLen81ToPuzzle(".2......6....41.....78....1......7....37.....6..412....1..74..5..8.5..7......39.."));
    x = solve(charArrayLen81ToPuzzle("1.....3.8.6.4..............2.3.1...........758.........7.5...6.....8.2...4......."));
    x = solve(charArrayLen81ToPuzzle("2....1.9..1..3.7..9..8...2.......85..6.4.........7...3.2.3...6....5.....1.9...2.5"));
    x = solve(charArrayLen81ToPuzzle("..7..8.....6.2.3...3......9.1..5..6.....1.....7.9....2........4.83..4...26....51."));
    x = solve(charArrayLen81ToPuzzle("...36....85.......9.4..8........68.........17..9..45...1.5...6.4....9..2.....3..."));
    x = solve(charArrayLen81ToPuzzle("34.6.......7.......2..8.57......5....7..1..2....4......36.2..1.......9.......7.82"));
    x = solve(charArrayLen81ToPuzzle("......4.18..2........6.7......8...6..4....3...1.......6......2..5..1....7...3...."));
    x = solve(charArrayLen81ToPuzzle(".4..5..67...1...4....2.....1..8..3........2...6...........4..5.3.....8..2........"));
    x = solve(charArrayLen81ToPuzzle(".......4...2..4..1.7..5..9...3..7....4..6....6..1..8...2....1..85.9...6.....8...3"));
    x = solve(charArrayLen81ToPuzzle("8..7....4.5....6............3.97...8....43..5....2.9....6......2...6...7.71..83.2"));
    x = solve(charArrayLen81ToPuzzle(".8...4.5....7..3............1..85...6.....2......4....3.26............417........"));
    x = solve(charArrayLen81ToPuzzle("....7..8...6...5...2...3.61.1...7..2..8..534.2..9.......2......58...6.3.4...1...."));
    x = solve(charArrayLen81ToPuzzle("......8.16..2........7.5......6...2..1....3...8.......2......7..4..8....5...3...."));
    x = solve(charArrayLen81ToPuzzle(".2..........6....3.74.8.........3..2.8..4..1.6..5.........1.78.5....9..........4."));
    x = solve(charArrayLen81ToPuzzle(".52..68.......7.2.......6....48..9..2..41......1.....8..61..38.....9...63..6..1.9"));
    x = solve(charArrayLen81ToPuzzle("....1.78.5....9..........4..2..........6....3.74.8.........3..2.8..4..1.6..5....."));
    x = solve(charArrayLen81ToPuzzle("1.......3.6.3..7...7...5..121.7...9...7........8.1..2....8.64....9.2..6....4....."));
    x = solve(charArrayLen81ToPuzzle("4...7.1....19.46.5.....1......7....2..2.3....847..6....14...8.6.2....3..6...9...."));
    x = solve(charArrayLen81ToPuzzle("......8.17..2........5.6......7...5..1....3...8.......5......2..3..8....6...4...."));
    x = solve(charArrayLen81ToPuzzle("963......1....8......2.5....4.8......1....7......3..257......3...9.2.4.7......9.."));
    x = solve(charArrayLen81ToPuzzle("15.3......7..4.2....4.72.....8.........9..1.8.1..8.79......38...........6....7423"));
    x = solve(charArrayLen81ToPuzzle("..........5724...98....947...9..3...5..9..12...3.1.9...6....25....56.....7......6"));
    x = solve(charArrayLen81ToPuzzle("....75....1..2.....4...3...5.....3.2...8...1.......6.....1..48.2........7........"));
    x = solve(charArrayLen81ToPuzzle("6.....7.3.4.8.................5.4.8.7..2.....1.3.......2.....5.....7.9......1...."));
    x = solve(charArrayLen81ToPuzzle("....6...4..6.3....1..4..5.77.....8.5...8.....6.8....9...2.9....4....32....97..1.."));
    x = solve(charArrayLen81ToPuzzle(".32.....58..3.....9.428...1...4...39...6...5.....1.....2...67.8.....4....95....6."));
    x = solve(charArrayLen81ToPuzzle("...5.3.......6.7..5.8....1636..2.......4.1.......3...567....2.8..4.7.......2..5.."));
    x = solve(charArrayLen81ToPuzzle(".5.3.7.4.1.........3.......5.8.3.61....8..5.9.6..1........4...6...6927....2...9.."));
    x = solve(charArrayLen81ToPuzzle("..5..8..18......9.......78....4.....64....9......53..2.6.........138..5....9.714."));
    x = solve(charArrayLen81ToPuzzle("..........72.6.1....51...82.8...13..4.........37.9..1.....238..5.4..9.........79."));
    x = solve(charArrayLen81ToPuzzle("...658.....4......12............96.7...3..5....2.8...3..19..8..3.6.....4....473.."));
    x = solve(charArrayLen81ToPuzzle(".2.3.......6..8.9.83.5........2...8.7.9..5........6..4.......1...1...4.22..7..8.9"));
    x = solve(charArrayLen81ToPuzzle(".5..9....1.....6.....3.8.....8.4...9514.......3....2..........4.8...6..77..15..6."));
    x = solve(charArrayLen81ToPuzzle(".....2.......7...17..3...9.8..7......2.89.6...13..6....9..5.824.....891.........."));
    x = solve(charArrayLen81ToPuzzle("3...8.......7....51..............36...2..4....7...........6.13..452...........8.."));

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

fn charArrayLen81ToPuzzle(charArray: []const u8) [NUM_SQUARES]BoardValue {
    var out: [NUM_SQUARES]BoardValue = [_]BoardValue{0} ** NUM_SQUARES;
    var k: usize = 0;
    while (k < charArray.len) : (k += 1) {
        out[k] = charToDigit(charArray[k], @as(BoardValue, 0));
    }
    return out;
}

fn charToDigit(c: u8, base: u8) u8 {
    return switch (c) {
        '.' => @as(u8, 0),
        '0'...'9' => c - '0',
        else => return @as(u8, 255),
    };
}
