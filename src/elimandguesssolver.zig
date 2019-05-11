// ***********************************************************************
// ***********************************************************************
// PUBLIC
// ***********************************************************************
// ***********************************************************************


// eliminates all invalid insertions
pub fn elimAndGuessSolver(board: [81]u8) ![81]u8 {
    //initialize state
    var state = BoardState{
        .inserts = BoardState.initBoardInserts(),
        .insertOrdering = BoardState.risingNumbers(81),
        .lastActiveIdx = 0,
        .iterationCount = 0,
        .failedGuessCount = 0,
        .isDone = false,
    };

    //insert from sudoku source
    try initFromSource(board, &state);

    //determine candidates
    const maxIter = 250000;
    var iterCount: u32 = 0;

    var keepGoing = true;
    while (keepGoing and (iterCount < maxIter)) : (iterCount += 1) {
        keepGoing = restrictCandidates(&state) catch |err| switch (err) {
            error.ConflictError => blk: {
                try backtrace(&state);
                break :blk false;
            },
        };
        if (!keepGoing) {
            keepGoing = insertBestGuess(&state);
        }

        if (iterCount % 10 == 0) {
            std.debug.warn("Insertions/deletions {}, Numbers placed: {}, Amount of forsaken branches -> {} \n", state.iterationCount, state.lastActiveIdx, state.failedGuessCount);
            //std.debug.warn("Round {}, Numbers placed: {}, Last insert -> {} \n",state.iterationCount, state.lastActiveIdx,state.inserts[state.lastActiveIdx]);
        }
    }
    return state.exportBoard();
}

// ***********************************************************************
// ***********************************************************************
// INTERNAL
// ***********************************************************************
// ***********************************************************************

const std = @import("std");

// represents an insertion of a number
const BoardInsert = struct {
    row: u8, //zero indexed
    col: u8, //zero indexed
    sqr: u8, //zero indexed
    value: u8, // 0 means empty
    candMask: u16,
    candAmount: u8,

    fn init(k: u8) BoardInsert {
        const boardPos = BoardPos.init(k);
        return BoardInsert{
            .row = boardPos.row,
            .col = boardPos.col,
            .sqr = boardPos.sqr,
            .value = 0,
            .candMask = 511,
            .candAmount = 9,
        };
    }

    fn isGuess(self: BoardInsert) bool {
        return self.value != 0 and self.candAmount > 0;
    }

    fn setBacktracked(self: *BoardInsert) void {
        self.value = 0;
        self.candMask = (1 << 9) - 1;
        self.candAmount = 9;
    }

    fn setBacktrackedStartpoint(self: *BoardInsert) void {
        self.value = 0;
    }

    fn setDeterministic(self: *BoardInsert, num: u8) void {
        self.value = num;
        self.candMask = 0;
        self.candAmount = 0;
    }
};

const BoardPos = struct {
    row: u8,
    col: u8,
    sqr: u8,

    fn init(k: u8) BoardPos {
        return BoardPos{
            .row = k / 9,
            .col = k % 9,
            .sqr = 3 * (k / 27) + (k % 9) / 3,
        };
    }
};

const BoardCandidate = struct {
    candMask: u16,
    candAmount: u8,

    fn firstNumberFromMask(self: BoardCandidate) u8 {
        var k: u8 = 0;
        while (k < 16) : (k += 1) {
            if ((self.candMask & (u32(1) << @intCast(u4, k))) != 0) {
                std.debug.assert(k < 10);
                return k;
            }
        }
        unreachable;
    }

    fn popFirstNumberFromMask(self: *BoardCandidate) u8 {
        const has9 = (self.candMask & (1 << 8)) != 0;
        const has8 = (self.candMask & (1 << 7)) != 0;
        const has7 = (self.candMask & (1 << 6)) != 0;
        const has6 = (self.candMask & (1 << 5)) != 0;
        const has5 = (self.candMask & (1 << 4)) != 0;
        const has4 = (self.candMask & (1 << 3)) != 0;
        const has3 = (self.candMask & (1 << 2)) != 0;
        const has2 = (self.candMask & (1 << 1)) != 0;
        const has1 = (self.candMask & (1 << 0)) != 0;

        var out: u8 = 0;
        blk: {
            if (has9) {
                self.candMask &= (~(u16(1) << 8));
                out = 9;
                break :blk;
            }
            if (has8) {
                self.candMask &= (~(u16(1) << 7));
                out = 8;
                break :blk;
            }
            if (has7) {
                self.candMask &= (~(u16(1) << 6));
                out = 7;
                break :blk;
            }
            if (has6) {
                self.candMask &= (~(u16(1) << 5));
                out = 6;
                break :blk;
            }
            if (has5) {
                self.candMask &= (~(u16(1) << 4));
                out = 5;
                break :blk;
            }
            if (has4) {
                self.candMask &= (~(u16(1) << 3));
                out = 4;
                break :blk;
            }
            if (has3) {
                self.candMask &= (~(u16(1) << 2));
                out = 3;
                break :blk;
            }
            if (has2) {
                self.candMask &= (~(u16(1) << 1));
                out = 2;
                break :blk;
            }
            if (has1) {
                self.candMask &= (~(u16(1) << 0));
                out = 1;
                break :blk;
            }
        }

        if (out != 0) {
            self.candAmount -= 1;
            return out;
        }

        return out;
    }
};

const BoardState = struct {
    inserts: [81]BoardInsert,
    insertOrdering: [81]u8,
    lastActiveIdx: u8,

    iterationCount: u32,

    failedGuessCount: u16,

    isDone: bool,

    fn exportBoard(self: BoardState) [81]u8 {
        var out: [81]u8 = undefined;
        for (self.inserts) |bi, k| {
            out[k] = bi.value;
        }
        return out;
    }

    fn initBoard(board: [81]u8) BordState {
        return BoardState{
            .inserts = BoardState.initBoardInserts(),
        };
    }

    fn initBoardInserts() [81]BoardInsert {
        var output: [81]BoardInsert = undefined;
        var k: u8 = 0;
        while (k < 81) : (k += 1) {
            output[k] = BoardInsert.init(k);
        }
        return output;
    }

    fn risingNumbers(comptime last: u8) [last]u8 {
        var k: u8 = 0;
        var out: [last]u8 = undefined;
        while (k < last) : (k += 1) {
            out[k] = u8(k);
        }
        return out;
    }
};

fn initFromSource(board: [81]u8, state: *BoardState) !void {
    var k: u8 = 0;
    while (k < 81) : (k += 1) {
        const value = board[k];
        if (value != 0) {
            try insertFromSource(state, k, value);
        }
    }
}

fn insertFromSource(state: *BoardState, idx: u8, num: u8) !void {
    std.debug.assert(num != 0);

    const srcRow = idx / 9;
    const srcCol = idx % 9;
    const srcSqr = 3 * (idx / 27) + (idx % 9) / 3;

    var k: u8 = 0;
    while (k < state.lastActiveIdx) : (k += 1) {
        const biIdx = state.insertOrdering[k];
        const bi = state.inserts[biIdx];

        std.debug.assert(bi.value != 0);
        std.debug.assert(!(srcRow == bi.row and srcCol == bi.col));

        if (num == bi.value) {
            const conflict = (srcRow == bi.row or srcCol == bi.col or srcSqr == bi.sqr);
            if (conflict) {
                return error.BadSource;
            }
        }
    }

    appendDeterministicInsert(state, idx, num);
}

fn appendInsert(state: *BoardState, idx: u8) void {
    const oldNext = state.insertOrdering[state.lastActiveIdx];

    var k: u8 = state.lastActiveIdx;
    const idxToSwap = while (k < 81) : (k += 1) {
        if (state.insertOrdering[k] == idx) {
            break k;
        }
    } else unreachable;

    state.insertOrdering[state.lastActiveIdx] = idx;
    state.insertOrdering[idxToSwap] = oldNext;
    state.lastActiveIdx += 1;

    state.iterationCount += 1;

    std.debug.assert(state.inserts[idx].value != 0);

    if (oldNext != idx) {
        std.debug.assert(state.inserts[oldNext].value == 0);
    }
}

fn appendDeterministicInsert(state: *BoardState, idx: u8, num: u8) void {
    std.debug.assert(num > 0 and num < 10);

    var bi = &state.inserts[idx];
    bi.setDeterministic(num);

    appendInsert(state, idx);
}

fn appendGuessedInsert(state: *BoardState, idx: u8) void {
    var bi = &state.inserts[idx];
    var boardCandidate = BoardCandidate{
        .candMask = bi.candMask,
        .candAmount = bi.candAmount,
    };

    bi.value = boardCandidate.popFirstNumberFromMask();
    bi.candMask = boardCandidate.candMask;
    bi.candAmount = boardCandidate.candAmount;

    appendInsert(state, idx);
}

fn findCandidatesForPosition(state: *BoardState, idx: u8) BoardCandidate {
    var out = BoardCandidate{
        .candMask = 0,
        .candAmount = 0,
    };
    const boardPos = BoardPos.init(idx);

    var k: u8 = 0;
    while (k < state.lastActiveIdx) : (k += 1) {
        const biIdx = state.insertOrdering[k];
        const bi = state.inserts[biIdx];

        std.debug.assert(bi.value != 0);

        const overlap = (bi.row == boardPos.row or bi.col == boardPos.col or bi.sqr == boardPos.sqr);
        if (overlap) {
            const u4val: u4 = @intCast(u4, bi.value - 1);
            out.candMask |= (u16(1) << u4val);
        }
    }

    out.candMask = (~out.candMask) & 511;

    k = 0;
    while (k < 10) : (k += 1) {
        if ((out.candMask & (u16(1) << @intCast(u4, k))) != 0) {
            out.candAmount += 1;
        }
    }
    std.debug.assert(out.candAmount < 10);

    return out;
}

// restrict possible candidates given current board state
// return true if discovered a new deterministically fitting insert
// false if we'll have to guess or if we're finished
fn restrictCandidates(state: *BoardState) !bool {
    var k: u8 = state.lastActiveIdx;
    while (k < 81) : (k += 1) {
        const biIdx = state.insertOrdering[k];
        const bi = state.inserts[biIdx];
        std.debug.assert(bi.value == 0);

        var candidates = findCandidatesForPosition(state, biIdx);

        if (candidates.candAmount == 0) return error.ConflictError;

        if (candidates.candAmount == 1) {
            const newNum = candidates.popFirstNumberFromMask();

            //a candidate with just ONE option was found, and inserted
            //so we must restart the restriction step
            appendDeterministicInsert(state, biIdx, newNum);

            return true;
        }

        var biRef = &state.inserts[biIdx];
        biRef.candMask = candidates.candMask;
        biRef.candAmount = candidates.candAmount;
    }
    //return false;
    return GroupUtils.groupInserts(state);
}

const GroupUtils = struct {
    fn rowToPositionarray(row: u8) [9]u8 {
        const shift = row * 9;
        return []u8{
            0 + shift, 1 + shift, 2 + shift,
            3 + shift, 4 + shift, 5 + shift,
            6 + shift, 7 + shift, 8 + shift,
        };
    }

    fn colToPositionArray(col: u8) [9]u8 {
        const shift = col;
        return []u8{
            0 + shift,  9 + shift,  18 + shift,
            27 + shift, 36 + shift, 45 + shift,
            54 + shift, 63 + shift, 72 + shift,
        };
    }

    fn rowcolToSquare(row: u8, col: u8) u8 {
        return 3 * (row / 3) + col / 3;
    }

    fn squareToPositionarray(sqr: u8) [9]u8 {
        const colstart: u8 = sqr % 3;
        const rowstart: u8 = sqr / 3;
        const shift = colstart * 3 + rowstart * 27;
        return []u8{
            0 + shift,
            1 + shift,
            2 + shift,
            9 + shift,
            10 + shift,
            11 + shift,
            18 + shift,
            19 + shift,
            20 + shift,
        };
    }

    // Can make deterministic insertion if for a given group G (row/col/square)
    // one of G's missing numbers can only be placed at a single position
    // - return: true if an insertion was found, false if the above is not the case for any group
    fn deduceInsertionPerGroup(state: *BoardState, groupIndices: [9]u8) bool {
        var mask = BoardCandidate{
            .candMask = (1 << 9) - 1,
            .candAmount = 9,
        };

        for (groupIndices) |idx, k| {
            const bi: BoardInsert = state.inserts[idx];
            if (bi.value != 0) {
                mask.candMask &= (~(u16(1) << @intCast(u4, bi.value - 1)));
            }
        }

        var idxToUpdate: u8 = 0;
        var numToCheck = mask.popFirstNumberFromMask();
        while (numToCheck != 0) : (numToCheck = mask.popFirstNumberFromMask()) {
            var candCount: u8 = 0; // times this number is listed as a candidate within this group

            for (groupIndices) |idx, k| {
                const bi: BoardInsert = state.inserts[idx];
                const wantedNumberMask = u16(1) << @intCast(u4, numToCheck - 1);
                if ((bi.candMask & wantedNumberMask) != 0) {
                    candCount += 1;
                    idxToUpdate = idx;
                }
            }

            if (candCount == 1) {
                appendDeterministicInsert(state, idxToUpdate, numToCheck);
                return true;
            }
        }
        return false;
    }

    fn groupInserts(state: *BoardState) bool {
        var grpIdx: u8 = 0;
        while (grpIdx < 9) : (grpIdx += 1) {
            const rowKthIdx = GroupUtils.rowToPositionarray(grpIdx);
            const colKthIdx = GroupUtils.colToPositionArray(grpIdx);
            const sqrKthIdx = GroupUtils.squareToPositionarray(grpIdx);

            if (GroupUtils.deduceInsertionPerGroup(state, rowKthIdx)) return true;
            if (GroupUtils.deduceInsertionPerGroup(state, colKthIdx)) return true;
            if (GroupUtils.deduceInsertionPerGroup(state, sqrKthIdx)) return true;
        }

        return false;
    }
};

fn backtrace(state: *BoardState) !void {
    var k: u8 = state.lastActiveIdx;
    state.failedGuessCount += 1;
    while (k > 0) : (k -= 1) {
        const biIdx = state.insertOrdering[k - 1];
        var bi: *BoardInsert = &state.inserts[biIdx];

        if (bi.isGuess()) {
            bi.setBacktrackedStartpoint();
            break;
        } else {
            bi.setBacktracked();
        }
    }

    if (k == 0) {
        return error.BoardIsInvalid;
    } else {
        const removalCount = state.lastActiveIdx - k;
        state.iterationCount += removalCount;
        state.lastActiveIdx = k - 1;
    }
}

fn insertBestGuess(state: *BoardState) bool {
    var bestCandidateForGuess: u8 = undefined;
    var minSoFar: u8 = 255;

    var k: u8 = state.lastActiveIdx;
    while (k < 81) : (k += 1) {
        const biIdx = state.insertOrdering[k];
        const bi = state.inserts[biIdx];
        if (bi.candAmount < minSoFar) {
            bestCandidateForGuess = biIdx;
            minSoFar = bi.candAmount;
        }
    }
    if (minSoFar == 255) return false;

    appendGuessedInsert(state, bestCandidateForGuess);

    return true;
}
