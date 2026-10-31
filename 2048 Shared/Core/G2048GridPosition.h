//
//  G2048GridPosition.h
//  2048 iOS
//
//  Created by Patrick Law on 10/30/26.
//
/**
 * G2048GridPosition.h
 * An immutable data model representing a coordinate coordinate location on a 4x4 matrix grid.
 */
#import <Foundation/Foundation.h>

@interface G2048GridPosition : NSObject <NSCopying>

@property (nonatomic, readonly) NSInteger row;
@property (nonatomic, readonly) NSInteger column;

+ (instancetype)positionWithRow:(NSInteger)row column:(NSInteger)column;
- (instancetype)initWithRow:(NSInteger)row column:(NSInteger)column;

@end
