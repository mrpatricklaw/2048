//
//  G2048GameScene.h
//  2048 iOS
//
//  Created by Patrick Law on 10/30/26.
//
#import <SpriteKit/SpriteKit.h>
#import "G2048GameEngine.h"

@interface G2048GameScene : SKScene
- (void)executeBoardShiftInDirection:(G2048MigrationDirection)direction;
- (void)updateScoreDisplay:(NSInteger)score;

@end

