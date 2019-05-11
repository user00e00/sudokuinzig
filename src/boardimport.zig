const std = @import("std");
const warn = @import("std").debug.warn;

const openRead = @import("std").os.File.openRead;

pub fn import(filename: []const u8) anyerror![81]u8 {
    const hnd = try openRead(filename);
    defer hnd.close();

    var linebuf: [1]u8 = undefined;

    var board: [81]u8 = []u8{0} ** 81;

    var i: usize = 0;
    var k: usize = 0;

    while (i < 4000) : (i += 1) {
        const expr = try hnd.read(linebuf[0..]);
        const val = charToDigit(linebuf[0], u8(0));
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
        '.' => u8(0),
        '0'...'9' => c - '0',
        else => return u8(255),
    };
}
