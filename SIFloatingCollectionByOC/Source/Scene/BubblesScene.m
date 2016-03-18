//
//  BubblesScene.m
//  SIFloatingCollectionByOC
//
//  Created by yurongde on 16/3/17.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "BubblesScene.h"
#import "BubbleNode.h"
#import "SIFloatingNode.h"
@interface BubblesScene()




@end
@implementation BubblesScene
- (instancetype)initWithSize:(CGSize)size {
    
    self = [super initWithSize:size];
    if (!self) {
        return nil;
    }
    _bottomOffset = 100;
    _topOffset = 100;
    
    return self;
}
- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    [self configure];
    
    
}

- (void)configure {
    self.backgroundColor = [UIColor whiteColor];

    self.scaleMode = SKSceneScaleModeAspectFill;
    
    self.allowMultipleSelection = NO;
    
    CGRect bodyFrame = self.frame;
    bodyFrame.size.width =  (CGFloat)self.magneticField.minimumRadius;
    bodyFrame.origin.x -= bodyFrame.size.width / 2;
    bodyFrame.size.height = self.frame.size.height - self.bottomOffset;
    bodyFrame.origin.y = self.frame.size.height - bodyFrame.size.height - self.topOffset;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bodyFrame];
    
    self.magneticField.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + self.bottomOffset / 2 - self.topOffset);

}
- (void)addChild:(SKNode *)node {
    if ([node isKindOfClass:[BubbleNode class]]) {
        CGFloat x = [self randomMin:-self.bottomOffset max:-node.frame.size.width];
        CGFloat y = [self randomMin:self.frame.size.height - self.bottomOffset - node.frame.size.height max:self.frame.size.height - self.topOffset - node.frame.size.height];
        
        if (self.floatingNodes.count %2 == 0 || !self.floatingNodes.count) {
            x = [self randomMin:self.frame.size.width + node.frame.size.width max:self.frame.size.width + self.bottomOffset];
        }
        
        node.position = CGPointMake(x, y);
    }
    
    [super addChild:node];
}

- (void)performCommitSelectionAnimation {
    
    if ([self.floatingDelegate respondsToSelector:@selector(floatingScene:shouldRemoveFloatingNodeAtIndex:)]) {
        if (![self.floatingDelegate floatingScene:self shouldRemoveFloatingNodeAtIndex:0]) {

            NSLog(@"不移除");
            return;
        }
    }
    
//    self.physicsWorld.speed = 0;
    NSArray *sortedNodes = [self sortedFloatingNodes];
    
    NSMutableArray *actions = [NSMutableArray arrayWithCapacity:0];
    
    for (SIFloatingNode *node in sortedNodes) {
        node.physicsBody = nil;
        SKAction *action = [self actionForFloatingNode:(node)];
        [actions addObject:action];
    }
    
    [self runAction:[SKAction sequence:actions]];
}
- (void)throwNode:(SKNode *)node toPoint:(CGPoint)toPoint completion:(void(^)())completion {
    [node removeAllActions];
    
    SKAction *movingXAction = [SKAction moveToX:toPoint.x duration:0.2];
    SKAction *movingYAction = [SKAction moveToY:toPoint.y duration:0.4];
    SKAction *resize = [SKAction scaleTo:0.3 duration:0.4];
    SKAction *throwAction = [SKAction group:@[movingXAction,movingYAction,resize]];
    
    [node runAction:throwAction];
}
- (NSArray *)sortedFloatingNodes {
    //TOFix:
    //      升序排序
    NSComparator cmptr = ^(SIFloatingNode *node,SIFloatingNode *nextNode) {
        
        CGFloat distance = [self distanceBetweenPoints:node.position secondPoint:self.magneticField.position];
        CGFloat nextDistance = [self distanceBetweenPoints:nextNode.position secondPoint:self.magneticField.position];
        
        if (distance < nextDistance && node.state != SIFloatingNode_Selected) {
            return NSOrderedDescending;
        }
        
        return NSOrderedSame;
        
    };
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.floatingNodes];
    [arr sortUsingComparator:cmptr];
    return arr;
}

- (SKAction *)actionForFloatingNode:(SIFloatingNode *)node {
    SKAction *action = [SKAction runBlock:^{
        NSInteger index = [self.floatingNodes indexOfObject:node];
        if (index != NSNotFound) {
            [self removeFloatinNodeAtIndex:index];
            if (node.state == SIFloatingNode_Selected) {
                [self throwNode:node toPoint:CGPointMake(self.size.width / 2, self.size.height + 40) completion:^{
                    [node removeFromParent];
                }];
            }
        }
    }];
    
    
    return action;
    
}
#pragma mark - tool methods
- (CGFloat)random {
    return (CGFloat)((CGFloat)arc4random() / 0xFFFFFFFF);
}
- (CGFloat)randomMin:(CGFloat)min max:(CGFloat)max {
    return [self random] * (max - min) + min;
}
@end
