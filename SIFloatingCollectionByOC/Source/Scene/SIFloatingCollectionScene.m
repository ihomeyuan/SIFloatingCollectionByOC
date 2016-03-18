//
//  SIFloatingCollectionScene.m
//  SIFloatingCollectionByOC
//
//  Created by yurongde on 16/3/17.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "SIFloatingCollectionScene.h"
#import "SIFloatingNode.h"

@interface SIFloatingCollectionScene()
@property (nonatomic,assign) SIFloatingCollectionSceneMode mode;


@property (nonatomic,assign) CGPoint touchPoint;
@property (nonatomic,assign) NSTimeInterval touchStartedTime;
@property (nonatomic,assign) NSTimeInterval removingStartedTime;

@end
@implementation SIFloatingCollectionScene

- (CGFloat)distanceBetweenPoints:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint {
    return hypot(secondPoint.x - firstPoint.x, secondPoint.y - firstPoint.y);
}

#pragma mark - lifecycle
- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (!self) {
        return nil;
    }
    _timeToStartRemove = 0.7;
    _timeToRemove = 2;
    _allowMultipleSelection = YES;
    _restrictedToBounds = YES;
    _pushStrength = 10000;
    
    return self;
}
- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    [self configureMySelf];
}

- (void)update:(NSTimeInterval)currentTime {
    //TODO
    
    for (SKNode *node in self.floatingNodes) {
        CGFloat distanceFromCenter = [self distanceBetweenPoints:self.magneticField.position secondPoint:node.position];
        node.physicsBody.linearDamping = distanceFromCenter > 100 ? 2 : 2 + ((100 - distanceFromCenter) / 10);

    }
    
    if (self.mode == SIFloatingCollectionSceneMode_Moving || !self.allowEditing) {
        return;
    }
    
//    if (self.touchStartedTime != 0) {
//        CGPoint tPoint = self.touchPoint;
//        NSTimeInterval dTime = currentTime - self.touchStartedTime;
//        if (dTime >= self.timeToStartRemove) {
//            self.touchStartedTime = 0;
//            
//            SIFloatingNode *node = (SIFloatingNode *)[self nodeAtPoint:tPoint];
//            if ([node isKindOfClass:[SIFloatingNode class]]) {
//                self.removingStartedTime = currentTime;
//                [self startRemovingNode:node];
//            }
//        }
//    }
//    else if(self.mode == SIFloatingCollectionSceneMode_Editing && self.removingStartedTime != 0 ) {
//        NSTimeInterval dTime = currentTime - self.removingStartedTime;
//        CGPoint tPoint = self.touchPoint;
//
//        if (dTime >= self.timeToRemove) {
//            self.removingStartedTime = 0;
//            SIFloatingNode *node = (SIFloatingNode *)[self nodeAtPoint:tPoint];
//            if ([node isKindOfClass:[SIFloatingNode class]]) {
//                NSInteger index = [self.floatingNodes indexOfObject:node];
//                if (index != NSNotFound) {
//                    [self removeFloatinNodeAtIndex:index];
//                }
//            }
//        }
//    }
}
#pragma mark - event response
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //取出第一个值
    UITouch *touch;
    NSEnumerator *enumerator = [touches objectEnumerator];
    int i = 0;
    for (UITouch *touchObject in enumerator) {
        if (i == 0) {
            touch = touchObject;
            break;
        }
    }
    
    if (touch) {
        self.touchPoint = [touch locationInNode:self];
        self.touchStartedTime = touch.timestamp;
    }
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.mode == SIFloatingCollectionSceneMode_Editing) {
        return;
    }
    
    //取出第一个值
    UITouch *touch;
    NSEnumerator *enumerator = [touches objectEnumerator];
    int i = 0;
    for (UITouch *touchObject in enumerator) {
        if (i == 0) {
            touch = touchObject;
            break;
        }
    }

    if (touch) {
        CGPoint plin = [touch previousLocationInNode:self];
        CGPoint lin = [touch locationInNode:self];
        CGFloat dx = lin.x - plin.x;
        CGFloat dy = lin.y - plin.y;
        
        CGFloat b = sqrt(pow(lin.x, 2) + pow(lin.y, 2));
        dx = b == 0 ? 0 : (dx / b);
        dy = b == 0 ? 0 : (dy / b);
        
        if (dx == 0 && dy == 0) {
            return;
        }
        else if(self.mode != SIFloatingCollectionSceneMode_Moving) {
            self.mode = SIFloatingCollectionSceneMode_Moving;
        }
        
        for (SIFloatingNode *node in self.floatingNodes) {
            CGFloat w = node.frame.size.width / 2;
            CGFloat h = node.frame.size.height / 2;
            CGVector direction = CGVectorMake(self.pushStrength * dx, self.pushStrength * dy);
            
            if (self.restrictedToBounds) {
                if (!(node.position.x >= -w && node.position.x <= self.size.width + w) && (node.position.x * dx > 0)) {
                    direction.dx = 0;
                }
                
                if (!(node.position.y >= -h && node.position.y <= self.size.height + h) && (node.position.y * dy > 0)) {
                    direction.dy = 0;
                }
            }
            
            [node.physicsBody applyForce:direction];
        }
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.mode != SIFloatingCollectionSceneMode_Editing) {
        SIFloatingNode *node = (SIFloatingNode *)[self nodeAtPoint:self.touchPoint];
        if ([node isKindOfClass:[SIFloatingNode class]]) {
            [self updateNodeState:node];
        }
    }
    self.mode = SIFloatingCollectionSceneMode_Normal;
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.mode = SIFloatingCollectionSceneMode_Normal;
}


#pragma mark - Nodes Manipulation
- (void)cancelRemovingNode:(SIFloatingNode *)node {
    self.mode = SIFloatingCollectionSceneMode_Normal;
    node.physicsBody.dynamic = YES;
    node.state = node.previousState;
    
    NSInteger index = [self.floatingNodes indexOfObject:node];
    
    if (index != NSNotFound) {
        [self.floatingDelegate floatingScene:self canceledRemovingOfFloatingNodeAtIndex:index];
    }
    
}
- (SIFloatingNode *)floatingNodeAtIndex:(NSInteger)index {
    if (index < self.floatingNodes.count && index >= 0 ) {
        return self.floatingNodes[index];
    }
    return nil;
}
- (NSInteger)indexOfSelectedNode {
   __block NSInteger index = -1;
    
    [self.floatingNodes enumerateObjectsUsingBlock:^(SIFloatingNode *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.state == SIFloatingNode_Selected) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}
- (NSArray *)indexesOfSelectedNodes {
    NSMutableArray *indexes = [NSMutableArray array];
    
    [self.floatingNodes enumerateObjectsUsingBlock:^(SIFloatingNode *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.state == SIFloatingNode_Selected) {
            [indexes addObject:@(idx)];
        }
    }];
    
    return indexes;
}
- (SKNode *)nodeAtPoint:(CGPoint)p {
    SKNode *currentNode = [super nodeAtPoint:p];
    
    while (!([currentNode.parent isKindOfClass:[SKScene class]]) && !([currentNode isKindOfClass:[SIFloatingNode class]]) && (currentNode.parent != nil) && !currentNode.userInteractionEnabled) {
        currentNode = currentNode.parent;
    }
    return currentNode;
}
- (void)removeFloatinNodeAtIndex:(NSInteger)index {
    if ([self shouldRemoveNodeAtIndex:index]) {
        SIFloatingNode *node = self.floatingNodes[index];
        [self.floatingNodes removeObjectAtIndex:index];
        [node removeFromParent];
        
        [self.floatingDelegate floatingScene:self didRemoveFloatingNodeAtIndex:index];
    }
}

- (void)startRemovingNode:(SIFloatingNode *)node {
    self.mode = SIFloatingCollectionSceneMode_Editing;
    node.physicsBody.dynamic = NO;
    node.state = SIFloatingNode_Removing;
    NSInteger index = [self.floatingNodes indexOfObject:node];
    if (index != NSNotFound) {
        [self.floatingDelegate floatingScene:self startedRemovingOfFloatingNodeAtIndex:index];
    }
    
}
- (void)updateNodeState:(SIFloatingNode *)node {
    NSUInteger index = [self.floatingNodes indexOfObject:node];
    if (index != NSNotFound) {
        switch (node.state) {
            case SIFloatingNode_Normal: {
                if ([self shouldSelectNodeAtIndex:index]) {
                    node.state = SIFloatingNode_Selected;
                    [self.floatingDelegate floatingScene:self didSelectFloatingNodeAtIndex:index];
                }
                break;
            }
            case SIFloatingNode_Selected: {
                if ([self shouldDeselectNodeAtIndex:index]) {
                    node.state = SIFloatingNode_Normal;
                    [self.floatingDelegate floatingScene:self didDeselectFloatingNodeAtIndex:index];
                }
                else {
                    [self.floatingDelegate floatingScene:self didSelectFloatingNodeAtIndex:index];
                }
                break;
            }
            case SIFloatingNode_Removing: {
                [self cancelRemovingNode:node];
                break;
            }
        }
    }
}
#pragma mark - Configuration
- (void)addChild:(SKNode *)node {
    if ([node isKindOfClass:[SIFloatingNode class]]) {
        SIFloatingNode *child = (SIFloatingNode *)node;
        [self configureNode:child];
        
        [self.floatingNodes addObject:child];
    }
    [super addChild:node];
}
- (void)configureMySelf {
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    self.magneticField.region = [[SKRegion alloc]initWithRadius:10000];
    self.magneticField.minimumRadius = 10000;
    self.magneticField.strength = 8000;
    self.magneticField.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:self.magneticField];
}
- (void)configureNode:(SIFloatingNode *)node {
    if (node.physicsBody == nil) {
        CGPathRef path = CGPathCreateMutable();
        if (node.path != nil) {
            path = node.path;
        }
        node.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    }
    
    node.physicsBody.dynamic = YES;
    node.physicsBody.affectedByGravity = NO;
    node.physicsBody.allowsRotation = NO;
    node.physicsBody.mass = 0.3;
    node.physicsBody.friction = 0;
    node.physicsBody.linearDamping = 3;
}
- (void)modeUpdated {
    switch (self.mode) {
        case SIFloatingCollectionSceneMode_Normal: {
            self.touchStartedTime = 0;
            self.removingStartedTime = 0;
            self.touchPoint = CGPointZero;
            break;
        }
        case SIFloatingCollectionSceneMode_Editing: {
            
            break;
        }
        case SIFloatingCollectionSceneMode_Moving: {
            self.touchStartedTime = 0;
            self.removingStartedTime = 0;
            self.touchPoint = CGPointZero;
            break;
        }
    }
}
#pragma mark - delegate helper
- (BOOL)shouldRemoveNodeAtIndex:(NSInteger)index {
    if (index >= 0 && index <= self.floatingNodes.count - 1) {
        
        return [self.floatingDelegate floatingScene:self shouldRemoveFloatingNodeAtIndex:index];
    }
    return NO;
}
- (BOOL)shouldSelectNodeAtIndex:(NSInteger)index {
    if ([self.floatingDelegate respondsToSelector:@selector(floatingScene:shouldSelectFloatingNodeAtIndex:)]) {
        return [self.floatingDelegate floatingScene:self shouldSelectFloatingNodeAtIndex:index];
    }
    return YES;
}
- (BOOL)shouldDeselectNodeAtIndex:(NSInteger)index {
    if ([self.floatingDelegate respondsToSelector:@selector(floatingScene:shouldDeselectFloatingNodeAtIndex:)]) {
        return [self.floatingDelegate floatingScene:self shouldDeselectFloatingNodeAtIndex:index];
    }
    return YES;
}
#pragma mark - getters and setters
- (void)setMode:(SIFloatingCollectionSceneMode)mode {
    _mode = mode;
    [self modeUpdated];
    
}
- (SKFieldNode *)magneticField {
    if (!_magneticField) {
        _magneticField = [SKFieldNode radialGravityField];
    }
    return _magneticField;
}
- (NSMutableArray *)floatingNodes {
    if (!_floatingNodes) {
        _floatingNodes = [NSMutableArray array];
    }
    return _floatingNodes;
}
@end
