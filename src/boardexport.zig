const std = @import("std");
const warn = @import("std").debug.warn;
const io = @import("std").io;
const os = std.os;

const openWrite = @import("std").os.File.openWrite;

var outBuffer: [242]u8 = " " ** 242;

pub fn exportboard(filename: []const u8, board: [81]u8) !void {
    const hnd = try openWrite(filename);
    defer hnd.close();

    const toWrite = boardToText(board);
    const result = try hnd.write(toWrite);
}

fn boardToText(board: [81]u8) []const u8 {
    var row: usize = 0;
    var srcIdx: usize = 0;
    var outIdx: usize = 0;
    while (row < 9) : (row += 1) {
        var col: usize = 0;
        while (col < 21) : (col += 1) {
            if (col == 6 or col == 14) {
                outBuffer[outIdx] = '|';
            } else if (col % 2 == 1) {
                //outBuffer[outIdx] = ' ';
            } else {
                const nextNum = digitToCharCustom(board[srcIdx], false);
                outBuffer[outIdx] = nextNum;
                srcIdx += 1;
            }
            outIdx += 1;
        }
        if (row != 9) {
            outBuffer[outIdx] = '\n';
            outIdx += 1;
        }
        if (row == 2 or row == 5) {
            const separator = "------+------+------\n";
            var col2: usize = 0;
            while (col2 < 21) {
                outBuffer[outIdx] = separator[col2];
                col2 += 1;
                outIdx += 1;
            }
        }
    }
    return outBuffer[0..outIdx];
}

fn digitToCharCustom(digit: u8, uppercase: bool) u8 {
    return switch (digit) {
        0 => '.',
        1...9 => digit + '0',
        10...35 => digit + ((if (uppercase) u8('A') else u8('a')) - 10),
        else => unreachable,
    };
}
