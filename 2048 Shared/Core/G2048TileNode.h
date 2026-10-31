//
//  G2048TileNode.h
//  2048 iOS
//
//  Created by Patrick Law on 10/30/26.
//
#import <SpriteKit/SpriteKit.h>

@interface G2048TileNode : SKSpriteNode

@property (nonatomic, readonly) NSInteger numericalValue;

+ (instancetype)tileWithValue:(NSInteger)value size:(CGSize)size;
- (void)updateValueTo:(NSInteger)newValue shouldAnimate:(BOOL)shouldAnimate;

@end
