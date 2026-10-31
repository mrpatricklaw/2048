//
//  G2048GameViewController.m
//  2048 iOS
//
//  Created by Patrick Law on 10/30/26.
//
#import "G2048GameViewController.h"
#import "G2048GameScene.h"

@implementation G2048GameViewController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    SKView *primaryGameView = (SKView *)self.view;
    if (!primaryGameView.scene) {
        primaryGameView.showsFPS = NO;
        primaryGameView.showsNodeCount = NO;
        primaryGameView.ignoresSiblingOrder = YES;
        
        G2048GameScene *interactiveScene = [G2048GameScene sceneWithSize:primaryGameView.bounds.size];
        interactiveScene.scaleMode = SKSceneScaleModeAspectFill;
        
        [self wireUpGestureRecognizersToView:primaryGameView targetScene:interactiveScene];
        [primaryGameView presentScene:interactiveScene];
    }
}

- (void)wireUpGestureRecognizersToView:(UIView *)targetView targetScene:(G2048GameScene *)targetScene {
    NSArray<NSNumber *> *gestureDirections = @[
        @(UISwipeGestureRecognizerDirectionUp),
        @(UISwipeGestureRecognizerDirectionDown),
        @(UISwipeGestureRecognizerDirectionLeft),
        @(UISwipeGestureRecognizerDirectionRight)
    ];
    
    for (NSNumber *directionValue in gestureDirections) {
        UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToDeviceSwipeGesture:)];
        swipeRecognizer.direction = [directionValue unsignedIntegerValue];
        [targetView addGestureRecognizer:swipeRecognizer];
    }
}

- (void)respondToDeviceSwipeGesture:(UISwipeGestureRecognizer *)gesture {
    SKView *activeView = (SKView *)self.view;
    
    // Ignore input swipes entirely if the user is on the Game Over scene context
    if (![activeView.scene isKindOfClass:[G2048GameScene class]]) {
        return;
    }
    
    G2048GameScene *activeScene = (G2048GameScene *)activeView.scene;
    switch (gesture.direction) {
        case UISwipeGestureRecognizerDirectionUp:    [activeScene executeBoardShiftInDirection:G2048MigrationDirectionUp];    break;
        case UISwipeGestureRecognizerDirectionDown:  [activeScene executeBoardShiftInDirection:G2048MigrationDirectionDown];  break;
        case UISwipeGestureRecognizerDirectionLeft:  [activeScene executeBoardShiftInDirection:G2048MigrationDirectionLeft];  break;
        case UISwipeGestureRecognizerDirectionRight: [activeScene executeBoardShiftInDirection:G2048MigrationDirectionRight]; break;
        default: break;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
