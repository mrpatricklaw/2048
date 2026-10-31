//
//  G2048GameEngine.h
//  2048 iOS
//
//  Created by Patrick Law on 10/30/26.
//
#import <Foundation/Foundation.h>
#import "G2048GridPosition.h"

typedef NS_ENUM(NSInteger, G2048MigrationDirection) {
    G2048MigrationDirectionUp,
    G2048MigrationDirectionDown,
    G2048MigrationDirectionLeft,
    G2048MigrationDirectionRight
};

typedef void (^G2048MigrationHandler)(G2048GridPosition *sourcePosition, G2048GridPosition *destinationPosition);
typedef void (^G2048CombinationHandler)(G2048GridPosition *targetPosition, NSInteger combinedValue);

@interface G2048GameEngine : NSObject

@property (nonatomic, readonly) NSInteger currentScore;
@property (nonatomic, readonly) BOOL isBoardLocked;

- (void)initializeEmptyMatrix;
- (BOOL)processSwipeInDirection:(G2048MigrationDirection)direction
             onTileDisplacement:(G2048MigrationHandler)migrationHandler
                onTileCollision:(G2048CombinationHandler)combinationHandler;
- (void)determineRandomAvailablePosition:(G2048GridPosition **)outPosition assignedValue:(int *)outValue;

@end
