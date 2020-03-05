pub const NUM_BOX = 3; // NUM_BOX
pub const NUM_SIDE = NUM_BOX*NUM_BOX; // NUM_SIDE
pub const NUM_SQUARES = NUM_SIDE*NUM_SIDE; // NUM_SQUQRES


pub const RawString = []const u8;


//pub const BoardValue = @IntType(false,8);
pub const BoardValue = u8;


pub const SudokuResultStatus = enum{
    NOT_SOLVABLE,
    SOLVED,
    BAD_INITIAL_BOARD,
    MAXITER_REACHED,
};

pub const SudokuResult = struct{
    boardValues: [NUM_SQUARES]BoardValue,
    resultStatus: SudokuResultStatus,
};

pub const SudokuSolverFn = fn([NUM_SQUARES]BoardValue) SudokuResult;
