//
//  G2048TileNode.m
//  2048 iOS
//
//  Created by Patrick Law on 10/30/26.
//
#import "G2048TileNode.h"

@interface G2048TileNode ()
@property (nonatomic, readwrite) NSInteger numericalValue;
@property (nonatomic, strong) SKLabelNode *valueDisplayLabel;
@end

@implementation G2048TileNode

+ (instancetype)tileWithValue:(NSInteger)value size:(CGSize)size {
    G2048TileNode *tile = [self spriteNodeWithColor:[SKColor clearColor] size:size];
    if (tile) {
        tile.numericalValue = value;
        [tile configureSubviews];
    }
    return tile;
}

- (void)configureSubviews {
    self.valueDisplayLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Bold"];
    self.valueDisplayLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.valueDisplayLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [self addChild:self.valueDisplayLabel];
    
    [self updateValueTo:self.numericalValue shouldAnimate:NO];
    
    self.scale = 0.1;
    [self runAction:[SKAction scaleTo:1.0 duration:0.15]];
}

- (void)updateValueTo:(NSInteger)newValue shouldAnimate:(BOOL)shouldAnimate {
    self.numericalValue = newValue;
    self.valueDisplayLabel.text = [NSString stringWithFormat:@"%ld", (long)newValue];
    
    if (newValue < 100) {
        self.valueDisplayLabel.fontSize = self.size.width * 0.45;
    } else if (newValue < 1000) {
        self.valueDisplayLabel.fontSize = self.size.width * 0.38;
    } else {
        self.valueDisplayLabel.fontSize = self.size.width * 0.32;
    }
    
    NSDictionary<NSString *, UIColor *> *themePalette = [self resolveThemePaletteForValue:newValue];
    self.color = themePalette[@"backgroundColor"];
    self.valueDisplayLabel.fontColor = themePalette[@"textColor"];
    
    if (shouldAnimate) {
        SKAction *bounceUp = [SKAction scaleTo:1.15 duration:0.08];
        SKAction *bounceDown = [SKAction scaleTo:1.0 duration:0.08];
        [self runAction:[SKAction sequence:@[bounceUp, bounceDown]]];
    }
}

- (NSDictionary<NSString *, UIColor *> *)resolveThemePaletteForValue:(NSInteger)value {
    UIColor *bg;
    UIColor *fg = [UIColor colorWithRed:0.97 green:0.96 blue:0.94 alpha:1.0];
    
    switch (value) {
        case 2:
            bg = [UIColor colorWithRed:0.93 green:0.89 blue:0.85 alpha:1.0];
            fg = [UIColor colorWithRed:0.47 green:0.43 blue:0.40 alpha:1.0];
            break;
        case 4:
            bg = [UIColor colorWithRed:0.93 green:0.88 blue:0.78 alpha:1.0];
            fg = [UIColor colorWithRed:0.47 green:0.43 blue:0.40 alpha:1.0];
            break;
        case 8:    bg = [UIColor colorWithRed:0.95 green:0.69 blue:0.47 alpha:1.0]; break;
        case 16:   bg = [UIColor colorWithRed:0.96 green:0.58 blue:0.39 alpha:1.0]; break;
        case 32:   bg = [UIColor colorWithRed:0.96 green:0.48 blue:0.37 alpha:1.0]; break;
        case 64:   bg = [UIColor colorWithRed:0.96 green:0.37 blue:0.24 alpha:1.0]; break;
        case 128:  bg = [UIColor colorWithRed:0.93 green:0.81 blue:0.45 alpha:1.0]; break;
        case 256:  bg = [UIColor colorWithRed:0.93 green:0.80 blue:0.38 alpha:1.0]; break;
        case 512:  bg = [UIColor colorWithRed:0.93 green:0.78 blue:0.31 alpha:1.0]; break;
        case 1024: bg = [UIColor colorWithRed:0.93 green:0.77 blue:0.25 alpha:1.0]; break;
        case 2048: bg = [UIColor colorWithRed:0.93 green:0.76 blue:0.18 alpha:1.0]; break;
        default:   bg = [UIColor colorWithRed:0.24 green:0.23 blue:0.20 alpha:1.0]; break;
    }
    return @{@"backgroundColor": bg, @"textColor": fg};
}

@end
