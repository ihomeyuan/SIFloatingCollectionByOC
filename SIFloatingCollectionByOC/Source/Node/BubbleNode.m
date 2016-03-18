//
//  BubbleNode.m
//  SIFloatingCollectionByOC
//
//  Created by yurongde on 16/3/17.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "BubbleNode.h"
@interface BubbleNode()
@property (nonatomic) SKLabelNode *labelNode;
@end
@implementation BubbleNode

+ (instancetype)initWithRadius:(CGFloat)radius{
    BubbleNode *node = [BubbleNode shapeNodeWithCircleOfRadius:radius];
    if (!node) {
        return nil;
    }
    [node configureNode];
    
    return node;
}
#pragma mark - private methods
- (void)configureNode {
    
    CGRect boundingBox = CGPathGetBoundingBox(self.path);
    CGFloat radius = boundingBox.size.width / 2.0;
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius + 1.5];

    self.fillColor = [SKColor blackColor];
    self.strokeColor = self.fillColor;
    
    self.labelNode.text = @"hello";
    self.labelNode.position = CGPointZero;

    self.labelNode.fontColor = [SKColor whiteColor];
    self.labelNode.fontSize = 10;
    self.labelNode.userInteractionEnabled = NO;
    self.labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [self addChild:self.labelNode];
}
#pragma mark - public methods
- (SKAction *)selectingAnimation {
    [self removeActionForKey:removingKey];
    return [SKAction scaleTo:1.3 duration:0.2];
}
- (SKAction *)normalizeAnimation {
    [self removeActionForKey:removingKey];
    return [SKAction scaleTo:1.0 duration:0.2];
}

- (SKAction *)removeAnimation {
    [self removeActionForKey:removingKey];
    return [SKAction fadeOutWithDuration:0.2];
}
- (SKAction *)removingAnimation {
    
    SKAction *pulseUp = [SKAction scaleTo:self.xScale + 0.13 duration:0];
    SKAction *pulseDown = [SKAction scaleTo:self.xScale duration:0.3];
    SKAction *pulse = [SKAction sequence:@[pulseUp,pulseDown]];
    SKAction *repeatPulse = [SKAction repeatActionForever:pulse];
    
    return repeatPulse;
}
#pragma mark - getters and setters
- (SKLabelNode *)labelNode {
    if (!_labelNode) {
        _labelNode = [SKLabelNode labelNodeWithFontNamed:@""];
    }
    return _labelNode;
}
@end
