const std = @import("std");
usingnamespace @import("../constants.zig");
//usingnamespace @import("constants.zig");

const BoardIndex = u8;
const GroupIndex = u8;
const SequenceIndex = BoardIndex;
const Mask = u16;

const enableDebugPrint = false;
const enableHeuristics = true;

const SolverResult = enum {
    NEED_BRANCH,
    NEED_RESTRICT,
    NEED_HEURISTIC,
    COMPLETED,
    FAILED_BRANCH,
    FAILED_BOARD,
    UNSOLVABLE_BOARD,

    fn toStatus(self: SolverResult) SudokuResultStatus {
        return switch (self) {
            .COMPLETED => SudokuResultStatus.SOLVED,
            .UNSOLVABLE_BOARD => SudokuResultStatus.NOT_SOLVABLE,
            .FAILED_BOARD => SudokuResultStatus.BAD_INITIAL_BOARD,
            else => SudokuResultStatus.MAXITER_REACHED,
        };
    }
};

pub fn solve(board: [NUM_SQUARES]BoardValue) SudokuResult {
    var bs = SolverBoard{};
    var seq = SolverSequence{};

    const solver = &SudokuSolver{ .b = &bs, .seq = &seq };

    var res = solver.initFromArray(board);
    var iterCount: usize = 0;
    while (iterCount < 40000) : (iterCount += 1) {
        switch (res) {
            .COMPLETED => {
                custom_debug.debugPrintArray(BoardValue, solver.getBoard()[0..]);
                break;
            },
            .NEED_RESTRICT => {
                res = solver.restrict();
                std.debug.assert(res != SolverResult.NEED_RESTRICT);
            },
            .NEED_HEURISTIC => {
                if (enableHeuristics) {
                    const changed = solver.heuristicRestrictByGroupAll();
                    if (changed) {
                        res = SolverResult.NEED_RESTRICT;
                    } else {
                        res = SolverResult.NEED_BRANCH;
                    }
                } else {
                    res = SolverResult.NEED_BRANCH;
                }
            },
            .NEED_BRANCH => {
                solver.startBranchFromMinCandidate();
                res = .NEED_RESTRICT;
            },
            .FAILED_BRANCH => {
                res = solver.backtrack();
            },
            else => {
                custom_debug.debugPrintArray(BoardValue, solver.getBoard()[0..]);
                break;
            },
        }
        custom_debug.debugMsgF("current res: {}\n", .{res});
        if (!(res == .FAILED_BOARD)) {}
    }
    const out = SudokuResult{ .boardValues = solver.getBoard(), .resultStatus = res.toStatus() };
    return out;
}

const custom_debug = struct {
    fn debugPrintArray(comptime T: type, arr: []const T) void {
        if (!enableDebugPrint) return;
        var k: u8 = 0;
        while (k < arr.len) : (k += 1) {
            std.debug.warn("{} ", .{arr[k]});
        }
        std.debug.warn("\n", .{});
    }

    fn debugMsg(comptime msg: []const u8) void {
        debugMsgF(msg, .{});
    }

    fn debugMsgF(comptime msg: []const u8, context: var) void {
        if (!enableDebugPrint) return;
        std.debug.warn(msg, context);
    }

    fn debugPrintBoard(prompt: RawString, board: [NUM_SQUARES]BoardValue) void {
        if (!enableDebugPrint) return;
        std.debug.assert(NUM_SQUARES == 81);
        std.debug.warn("{}", .{prompt[0..]});
        var i: usize = 0;
        while (i < 81) : (i += 1) {
            if (i == 0) {
                //do nothing
            } else if (i % 27 == 0) {
                std.debug.warn("\n------+------+------\n", .{});
            } else if (i % 9 == 0) {
                std.debug.warn("\n", .{});
            } else if (i % 3 == 0 and i != 0) {
                std.debug.warn("| ", .{});
            }
            if (board[i] == 0) {
                std.debug.warn(". ", .{});
            } else {
                std.debug.warn("{} ", .{board[i]});
            }
        }
        std.debug.warn("\n", .{});
    }
};

const GroupUtils = struct {
    const NUM_ARRAY = risingNumbers(GroupIndex, NUM_SIDE);

    fn rowGroupIndices(grpIdx: GroupIndex) [NUM_SIDE]GroupIndex {
        var out: [NUM_SIDE]GroupIndex = NUM_ARRAY;
        var k: GroupIndex = 0;
        while (k < out.len) : (k += 1) {
            out[k] = out[k] + NUM_SIDE * grpIdx;
        }
        return out;
    }

    fn colGroupIndices(grpIdx: GroupIndex) [NUM_SIDE]GroupIndex {
        var out: [NUM_SIDE]GroupIndex = NUM_ARRAY;
        var k: GroupIndex = 0;
        while (k < out.len) : (k += 1) {
            out[k] = NUM_SIDE * out[k] + grpIdx;
        }
        return out;
    }

    fn boxGroupIndices(grpIdx: GroupIndex) [NUM_SIDE]GroupIndex {
        var out: [NUM_SIDE]GroupIndex = NUM_ARRAY;
        var k: GroupIndex = 0;
        while (k < out.len) : (k += 1) {
            const boxBase = NUM_SIDE * (out[k] / NUM_BOX) + out[k] % NUM_BOX;
            out[k] = boxBase + ((NUM_BOX * grpIdx) % NUM_SIDE) + NUM_SIDE * NUM_BOX * (grpIdx / NUM_BOX);
        }
        return out;
    }
};

const BoardPos = struct {
    row: GroupIndex,
    col: GroupIndex,
    box: GroupIndex,

    fn init(idx: BoardIndex) BoardPos {
        //assertToggled(AssertThreshold.LOW, idx >= 0 and idx < NUM_SQUARES);
        return BoardPos{
            .row = idx / NUM_SIDE,
            .col = idx % NUM_SIDE,
            .box = NUM_BOX * (idx / (NUM_SIDE * NUM_BOX)) + (idx % NUM_SIDE) / NUM_BOX,
        };
    }

    fn initBoard() [NUM_SQUARES]BoardPos {
        var out: [NUM_SQUARES]BoardPos = undefined;
        var k: u8 = 0;
        while (k < NUM_SQUARES) : (k += 1) {
            out[k] = BoardPos.init(k);
        }
        return out;
    }

    fn doesConflictWith(self: BoardPos, other: BoardPos) bool {
        return (self.row == other.row) or (self.col == other.col) or (self.box == other.box);
    }
};

const BOARD_MAP: [NUM_SQUARES]BoardPos = BoardPos.initBoard();
const MASK_MAP: [NUM_SIDE + 1]Mask = if (NUM_SIDE == 9) [_]Mask{ 0, 1, 2, 4, 8, 16, 32, 64, 128, 256 } else if (NUM_SIDE == 16) [_]Mask{ 0, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768 } else unreachable;

const MASK_COVER: Mask = (1 << NUM_SIDE) - 1;
const MASK_EMPTY: Mask = 0;

fn maskToBoardValue(mask: Mask) BoardValue {
    std.debug.assert(@popCount(Mask, mask) == 1);
    var cMask: Mask = 1 << NUM_SIDE - 1;
    var k: BoardValue = NUM_SIDE;
    while (k != 0) {
        if (cMask == mask) {
            return k;
        }
        cMask = cMask >> 1;
        k -= 1;
    }
    unreachable;
}

fn popFirstFromMask(mask: Mask) BoardValue {
    std.debug.assert(@popCount(Mask, mask) != 0);
    var k: u8 = 9;
    while (k > 0) : (k -= 1) {
        const testMask = MASK_MAP[k];
        if (testMask & mask != 0) return k;
    }
    unreachable;
}

fn risingNumbers(comptime T: type, comptime N: u32) [N]T {
    var out: [N]T = undefined;
    var k: T = 0;
    while (k < N) : (k += 1) {
        out[k] = k;
    }
    return out;
}

const SolverBoard = struct {
    _boardValues: [NUM_SQUARES]BoardValue = [_]BoardValue{0} ** NUM_SQUARES,

    // bits correspond to values that are _in use_ within a group
    rowMasks: [NUM_SIDE]Mask = [_]Mask{0} ** NUM_SIDE,
    colMasks: [NUM_SIDE]Mask = [_]Mask{0} ** NUM_SIDE,
    boxMasks: [NUM_SIDE]Mask = [_]Mask{0} ** NUM_SIDE,

    fn getMask(self: @This(), index: BoardIndex) Mask {
        const boardPos = BOARD_MAP[index];
        return self.rowMasks[boardPos.row] | self.colMasks[boardPos.col] | self.boxMasks[boardPos.box];
    }

    fn insertValueFromMask(self: *@This(), index: BoardIndex, candMask: Mask) bool {
        const boardValue = maskToBoardValue(candMask);
        return self.insertValue(index, boardValue);
    }

    inline fn getValueAt(self: @This(), index: BoardIndex) BoardValue {
        return self._boardValues[index];
    }

    inline fn isInUse(self: @This(), index: BoardIndex) bool {
        return self._boardValues[index] != 0;
    }

    fn insertValue(self: *@This(), index: BoardIndex, value: BoardValue) bool {
        std.debug.assert(self._boardValues[index] == 0);
        const valueMask = MASK_MAP[value];
        const rowMask = &self.rowMasks[BOARD_MAP[index].row];
        const colMask = &self.colMasks[BOARD_MAP[index].col];
        const boxMask = &self.boxMasks[BOARD_MAP[index].box];

        const conflictDetected = ((valueMask & rowMask.*) != 0) or ((valueMask & colMask.*) != 0) or ((valueMask & boxMask.*) != 0);

        if (conflictDetected) {
            return false;
        } else {
            rowMask.* |= valueMask;
            colMask.* |= valueMask;
            boxMask.* |= valueMask;
            self._boardValues[index] = value;
            return true;
        }
    }

    fn removeValues(self: *@This(), indices: []const BoardIndex) bool {
        var k: u8 = 0;
        while (k < indices.len) : (k += 1) {
            const index = indices[k];
            std.debug.assert(self._boardValues[index] != 0);
            const oldValue = self._boardValues[index];
            if (oldValue == 0) {
                unreachable;
            } else {
                const oldValueMask = MASK_MAP[oldValue];

                const rowMask = &self.rowMasks[BOARD_MAP[index].row];
                const colMask = &self.colMasks[BOARD_MAP[index].col];
                const boxMask = &self.boxMasks[BOARD_MAP[index].box];

                rowMask.* &= ~oldValueMask;
                colMask.* &= ~oldValueMask;
                boxMask.* &= ~oldValueMask;

                self._boardValues[index] = 0;
            }
            std.debug.assert(self._boardValues[index] == 0);
        }
        return true;
    }

    fn reset(self: *@This()) void {
        self._boardValues = [_]BoardValue{0} ** NUM_SQUARES;
        self.rowMasks = [_]Mask{0} ** NUM_SIDE;
        self.colMasks = [_]Mask{0} ** NUM_SIDE;
        self.boxMasks = [_]Mask{0} ** NUM_SIDE;
    }
};

const SolverSequence = struct {
    insertSequence: [NUM_SQUARES]BoardIndex = risingNumbers(BoardIndex, NUM_SQUARES),
    insertPivot: SequenceIndex = 0,

    fn appendInsert(self: *@This(), index: BoardIndex) void {
        const indexInsertPos = self.getPositionInInsertSequence(index);
        std.debug.assert(indexInsertPos >= self.insertPivot);

        const prevPivotIndex = self.insertSequence[self.insertPivot];
        //@breakpoint();
        self.insertSequence[self.insertPivot] = index;

        const overlappingIndices = (self.insertPivot == indexInsertPos);
        if (!overlappingIndices) {
            self.insertSequence[indexInsertPos] = prevPivotIndex;
        }
        self.insertPivot += 1;
    }

    fn getPositionInInsertSequence(self: @This(), index: BoardIndex) BoardIndex {
        var k: u8 = 0;
        while (k < NUM_SQUARES) : (k += 1) {
            const compareIdx = self.insertSequence[k];
            if (compareIdx == index) {
                return k;
            }
        }
        unreachable;
    }

    inline fn getIndexAtPosition(self: @This(), pos: SequenceIndex) BoardIndex {
        return self.insertSequence[pos];
    }

    inline fn isPivotAtEnd(self: @This()) bool {
        return self.insertPivot == NUM_SQUARES;
    }

    inline fn getPivotIndex(self: @This()) BoardIndex {
        return self.insertSequence[self.insertPivot];
    }

    inline fn getPivot(self: @This()) SequenceIndex {
        return self.insertPivot;
    }

    inline fn setBacktrackedPivot(self: *@This(), newPos: SequenceIndex) []const BoardIndex {
        std.debug.assert(newPos < self.insertPivot);
        const oldPivot = self.insertPivot;
        self.insertPivot = newPos;
        return self.insertSequence[newPos..oldPivot];
    }

    fn reset(self: *@This()) void {
        self.insertSequence = risingNumbers(NUM_SQUARES);
        self.insertPivot = 0;
    }
};

const SudokuSolver = struct {
    b: *SolverBoard,
    seq: *SolverSequence,
    candidateMasksByIndex: [NUM_SQUARES]Mask = [_]Mask{MASK_COVER} ** NUM_SQUARES,

    fn getBoard(self: @This()) [NUM_SQUARES]BoardValue {
        return self.b._boardValues;
    }

    fn getMinCandidateIndex(self: @This()) BoardIndex {
        var min: u8 = NUM_SIDE + 1;
        var k: u8 = self.seq.getPivot();
        const INVALID_IDX = NUM_SQUARES;
        var out: BoardIndex = INVALID_IDX;
        while (k < NUM_SQUARES) : (k += 1) {
            const idx = self.seq.getIndexAtPosition(k);
            const mask = self.b.getMask(idx);
            const candMask = MASK_COVER & (~mask);
            const candCount = @popCount(Mask, candMask);
            if (candCount < min) {
                out = idx;
                min = candCount;
            }
        }
        if (min == (NUM_SIDE + 1)) {
            unreachable;
        }
        return out;
    }

    /// return null if we reached the global root
    fn getSequencePosOfCurrentBranchRoot(self: @This()) ?SequenceIndex {
        var k: u8 = self.seq.getPivot();
        while (k > 0) {
            k -= 1;
            const idx = self.seq.getIndexAtPosition(k);
            const candMask = self.candidateMasksByIndex[idx];
            if (candMask != MASK_EMPTY) {
                return k;
            }
        }
        return null;
    }

    fn restrict(self: *@This()) SolverResult {
        custom_debug.debugMsg("# Restricting\n");
        var k: u8 = self.seq.getPivot();
        while (k < NUM_SQUARES) {
            const idx = self.seq.getIndexAtPosition(k);
            const mask = self.b.getMask(idx);
            const candMask = MASK_COVER & (~mask);
            const candCount = @popCount(Mask, candMask);
            switch (candCount) {
                0 => {
                    return SolverResult.FAILED_BRANCH;
                },
                1 => {
                    const changed = self.b.insertValueFromMask(idx, candMask);
                    if (!changed) {
                        unreachable;
                    }
                    self.seq.appendInsert(idx);
                    self.candidateMasksByIndex[idx] = MASK_EMPTY;
                    k = self.seq.getPivot();
                },
                else => {
                    self.candidateMasksByIndex[idx] = candMask;
                    k += 1;
                },
            }
        }
        if (self.seq.isPivotAtEnd()) {
            return SolverResult.COMPLETED;
        } else {
            return SolverResult.NEED_HEURISTIC;
        }
    }

    fn restrictByGroup(self: *@This(), grp: [NUM_SIDE]BoardIndex) bool {
        const grpSingleMask = self.getSingleUsageMaskInGroup(grp);
        if (grpSingleMask != MASK_EMPTY) {
            var out = false;
            var k: GroupIndex = 0;
            while (k < NUM_SIDE) : (k += 1) {
                const idx = grp[k];
                if (self.b.getValueAt(idx) != 0) continue;
                const currentCandidateMask = self.candidateMasksByIndex[idx];
                const isect: Mask = (grpSingleMask & currentCandidateMask);
                if (isect != MASK_EMPTY) {
                    const isSingleCandidate = @popCount(Mask, isect) == 1;
                    if (isSingleCandidate) {
                        self.appendToBranchByMask(idx, isect);
                        out = true;
                    } else {
                        self.candidateMasksByIndex[idx] = isect;
                    }

                }
            }
            return out;
        }
        return false;
    }

    fn heuristicRestrictByGroupAll(self: *@This()) bool {
        var gIdx: GroupIndex = 0;
        var grpType: u2 = 0; //0 = box, 1 = row, 2 = col
        while (gIdx < NUM_SIDE and grpType < 3) {
            const grp = switch (grpType) {
                0 => GroupUtils.boxGroupIndices(gIdx),
                1 => GroupUtils.rowGroupIndices(gIdx),
                2 => GroupUtils.colGroupIndices(gIdx),
                else => unreachable,
            };
            const res = self.restrictByGroup(grp);
            if (res) {
                return true;
            }
            if (gIdx == NUM_SIDE - 1) {
                gIdx = 0;
                grpType += 1;
            } else {
                gIdx += 1;
            }
        }
        return false;
    }

    fn getSingleUsageMaskInGroup(self: @This(), groupIndices: [NUM_SIDE]BoardIndex) Mask {
        var k: GroupIndex = 0;
        var foundOneMask: Mask = 0;
        var foundTwoMask: Mask = 0;
        while (k < NUM_SIDE) : (k += 1) {
            const idx = groupIndices[k];
            const shouldIncludeMask = if (self.b.isInUse(idx)) MASK_EMPTY else MASK_COVER;
            const currentCandidateMask = self.candidateMasksByIndex[idx] & shouldIncludeMask;
            foundTwoMask = foundTwoMask | (foundOneMask & currentCandidateMask);
            foundOneMask = foundOneMask | currentCandidateMask;
        }
        return foundOneMask & (~foundTwoMask);
    }

    fn initFromArray(self: *@This(), board: [NUM_SQUARES]BoardValue) SolverResult {
        self.b.reset();
        var k: u8 = 0;
        while (k < board.len) : (k += 1) {
            if (board[k] > NUM_SIDE) {
                return SolverResult.FAILED_BOARD;
            }
            if (board[k] == 0) continue;
            const changed = self.b.insertValue(k, board[k]);
            if (!changed) {
                return SolverResult.FAILED_BOARD;
            }
            self.candidateMasksByIndex[k] = MASK_EMPTY;
            self.seq.appendInsert(k);
        }
        return SolverResult.NEED_RESTRICT;
    }

    fn startBranch(self: *@This(), minIdx: BoardIndex, value: BoardValue, altCandidatesMask: Mask) void {
        std.debug.assert(!self.b.isInUse(minIdx));
        std.debug.assert((MASK_MAP[value] & altCandidatesMask) == MASK_EMPTY);
        std.debug.assert(@popCount(Mask, altCandidatesMask) != 0);
        const changed = self.b.insertValue(minIdx, value);
        if (!changed) {
            unreachable;
        }
        self.seq.appendInsert(minIdx);
        self.candidateMasksByIndex[minIdx] = altCandidatesMask;
        return;
    }

    fn startBranchFromMinCandidate(self: *@This()) void {
        const minIdx = self.getMinCandidateIndex();
        const minMask = self.candidateMasksByIndex[minIdx];
        const value = popFirstFromMask(minMask);
        const reducedMask = minMask & (~MASK_MAP[value]);

        return self.startBranch(minIdx, value, reducedMask);
    }

    inline fn appendToBranch(self: *@This(), idx: BoardIndex, value: BoardValue) void {
        const changed = self.b.insertValue(idx, value);
        std.debug.assert(changed);
        self.seq.appendInsert(idx);
        self.candidateMasksByIndex[idx] = MASK_EMPTY;
    }

    inline fn appendToBranchByMask(self: *@This(), idx: BoardIndex, mask: Mask) void {
        return self.appendToBranch(idx, maskToBoardValue(mask));
    }

    fn backtrack(self: *@This()) SolverResult {
        const maybePos = self.getSequencePosOfCurrentBranchRoot();
        if (maybePos) |pos| {
            const indicesToClear = self.seq.setBacktrackedPivot(pos);
            _ = self.b.removeValues(indicesToClear);
            const idx = self.seq.getPivotIndex();
            const candMask = self.candidateMasksByIndex[idx];
            const value = popFirstFromMask(candMask);
            const reducedMask = candMask & (~MASK_MAP[value]);
            const changed = self.b.insertValue(idx, value);
            if (!changed) {
                unreachable;
            }
            self.seq.appendInsert(idx);
            self.candidateMasksByIndex[idx] = reducedMask;

            return SolverResult.NEED_RESTRICT;
        } else {
            return SolverResult.UNSOLVABLE_BOARD;
        }
    }
};
