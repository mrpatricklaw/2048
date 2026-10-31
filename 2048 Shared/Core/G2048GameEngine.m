//
//  G2048GameEngine.m
//  2048 iOS
//
//  Created by Patrick Law on 10/30/26.
//
#import "G2048GameEngine.h"

@interface G2048GameEngine () {
    int _numericalBoard[4][4];
}
@property (nonatomic, readwrite) NSInteger currentScore;
@property (nonatomic, readwrite) BOOL isBoardLocked;
@end

@implementation G2048GameEngine

- (void)initializeEmptyMatrix {
    _currentScore = 0;
    _isBoardLocked = NO;
    for (int r = 0; r < 4; r++) {
        for (int c = 0; c < 4; c++) {
            _numericalBoard[r][c] = 0;
        }
    }
}

- (void)determineRandomAvailablePosition:(G2048GridPosition **)outPosition assignedValue:(int *)outValue {
    int availableRows[16];
    int availableCols[16];
    int availableCount = 0;
    
    for (int r = 0; r < 4; r++) {
        for (int c = 0; c < 4; c++) {
            if (_numericalBoard[r][c] == 0) {
                availableRows[availableCount] = r;
                availableCols[availableCount] = c;
                availableCount++;
            }
        }
    }
    
    if (availableCount > 0) {
        int pickedIndex = arc4random_uniform(availableCount);
        int targetRow = availableRows[pickedIndex];
        int targetCol = availableCols[pickedIndex];
        int tileValue = (arc4random_uniform(10) == 0) ? 4 : 2;
        
        _numericalBoard[targetRow][targetCol] = tileValue;
        
        if (outPosition) *outPosition = [G2048GridPosition positionWithRow:targetRow column:targetCol];
        if (outValue) *outValue = tileValue;
    }
}

- (BOOL)processSwipeInDirection:(G2048MigrationDirection)direction
             onTileDisplacement:(G2048MigrationHandler)migrationHandler
                onTileCollision:(G2048CombinationHandler)combinationHandler {
    
    if (_isBoardLocked) return NO;
    BOOL stateHasChanged = NO;
    BOOL internalMergeTracker[4][4] = {NO};
    
    int rowIterationStart = (direction == G2048MigrationDirectionDown) ? 3 : 0;
    int rowIterationEnd   = (direction == G2048MigrationDirectionDown) ? -1 : 4;
    int rowIterationStep  = (direction == G2048MigrationDirectionDown) ? -1 : 1;

    int colIterationStart = (direction == G2048MigrationDirectionRight) ? 3 : 0;
    int colIterationEnd   = (direction == G2048MigrationDirectionRight) ? -1 : 4;
    int colIterationStep  = (direction == G2048MigrationDirectionRight) ? -1 : 1;

    for (int r = rowIterationStart; r != rowIterationEnd; r += rowIterationStep) {
        for (int c = colIterationStart; c != colIterationEnd; c += colIterationStep) {
            if (_numericalBoard[r][c] == 0) continue;

            int activeRow = r;
            int activeCol = c;
            
            int rowOffset = (direction == G2048MigrationDirectionUp) ? -1 : (direction == G2048MigrationDirectionDown) ? 1 : 0;
            int colOffset = (direction == G2048MigrationDirectionLeft) ? -1 : (direction == G2048MigrationDirectionRight) ? 1 : 0;
            
            int nextRow = activeRow + rowOffset;
            int nextCol = activeCol + colOffset;
            
            while (nextRow >= 0 && nextRow < 4 && nextCol >= 0 && nextCol < 4) {
                if (_numericalBoard[nextRow][nextCol] == 0) {
                    _numericalBoard[nextRow][nextCol] = _numericalBoard[activeRow][activeCol];
                    _numericalBoard[activeRow][activeCol] = 0;
                    
                    if (migrationHandler) {
                        migrationHandler([G2048GridPosition positionWithRow:activeRow column:activeCol],
                                         [G2048GridPosition positionWithRow:nextRow column:nextCol]);
                    }
                    
                    activeRow = nextRow;
                    activeCol = nextCol;
                    stateHasChanged = YES;
                } else if (_numericalBoard[nextRow][nextCol] == _numericalBoard[activeRow][activeCol] && !internalMergeTracker[nextRow][nextCol]) {
                    _numericalBoard[nextRow][nextCol] *= 2;
                    _numericalBoard[activeRow][activeCol] = 0;
                    _currentScore += _numericalBoard[nextRow][nextCol];
                    internalMergeTracker[nextRow][nextCol] = YES;
                    
                    if (migrationHandler) {
                        migrationHandler([G2048GridPosition positionWithRow:activeRow column:activeCol],
                                         [G2048GridPosition positionWithRow:nextRow column:nextCol]);
                    }
                    if (combinationHandler) {
                        combinationHandler([G2048GridPosition positionWithRow:nextRow column:nextCol],
                                           _numericalBoard[nextRow][nextCol]);
                    }
                    
                    stateHasChanged = YES;
                    break;
                } else {
                    break;
                }
                nextRow = activeRow + rowOffset;
                nextCol = activeCol + colOffset;
            }
        }
    }
    
    [self evaluateBoardLockState];
    return stateHasChanged;
}

- (void)evaluateBoardLockState {
    for (int r = 0; r < 4; r++) {
        for (int c = 0; c < 4; c++) {
            if (_numericalBoard[r][c] == 0) return;
            if (r + 1 < 4 && _numericalBoard[r][c] == _numericalBoard[r+1][c]) return;
            if (c + 1 < 4 && _numericalBoard[r][c] == _numericalBoard[r][c+1]) return;
        }
    }
    _isBoardLocked = YES;
}

@end
