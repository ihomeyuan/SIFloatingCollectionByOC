//
//  SIFloatingNode.h
//  SIFloatingCollectionByOC
//
//  Created by yurongde on 16/3/17.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const removingKey = @"action.removing";/**< */
static NSString *const selectingKey = @"action.selecting";
static NSString *const normalizeKey = @"action.normalize";

typedef NS_ENUM(NSInteger,SIFloatingNodeState) {
    SIFloatingNode_Normal,
    SIFloatingNode_Selected,
    SIFloatingNode_Removing
};

@interface SIFloatingNode : SKShapeNode
@property (nonatomic,assign) SIFloatingNodeState state;/**< 当前状态*/
@property (nonatomic,assign) SIFloatingNodeState previousState;/**< 前一种状态*/


//给子类去重写
/**
 *  选择时动画
 *
 *  @return <#return value description#>
 */
- (SKAction *)selectingAnimation;
- (SKAction *)normalizeAnimation;
- (SKAction *)removeAnimation;
- (SKAction *)removingAnimation;


@end
