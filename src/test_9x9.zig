const std = @import("std");

usingnamespace @import("constants.zig");

const solver = @import("solver1/solver1.zig").solve;



fn fulltestExact(puzzle: [NUM_SQUARES]BoardValue, solution: [NUM_SQUARES]BoardValue) void{
    const result = solver(puzzle);
    std.testing.expectEqual(SudokuResultStatus.SOLVED,result.resultStatus);
    std.testing.expectEqual(solution,result.boardValues);
    return;
}

fn fulltest(puzzle: [NUM_SQUARES]BoardValue, solution: [NUM_SQUARES]BoardValue) void{
    const result = solver(puzzle);
    std.testing.expectEqual(SudokuResultStatus.SOLVED,result.resultStatus);
    return;
}


fn expectError(puzzle : [NUM_SQUARES]BoardValue) void{
    const result = solver(puzzle);
    std.testing.expect(result.resultStatus != .SOLVED);
}


test "verify correct configuration" {
    // only allow these tests when configuration is set to 9x9 sudoku puzzles
    std.testing.expectEqual(9, NUM_SIDE);
}



test "only one missing" {
        fulltestExact(
[NUM_SQUARES]BoardValue{3,9,5,1,6,4,2,8,7,0,1,8,7,2,3,9,6,5,6,2,7,9,8,5,4,1,3,5,4,6,8,3,9,1,7,2,2,8,1,6,4,7,3,5,9,7,3,9,2,5,1,8,4,6,9,6,2,5,1,8,7,3,4,1,7,3,4,9,6,5,2,8,8,5,4,3,7,2,6,9,1},
[NUM_SQUARES]BoardValue{3,9,5,1,6,4,2,8,7,4,1,8,7,2,3,9,6,5,6,2,7,9,8,5,4,1,3,5,4,6,8,3,9,1,7,2,2,8,1,6,4,7,3,5,9,7,3,9,2,5,1,8,4,6,9,6,2,5,1,8,7,3,4,1,7,3,4,9,6,5,2,8,8,5,4,3,7,2,6,9,1},
        );
}

test "only a few missing" {
        fulltestExact(
[NUM_SQUARES]BoardValue{3,0,5,1,6,4,2,8,7,0,1,8,7,2,3,9,6,5,6,2,7,9,8,5,4,1,3,5,4,6,8,3,0,1,7,2,2,8,1,6,4,7,3,5,9,0,3,9,2,5,1,8,4,6,0,6,2,5,1,8,7,3,4,1,7,3,4,9,6,5,2,8,8,5,4,3,7,2,6,9,1},
[NUM_SQUARES]BoardValue{3,9,5,1,6,4,2,8,7,4,1,8,7,2,3,9,6,5,6,2,7,9,8,5,4,1,3,5,4,6,8,3,9,1,7,2,2,8,1,6,4,7,3,5,9,7,3,9,2,5,1,8,4,6,9,6,2,5,1,8,7,3,4,1,7,3,4,9,6,5,2,8,8,5,4,3,7,2,6,9,1},
        );
}



test "puzzle3" {
        fulltest(
[NUM_SQUARES]BoardValue{5,0,3,0,7,0,0,6,0,7,0,0,8,0,5,0,0,0,8,0,0,0,3,0,0,0,0,2,0,0,0,0,4,1,0,0,0,5,0,0,0,0,0,2,0,0,0,6,1,0,0,0,0,3,0,0,0,0,4,0,0,0,1,0,0,0,6,0,9,0,0,5,0,3,0,0,1,0,4,0,8},
[NUM_SQUARES]BoardValue{5,9,3,4,7,1,8,6,2,7,6,4,8,2,5,3,1,9,8,1,2,9,3,6,5,4,7,2,7,9,3,5,4,1,8,6,3,5,1,7,6,8,9,2,4,4,8,6,1,9,2,7,5,3,9,2,8,5,4,3,6,7,1,1,4,7,6,8,9,2,3,5,6,3,5,2,1,7,4,9,8},
    );
}

test "puzzle1" {
        fulltest(
[NUM_SQUARES]BoardValue{3,0,5,1,0,0,0,8,0,4,1,0,0,2,3,9,0,0,0,0,7,0,0,0,4,0,0,5,0,0,8,3,0,1,0,2,0,0,1,6,0,0,0,0,9,0,0,0,2,0,1,0,4,6,0,0,2,0,0,0,0,0,0,0,7,0,0,9,0,5,2,8,0,5,0,3,0,2,0,9,0},
[NUM_SQUARES]BoardValue{3,9,5,1,6,4,2,8,7,4,1,8,7,2,3,9,6,5,6,2,7,9,8,5,4,1,3,5,4,6,8,3,9,1,7,2,2,8,1,6,4,7,3,5,9,7,3,9,2,5,1,8,4,6,9,6,2,5,1,8,7,3,4,1,7,3,4,9,6,5,2,8,8,5,4,3,7,2,6,9,1},
    );
}

test "empty" {
        fulltest(
[_]BoardValue{0} ** NUM_SQUARES,
[_]BoardValue{0} ** NUM_SQUARES
    );
} 


test "puzzle4" {
        fulltest(
[NUM_SQUARES]BoardValue{5,0,0,0,8,0,0,0,4,3,0,0,1,0,5,0,0,6,0,0,1,0,6,0,2,0,0,0,0,4,2,9,6,7,0,0,9,0,0,7,0,3,0,0,1,0,0,0,0,1,0,0,0,0,0,7,0,0,0,0,0,4,0,1,0,9,0,0,0,5,0,7,4,0,0,0,0,0,0,0,2},
[NUM_SQUARES]BoardValue{5,6,2,9,8,7,3,1,4,3,4,8,1,2,5,9,7,6,7,9,1,3,6,4,2,5,8,8,1,4,2,9,6,7,3,5,9,2,5,7,4,3,6,8,1,6,3,7,5,1,8,4,2,9,2,7,6,8,5,9,1,4,3,1,8,9,4,3,2,5,6,7,4,5,3,6,7,1,8,9,2},
    );    
    
}


test "badinit1" {
    expectError(
  [NUM_SQUARES]BoardValue{5,5,3,0,7,5,0,6,5,7,0,0,8,0,5,0,0,0,8,0,0,0,3,0,0,0,0,2,0,0,0,0,4,1,0,0,0,5,0,0,0,0,0,2,0,0,0,6,1,0,0,0,0,3,0,0,0,0,4,0,0,0,1,0,0,0,6,0,9,0,0,5,0,3,0,0,1,0,4,0,8},
 ); 
}


test "badinit2" {
    expectError(
  [NUM_SQUARES]BoardValue{15,0,3,0,7,5,0,6,5,7,0,0,8,0,5,0,0,0,8,0,0,0,3,0,0,0,0,2,0,0,0,0,4,1,0,0,0,5,0,0,0,0,0,2,0,0,0,6,1,0,0,0,0,3,0,0,0,0,4,0,0,0,1,0,0,0,6,0,9,0,0,5,0,3,0,0,1,0,4,0,8},
 ); 
}

    




