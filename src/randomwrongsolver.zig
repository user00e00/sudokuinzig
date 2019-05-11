// for testing

const rand = @import("std").rand;

var prng = @import("std").rand.DefaultPrng.init(24);

pub fn randomWrongSolver(board: [81]u8) [81]u8 {
    var out: [81]u8 = board;
    for (out) |val, k| {
        //expect(r.random.uintLessThan(u8, 4) == 3);
        if (out[k] == 0) {
            out[k] = prng.random.uintLessThan(u8, 9) + 1;
        }
        //board[k] = rand.Random.int(rand.DefaultPrng,5);
    }
    out[3] = 4;
    return out;
}
