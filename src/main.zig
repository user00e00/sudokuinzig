const std = @import("std");
const process = std.process;
const warn = std.debug.warn;
usingnamespace @import("constants.zig");
const build_config = @import("build_config.zig");

const solve: SudokuSolverFn = @import("solver1/solver1.zig").solve;


pub const main = switch(build_config.BUILD_FOR_PERFORMANCE_TEST){
        true => solveMultiplePuzzles,
        else => solvePuzzleFromFile,
};


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

    const boardArray = importNxN(NUM_SIDE,puzzleFileName) catch |e| switch (e) {
        error.FileNotFound => {
            warn("Got: {}\n", .{e});
            return;
        },
        else => {
            warn("Got: {}\n", .{e});
            return;
        },
    };

    printBoard("Board init to:\n", boardArray);
    warn("\nTrying to solve it..\n", .{});

    const res = solve(boardArray);

    warn("Result status: {}\n", .{res.resultStatus});
    printBoard("Board changed to:\n", res.boardValues);
}

/// main function for performance testing
pub fn solveMultiplePuzzles() anyerror!void {
    if(NUM_SQUARES!=81){
        warn("Aborting. Performance test is for 9x9 sudoku puzzles. Configuration was for {}x{} puzzles.\n",.{NUM_SIDE, NUM_SIDE});
        return;
    }

    const puzzleSet = @import("performance_multiple_puzzles/puzzle_set_4.zig").puzzleSet;
    const puzzleSetSize = puzzleSet.len;
    
    warn("Starting to solve {} puzzles...\n", .{puzzleSetSize});
    
    const milliTimestampFn = std.time.milliTimestamp;
    const startTime = milliTimestampFn();
    
    solveAllPuzzles(puzzleSet);
    
    const endTime = milliTimestampFn();
    const diffTimeMillis : f32 = @intToFloat(f32,endTime-startTime);
    const puzzlesPerSecond = 1000*(@intToFloat(f32,puzzleSetSize)/diffTimeMillis);
    
    warn("Done in {d} ms, puzzles/s = {d}\n",.{diffTimeMillis, puzzlesPerSecond});
}


fn printBoard(prompt: []const u8, board: [NUM_SQUARES]BoardValue) void {
    warn("{}", .{prompt[0..]});
    const horizDivider = switch(NUM_SIDE){
        9 => "---------+---------+---------\n",
        16 => "------------+------------+------------+------------\n",
        else => "\n",
    };
    const numFormatStr = switch(NUM_SIDE){
        9 => " {d} ",
        16 => "{d:2} ",
        else => "{d:3} ",
    } ;
   var i: usize = 0;
    while (i < (NUM_SQUARES)) : (i += 1) {
        const idxAtNewline = (i != 0) and ( (i % NUM_SIDE) == 0);
        const idxAtVertBorder = i != 0 and (i % NUM_SIDE) != 0 and (i % NUM_BOX) == 0;
        const idxAtHorizBorder = i!=0 and i% (NUM_SIDE*NUM_BOX) == 0;

        if(idxAtNewline){
            warn("\n", .{});
        }
        if(idxAtVertBorder){
            warn("|",.{});
        }else if(idxAtHorizBorder){
            warn(horizDivider, .{});
        }
        warn(numFormatStr, .{board[i]});
    }
    warn("\n", .{});
}

fn importNxN(comptime N : u32, filename: []const u8) anyerror![N*N]BoardValue {
    const cwd = std.fs.cwd();
    const openFlag = std.fs.File.OpenFlags{};

    var memory: [4000]u8 = [_]u8{'0'} ** 4000;
    var fixed_alloc = std.heap.FixedBufferAllocator.init(memory[0..]);
    var alloc: *std.mem.Allocator = &fixed_alloc.allocator;

    const fileContents = try cwd.readFileAlloc(alloc, filename, 4000 - 1);

    var board: [N*N]BoardValue = [_]BoardValue{0} ** (N*N);
    var i: usize = 0;
    var k: usize = 0;

    while (i < fileContents.len) : (i += 1) {
        const b = fileContents[i];
        const num = charToDigit(b, @as(BoardValue, 0));
        if (num != 255) {
            const numCasted = switch( @bitSizeOf(u8) > @bitSizeOf(BoardValue) ){
                true => @truncate(BoardValue,num),
                else => @intCast(BoardValue,num),
            };
            board[k] = numCasted;
            k += 1;
            if (k > (N*N-1)) break;
        }
    }
    return board;
}


fn charArrayLen81ToPuzzle(charArray: []const u8) [NUM_SQUARES]BoardValue {
    var out: [NUM_SQUARES]BoardValue = [_]BoardValue{0} ** NUM_SQUARES;
    var k: usize = 0;
    while (k < charArray.len) : (k += 1) {
        const mustTruncate = @bitSizeOf(u8) > @bitSizeOf(BoardValue);
        const num = charToDigit(charArray[k]);
        const numCasted = switch(mustTruncate){
            true => @truncate(BoardValue,num),
            else => @intCast(BoardValue,num),
        };
        out[k] = numCasted;
    }
    return out;
}

fn charToDigit(c: u8) u8 {
    const numVal : u8 = switch (c) {
        '.' => 0,
        '_' => 0,
        '0'...'9' => c - '0',
        'a' => 10,
        'b' => 11,
        'c' => 12,
        'd' => 13,
        'e' => 14,
        'f' => 15,
        'g' => 16,
        else => 255,
    };
    return numVal;

}


fn solveAndAssertIsSolved(puzzleCharArray81 : []const u8) void{
    const board = charArrayLen81ToPuzzle(puzzleCharArray81);
    const res = solve(board);
    const assert = @import("std").debug.assert;
    assert(res.resultStatus == .SOLVED);
}

fn solveAllPuzzles(puzzlesArray : [][]const u8) void{
    const len = puzzlesArray.len;
    var k : u32 = 0;
    while(k<len) : (k+=1) {
        solveAndAssertIsSolved(puzzlesArray[k]);
    }
}
