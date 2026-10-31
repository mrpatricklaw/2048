//
//  G2048GameOverScene.m
//  2048 iOS
//
//  Created by Patrick Law on 10/30/26.
//
#import "G2048GameOverScene.h"
#import "G2048GameScene.h"

@implementation G2048GameOverScene

- (instancetype)initWithSize:(CGSize)size finalScore:(NSInteger)finalScore {
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [SKColor colorWithRed:0.98 green:0.96 blue:0.90 alpha:1.0];
        [self buildSceneInterfaceWithScore:finalScore];
    }
    return self;
}

- (void)buildSceneInterfaceWithScore:(NSInteger)finalScore {
    SKNode *uiContainer = [SKNode node];
    uiContainer.alpha = 0.0;
    [self addChild:uiContainer];
    
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Bold"];
    titleLabel.text = @"Game Over";
    titleLabel.fontSize = 44.0;
    titleLabel.fontColor = [SKColor colorWithRed:0.47 green:0.43 blue:0.40 alpha:1.0];
    titleLabel.position = CGPointMake(self.size.width / 2.0, self.size.height * 0.60);
    [uiContainer addChild:titleLabel];
    
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Bold"];
    scoreLabel.text = [NSString stringWithFormat:@"Final Score: %ld", (long)finalScore];
    scoreLabel.fontSize = 24.0;
    scoreLabel.fontColor = [SKColor colorWithRed:0.73 green:0.68 blue:0.63 alpha:1.0];
    scoreLabel.position = CGPointMake(self.size.width / 2.0, self.size.height * 0.50);
    [uiContainer addChild:scoreLabel];
    
    SKLabelNode *actionHintLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    actionHintLabel.text = @"Tap anywhere to play again";
    actionHintLabel.fontSize = 16.0;
    actionHintLabel.fontColor = [SKColor colorWithRed:0.47 green:0.43 blue:0.40 alpha:0.6];
    actionHintLabel.position = CGPointMake(self.size.width / 2.0, self.size.height * 0.35);
    [uiContainer addChild:actionHintLabel];
    
    [uiContainer runAction:[SKAction fadeInWithDuration:0.40]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    G2048GameScene *freshGameScene = [G2048GameScene sceneWithSize:self.size];
    freshGameScene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKTransition *transitionEffect = [SKTransition fadeWithColor:self.backgroundColor duration:0.50];
    [self.view presentScene:freshGameScene transition:transitionEffect];
}

@end
