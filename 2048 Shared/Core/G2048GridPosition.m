//
//  G2048GridPosition.m
//  2048 iOS
//
//  Created by Patrick Law on 10/30/26.
//
#import "G2048GridPosition.h"

@implementation G2048GridPosition

+ (instancetype)positionWithRow:(NSInteger)row column:(NSInteger)column {
    return [[self alloc] initWithRow:row column:column];
}

- (instancetype)initWithRow:(NSInteger)row column:(NSInteger)column {
    self = [super init];
    if (self) {
        _row = row;
        _column = column;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[G2048GridPosition allocWithZone:zone] initWithRow:self.row column:self.column];
}

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[G2048GridPosition class]]) return NO;
    G2048GridPosition *other = (G2048GridPosition *)object;
    return self.row == other.row && self.column == other.column;
}

- (NSUInteger)hash {
    return (self.row * 31) + self.column;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[%ld, %ld]", (long)self.row, (long)self.column];
}

@end
