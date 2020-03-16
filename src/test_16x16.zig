const std = @import("std");
usingnamespace @import("constants.zig");
const solver = @import("solver1/solver1.zig").solve;


fn charArrayLen256ToPuzzle(charArray: []const u8) [256]BoardValue {
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
        'a' => @as(u8,10),
        'b' => @as(u8,11),
        'c' => @as(u8,12),
        'd' => @as(u8,13),
        'e' => @as(u8,14),
        'f' => @as(u8,15),
        'g' => @as(u8,16),
        else => return @as(u8, 255),
    };
}


fn fulltest(puzzle: [256]BoardValue) void {
    const result = solver(puzzle);
    std.testing.expectEqual(SudokuResultStatus.SOLVED, result.resultStatus);
    return;
}

test "supersudoku 1" {
    fulltest(
        charArrayLen256ToPuzzle(
    "1..234..c.6...7."
++ "..8...7..3..9a6b"
++ ".c..a..1.d.b..e."
++ "3..f2..e...9..c."
++ "d...8..a.c2.1f.."
++ ".b76...g...f..5d"
++ "...a.5f..4.8..b."
++ "g..59c..1.....8."
++ ".2.....d..c58..3"
++ ".d..f.3..e8.g..."
++ "58..1...2...d9f."
++ "..c4.6g.d..7...5"
++ ".3..c...6..4b..g"
++ ".7..g.5.e..1..2."
++ "b1f9..d..2...e.."
++ ".e...b.2..d35..c"
));
}


test "supersudoku 2" {
    fulltest(
        charArrayLen256ToPuzzle(
    "1..234..c.6...7."
++ "..8...7..3..9a6b"
++ ".c..a..1.d.b..e."
++ "3..f2..e...9..c."
++ "d...8..a.c2....."
++ ".b76...g...f..5d"
++ "...a.5f..4.8..b."
++ "g..59c..1.....8."
++ ".......d....8..3"
++ ".d..f.3..e8.g..."
++ "58..1...2...d9f."
++ "..c4....d..7...5"
++ ".3..c...6..4b..g"
++ ".7..g.5.e..1..2."
++ "b1f9..d..2...e.."
++ ".e...b.2..d35..c"
));
}



