const std = @import("std");
usingnamespace @import("constants.zig");
const solver = @import("solver1/solver1.zig").solve;

fn charArrayLen81ToPuzzle(charArray: []const u8) [NUM_SQUARES]BoardValue {
    var out: [NUM_SQUARES]BoardValue = [_]BoardValue{0} ** NUM_SQUARES;
    var k: usize = 0;
    while (k < charArray.len) : (k += 1) {
        const mustTruncate = @bitSizeOf(u8) > @bitSizeOf(BoardValue);
        const numCasted = switch(mustTruncate){
            true => @truncate(BoardValue,charToDigitDecimal(charArray[k])),
            else => @intCast(BoardValue,charToDigitDecimal(charArray[k])),
        };
        out[k] = numCasted;
    }
    return out;
}

fn charToDigitDecimal(c: u8) u8 {
    const numVal : u8 = switch (c) {
        '.' => 0,
        '0'...'9' => c - '0',
        else => 255,
    };
    return numVal;

}



fn fulltestExact(puzzle: [NUM_SQUARES]BoardValue, solution: [NUM_SQUARES]BoardValue) void {
    const result = solver(puzzle);
    std.testing.expectEqual(SudokuResultStatus.SOLVED, result.resultStatus);
    std.testing.expectEqual(solution, result.boardValues);
    return;
}

fn fulltest(puzzle: [NUM_SQUARES]BoardValue, solution: [NUM_SQUARES]BoardValue) void {
    const result = solver(puzzle);
    std.testing.expectEqual(SudokuResultStatus.SOLVED, result.resultStatus);
    return;
}


test "verify correct configuration" {
    // only allow these tests when configuration is set to 9x9 sudoku puzzles
    std.testing.expectEqual(9, NUM_SIDE);
}


test "#1 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("4.....8.5.3..........7......2.....6.....8.4......1.......6.3.7.5..2.....1.4......"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#2 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("52...6.........7.13...........4..8..6......5...........418.........3..2...87....."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#3 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("6.....8.3.4.7.................5.4.7.3..2.....1.6.......2.....5.....8.6......1...."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#4 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("48.3............71.2.......7.5....6....2..8.............1.76...3.....4......5...."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#5 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("....14....3....2...7..........9...3.6.1.............8.2.....1.4....5.6.....7.8..."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#6 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("......52..8.4......3...9...5.1...6..2..7........3.....6...1..........7.4.......3."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#7 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("6.2.5.........3.4..........43...8....1....2........7..5..27...........81...6....."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#8 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".524.........7.1..............8.2...3.....6...9.5.....1.6.3...........897........"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#9 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("6.2.5.........4.3..........43...8....1....2........7..5..27...........81...6....."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#10 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".923.........8.1...........1.7.4...........658.........6.5.2...4.....7.....9....."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#11 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("6..3.2....5.....1..........7.26............543.........8.15........4.2........7.."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#12 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".6.5.1.9.1...9..539....7....4.8...7.......5.8.817.5.3.....5.2............76..8..."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#13 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("..5...987.4..5...1..7......2...48....9.1.....6..2.....3..6..2.......9.7.......5.."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#14 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("3.6.7...........518.........1.4.5...7.....6.....2......2.....4.....8.3.....5....."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#15 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("1.....3.8.7.4..............2.3.1...........958.........5.6...7.....8.2...4......."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#16 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("6..3.2....4.....1..........7.26............543.........8.15........4.2........7.."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#17 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("....3..9....2....1.5.9..............1.2.8.4.6.8.5...2..75......4.1..6..3.....4.6."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#18 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("45.....3....8.1....9...........5..9.2..7.....8.........1..4..........7.2...6..8.."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#19 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".237....68...6.59.9.....7......4.97.3.7.96..2.........5..47.........2....8......."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#20 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("..84...3....3.....9....157479...8........7..514.....2...9.6...2.5....4......9..56"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#21 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".98.1....2......6.............3.2.5..84.........6.........4.8.93..5...........1.."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#22 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("..247..58..............1.4.....2...9528.9.4....9...1.........3.3....75..685..2..."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#23 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("4.....8.5.3..........7......2.....6.....5.4......1.......6.3.7.5..2.....1.9......"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#24 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".2.3......63.....58.......15....9.3....7........1....8.879..26......6.7...6..7..4"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#25 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("1.....7.9.4...72..8.........7..1..6.3.......5.6..4..2.........8..53...7.7.2....46"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#26 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("4.....3.....8.2......7........1...8734.......6........5...6........1.4...82......"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#27 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".......71.2.8........4.3...7...6..5....2..3..9........6...7.....8....4......5...."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#28 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("6..3.2....4.....8..........7.26............543.........8.15........8.2........7.."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#29 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".47.8...1............6..7..6....357......5....1..6....28..4.....9.1...4.....2.69."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#30 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("......8.17..2........5.6......7...5..1....3...8.......5......2..4..8....6...3...."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#31 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("38.6.......9.......2..3.51......5....3..1..6....4......17.5..8.......9.......7.32"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#32 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("...5...........5.697.....2...48.2...25.1...3..8..3.........4.7..13.5..9..2...31.."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#33 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".2.......3.5.62..9.68...3...5..........64.8.2..47..9....3.....1.....6...17.43...."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#34 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".8..4....3......1........2...5...4.69..1..8..2...........3.9....6....5.....2....."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#35 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("..8.9.1...6.5...2......6....3.1.7.5.........9..4...3...5....2...7...3.8.2..7....4"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#36 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("4.....5.8.3..........7......2.....6.....5.8......1.......6.3.7.5..2.....1.8......"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#37 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("1.....3.8.6.4..............2.3.1...........958.........5.6...7.....8.2...4......."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#38 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("1....6.8..64..........4...7....9.6...7.4..5..5...7.1...5....32.3....8...4........"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#39 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("249.6...3.3....2..8.......5.....6......2......1..4.82..9.5..7....4.....1.7...3..."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#40 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("...8....9.873...4.6..7.......85..97...........43..75.......3....3...145.4....2..1"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#41 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("...5.1....9....8...6.......4.1..........7..9........3.8.....1.5...2..4.....36...."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#42 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("......8.16..2........7.5......6...2..1....3...8.......2......7..3..8....5...4...."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#43 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".476...5.8.3.....2.....9......8.5..6...1.....6.24......78...51...6....4..9...4..7"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#44 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".....7.95.....1...86..2.....2..73..85......6...3..49..3.5...41724................"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#45 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".4.5.....8...9..3..76.2.....146..........9..7.....36....1..4.5..6......3..71..2.."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#46 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".834.........7..5...........4.1.8..........27...3.....2.6.5....5.....8........1.."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#47 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("..9.....3.....9...7.....5.6..65..4.....3......28......3..75.6..6...........12.3.8"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#48 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".26.39......6....19.....7.......4..9.5....2....85.....3..2..9..4....762.........4"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#49 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("2.3.8....8..7...........1...6.5.7...4......3....1............82.5....6...1......."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#50 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("6..3.2....1.....5..........7.26............843.........8.15........8.2........7.."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#51 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("1.....9...64..1.7..7..4.......3.....3.89..5....7....2.....6.7.9.....4.1....129.3."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#52 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".........9......84.623...5....6...453...1...6...9...7....1.....4.5..2....3.8....9"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#53 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".2....5938..5..46.94..6...8..2.3.....6..8.73.7..2.........4.38..7....6..........5"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#54 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("9.4..5...25.6..1..31......8.7...9...4..26......147....7.......2...3..8.6.4.....9."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#55 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("...52.....9...3..4......7...1.....4..8..453..6...1...87.2........8....32.4..8..1."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#56 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("53..2.9...24.3..5...9..........1.827...7.........981.............64....91.2.5.43."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#57 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("1....786...7..8.1.8..2....9........24...1......9..5...6.8..........5.9.......93.4"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#58 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("....5...11......7..6.....8......4.....9.1.3.....596.2..8..62..7..7......3.5.7.2.."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#59 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".47.2....8....1....3....9.2.....5...6..81..5.....4.....7....3.4...9...1.4..27.8.."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#60 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("......94.....9...53....5.7..8.4..1..463...........7.8.8..7.....7......28.5.26...."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#61 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".2......6....41.....78....1......7....37.....6..412....1..74..5..8.5..7......39.."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#62 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("1.....3.8.6.4..............2.3.1...........758.........7.5...6.....8.2...4......."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#63 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("2....1.9..1..3.7..9..8...2.......85..6.4.........7...3.2.3...6....5.....1.9...2.5"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#64 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("..7..8.....6.2.3...3......9.1..5..6.....1.....7.9....2........4.83..4...26....51."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#65 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("...36....85.......9.4..8........68.........17..9..45...1.5...6.4....9..2.....3..."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#66 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("34.6.......7.......2..8.57......5....7..1..2....4......36.2..1.......9.......7.82"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#67 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("......4.18..2........6.7......8...6..4....3...1.......6......2..5..1....7...3...."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#68 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".4..5..67...1...4....2.....1..8..3........2...6...........4..5.3.....8..2........"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#69 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".......4...2..4..1.7..5..9...3..7....4..6....6..1..8...2....1..85.9...6.....8...3"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#70 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("8..7....4.5....6............3.97...8....43..5....2.9....6......2...6...7.71..83.2"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#71 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".8...4.5....7..3............1..85...6.....2......4....3.26............417........"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#72 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("....7..8...6...5...2...3.61.1...7..2..8..534.2..9.......2......58...6.3.4...1...."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#73 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("......8.16..2........7.5......6...2..1....3...8.......2......7..4..8....5...3...."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#74 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".2..........6....3.74.8.........3..2.8..4..1.6..5.........1.78.5....9..........4."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#75 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".52..68.......7.2.......6....48..9..2..41......1.....8..61..38.....9...63..6..1.9"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#76 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("....1.78.5....9..........4..2..........6....3.74.8.........3..2.8..4..1.6..5....."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#77 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("1.......3.6.3..7...7...5..121.7...9...7........8.1..2....8.64....9.2..6....4....."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#78 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("4...7.1....19.46.5.....1......7....2..2.3....847..6....14...8.6.2....3..6...9...."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#79 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("......8.17..2........5.6......7...5..1....3...8.......5......2..3..8....6...4...."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#80 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("963......1....8......2.5....4.8......1....7......3..257......3...9.2.4.7......9.."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#81 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("15.3......7..4.2....4.72.....8.........9..1.8.1..8.79......38...........6....7423"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#82 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("..........5724...98....947...9..3...5..9..12...3.1.9...6....25....56.....7......6"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#83 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("....75....1..2.....4...3...5.....3.2...8...1.......6.....1..48.2........7........"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#84 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("6.....7.3.4.8.................5.4.8.7..2.....1.3.......2.....5.....7.9......1...."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#85 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("....6...4..6.3....1..4..5.77.....8.5...8.....6.8....9...2.9....4....32....97..1.."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#86 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".32.....58..3.....9.428...1...4...39...6...5.....1.....2...67.8.....4....95....6."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#87 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("...5.3.......6.7..5.8....1636..2.......4.1.......3...567....2.8..4.7.......2..5.."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#88 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".5.3.7.4.1.........3.......5.8.3.61....8..5.9.6..1........4...6...6927....2...9.."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#89 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("..5..8..18......9.......78....4.....64....9......53..2.6.........138..5....9.714."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#90 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("..........72.6.1....51...82.8...13..4.........37.9..1.....238..5.4..9.........79."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#91 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("...658.....4......12............96.7...3..5....2.8...3..19..8..3.6.....4....473.."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#92 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".2.3.......6..8.9.83.5........2...8.7.9..5........6..4.......1...1...4.22..7..8.9"),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#93 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".5..9....1.....6.....3.8.....8.4...9514.......3....2..........4.8...6..77..15..6."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#94 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle(".....2.......7...17..3...9.8..7......2.89.6...13..6....9..5.824.....891.........."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
test "#95 hard puzzles from magictour.free.fr/top95" {
    fulltest(
        charArrayLen81ToPuzzle("3...8.......7....51..............36...2..4....7...........6.13..452...........8.."),
        [_]BoardValue{0} ** NUM_SQUARES,
    );
}
