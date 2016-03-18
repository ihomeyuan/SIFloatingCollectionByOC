//
//  SIFloatingNode.m
//  SIFloatingCollectionByOC
//
//  Created by yurongde on 16/3/17.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "SIFloatingNode.h"



@interface SIFloatingNode()
@end
@implementation SIFloatingNode

#pragma mark - private methods
- (void)stateChaged {
    SKAction *action;
    NSString *actionKey;
    
    switch (self.state) {
        case SIFloatingNode_Normal: {
            action = [self normalizeAnimation];
            actionKey = normalizeKey;
            break;
        }
        case SIFloatingNode_Selected: {
            action = [self selectingAnimation];
            actionKey = selectingKey;
            break;
        }
        case SIFloatingNode_Removing: {
            action = [self removingAnimation];
            actionKey = removingKey;
            break;
        }
    }
    [self runAction:action withKey:actionKey];
}
- (void)removeFromParent {
    SKAction *action = [self removeAnimation];
    if (action) {
        [self runAction:action completion:^{
            [super removeFromParent];
        }];
    }
    else {
        [super removeFromParent];
    }
}
#pragma mark - public methods
- (SKAction *)selectingAnimation {
    return nil;
}

- (SKAction *)normalizeAnimation {
    return nil;
}

- (SKAction *)removeAnimation {
    return nil;
}

- (SKAction *)removingAnimation {
    return nil;
}

#pragma mark - getters and setters
- (void)setState:(SIFloatingNodeState)state {
    if (_state != state) {
        _previousState = _state;
        _state = state;
        [self stateChaged];
    }
}
@end
