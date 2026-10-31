//
//  G2048GameScene.m
//  2048 iOS
//
//  Created by Patrick Law on 10/30/26.
//
#import "G2048GameScene.h"
#import "G2048TileNode.h"

@interface G2048GameScene () {
    G2048TileNode *_renderedGrid[4][4];
    CGFloat _computedTileSize;
    CGFloat _gridInternalPadding;
    CGPoint _boardOriginPoint;
}
@property (nonatomic, strong) G2048GameEngine *gameEngine;
@property (nonatomic, strong) SKNode *gameBoardLayerContainer;
@property (nonatomic, strong) SKLabelNode *scoreLabelNode;
@property (nonatomic, assign) BOOL isTransitioningToGameOver;
@end

@implementation G2048GameScene

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor colorWithRed:0.98 green:0.96 blue:0.90 alpha:1.0];
    self.gameEngine = [[G2048GameEngine alloc] init];
    _isTransitioningToGameOver = NO;
    
    [self buildScoreTrackerHeaderInfrastructure];
    [self buildGameBoardInfrastructure];
    [self establishFreshGameSession];
}

- (void)buildScoreTrackerHeaderInfrastructure {
    CGFloat containerSideLength = 150.0;
    CGFloat cornerRadiusRadius = 10.0;
    UIColor *lightTextColor = [SKColor colorWithRed:0.97 green:0.96 blue:0.94 alpha:1.0];
    
    // Balanced top header screen position setup
    CGFloat headerCenterY = self.size.height * 0.85;
    
    // 1. LEFT BOX: Logo Box
    SKShapeNode *logoBoxNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(containerSideLength, containerSideLength)
                                                       cornerRadius:cornerRadiusRadius];
    logoBoxNode.fillColor = [SKColor colorWithRed:0.93 green:0.76 blue:0.18 alpha:1.0];
    logoBoxNode.strokeColor = [SKColor clearColor];
    logoBoxNode.position = CGPointMake(self.size.width * 0.28, headerCenterY);
    [self addChild:logoBoxNode];
    
    SKLabelNode *logoTextLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Bold"];
    logoTextLabel.text = @"2048";
    logoTextLabel.fontSize = 38.0;
    logoTextLabel.fontColor = lightTextColor;
    logoTextLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    logoTextLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    logoTextLabel.position = CGPointZero;
    [logoBoxNode addChild:logoTextLabel];
    
    // 2. RIGHT BOX: Score Display Box
    SKShapeNode *scoreBoxNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(containerSideLength, containerSideLength)
                                                        cornerRadius:cornerRadiusRadius];
    scoreBoxNode.fillColor = [SKColor colorWithRed:0.73 green:0.68 blue:0.63 alpha:1.0];
    scoreBoxNode.strokeColor = [SKColor clearColor];
    scoreBoxNode.position = CGPointMake(self.size.width * 0.72, headerCenterY);
    [self addChild:scoreBoxNode];
    
    SKLabelNode *scoreStaticTitleLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Bold"];
    scoreStaticTitleLabel.text = @"SCORE";
    scoreStaticTitleLabel.fontSize = 16.0;
    scoreStaticTitleLabel.fontColor = [SKColor colorWithRed:0.93 green:0.89 blue:0.85 alpha:1.0];
    scoreStaticTitleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    scoreStaticTitleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    scoreStaticTitleLabel.position = CGPointMake(0.0, 22.0);
    [scoreBoxNode addChild:scoreStaticTitleLabel];
    
    self.scoreLabelNode = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Bold"];
    self.scoreLabelNode.text = @"0";
    self.scoreLabelNode.fontSize = 28.0;
    self.scoreLabelNode.fontColor = lightTextColor;
    self.scoreLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    self.scoreLabelNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.scoreLabelNode.position = CGPointMake(0.0, -14.0);
    [scoreBoxNode addChild:self.scoreLabelNode];
}

- (void)buildGameBoardInfrastructure {
    CGFloat boundingDimension = MIN(self.size.width, self.size.height);
    CGFloat frameWidth = boundingDimension * 0.90;
    _gridInternalPadding = frameWidth * 0.03;
    _computedTileSize = (frameWidth - (_gridInternalPadding * 5)) / 4.0;
    
    // Margins offset down to 2.6 to prevent layout crashes with 150x150 frames
    _boardOriginPoint = CGPointMake((self.size.width - frameWidth) / 2.0, (self.size.height - frameWidth) / 2.6);
    
    self.gameBoardLayerContainer = [SKNode node];
    [self addChild:self.gameBoardLayerContainer];
    
    SKSpriteNode *backdropFrame = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:0.73 green:0.68 blue:0.63 alpha:1.0]
                                                               size:CGSizeMake(frameWidth, frameWidth)];
    backdropFrame.position = CGPointMake(self.size.width / 2.0, _boardOriginPoint.y + (frameWidth / 2.0));
    backdropFrame.zPosition = -2;
    [self.gameBoardLayerContainer addChild:backdropFrame];
    
    for (int r = 0; r < 4; r++) {
        for (int c = 0; c < 4; c++) {
            SKSpriteNode *backgroundCellSlot = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:0.80 green:0.75 blue:0.71 alpha:1.0]
                                                                             size:CGSizeMake(_computedTileSize, _computedTileSize)];
            backgroundCellSlot.position = [self screenCoordinatesForPosition:[G2048GridPosition positionWithRow:r column:c]];
            backgroundCellSlot.zPosition = -1;
            [self.gameBoardLayerContainer addChild:backgroundCellSlot];
            _renderedGrid[r][c] = nil;
        }
    }
}

- (CGPoint)screenCoordinatesForPosition:(G2048GridPosition *)position {
    CGFloat calculatedX = _boardOriginPoint.x + _gridInternalPadding + (position.column * (_computedTileSize + _gridInternalPadding)) + (_computedTileSize / 2.0);
    CGFloat calculatedY = _boardOriginPoint.y + _gridInternalPadding + ((3 - position.row) * (_computedTileSize + _gridInternalPadding)) + (_computedTileSize / 2.0);
    return CGPointMake(calculatedX, calculatedY);
}

- (void)establishFreshGameSession {
    [self.gameEngine initializeEmptyMatrix];
    [self updateScoreDisplay:0];
    [self introduceNewRandomTile];
    [self introduceNewRandomTile];
}

- (void)introduceNewRandomTile {
    G2048GridPosition *spawnLocation = nil;
    int numericValue = 2;
    [self.gameEngine determineRandomAvailablePosition:&spawnLocation assignedValue:&numericValue];
    
    if (spawnLocation) {
        G2048TileNode *newTile = [G2048TileNode tileWithValue:numericValue size:CGSizeMake(_computedTileSize, _computedTileSize)];
        newTile.position = [self screenCoordinatesForPosition:spawnLocation];
        [self.gameBoardLayerContainer addChild:newTile];
        _renderedGrid[spawnLocation.row][spawnLocation.column] = newTile;
    }
}

- (void)updateScoreDisplay:(NSInteger)score {
    self.scoreLabelNode.text = [NSString stringWithFormat:@"%ld", (long)score];
}


- (void)executeBoardShiftInDirection:(G2048MigrationDirection)direction {
    
    NSMutableDictionary<G2048GridPosition *, G2048TileNode *> *collisionCleanupRegistry = [NSMutableDictionary dictionary];
    
    BOOL actionWasTaken = [self.gameEngine processSwipeInDirection:direction onTileDisplacement:^(G2048GridPosition *sourcePosition, G2048GridPosition *destinationPosition) {
        G2048TileNode *activeNode = _renderedGrid[sourcePosition.row][sourcePosition.column];
        if (activeNode) {
            _renderedGrid[sourcePosition.row][sourcePosition.column] = nil;
            
            G2048TileNode *existingNodeAtDestination = _renderedGrid[destinationPosition.row][destinationPosition.column];
            if (existingNodeAtDestination) {
                collisionCleanupRegistry[destinationPosition] = existingNodeAtDestination;
            }
            _renderedGrid[destinationPosition.row][destinationPosition.column] = activeNode;
            
            CGPoint newPoint = [self screenCoordinatesForPosition:destinationPosition];
            [activeNode runAction:[SKAction moveTo:newPoint duration:0.12]];
        }
    } onTileCollision:^(G2048GridPosition *targetPosition, NSInteger combinedValue) {
        G2048TileNode *receivingNode = _renderedGrid[targetPosition.row][targetPosition.column];
        G2048TileNode *displacedNode = collisionCleanupRegistry[targetPosition];
        
        if (receivingNode) {
            [receivingNode runAction:[SKAction sequence:@[[SKAction waitForDuration:0.12], [SKAction runBlock:^{
                [receivingNode updateValueTo:combinedValue shouldAnimate:YES];
                if (displacedNode) [displacedNode removeFromParent];
            }]]]];
            [collisionCleanupRegistry removeObjectForKey:targetPosition];
        }
    }];
    
    for (G2048GridPosition *stalePosition in collisionCleanupRegistry) {
        G2048TileNode *residualNode = collisionCleanupRegistry[stalePosition];
        [residualNode runAction:[SKAction sequence:@[[SKAction waitForDuration:0.12], [SKAction removeFromParent]]]];
    }

    if (actionWasTaken) {
        [self runAction:[SKAction sequence:@[[SKAction waitForDuration:0.15], [SKAction runBlock:^{
            [self introduceNewRandomTile];
            [self updateScoreDisplay:self.gameEngine.currentScore];
        }]]]];
    }
}

@end
