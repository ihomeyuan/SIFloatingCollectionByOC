//
//  SIFloatingCollectionScene.h
//  SIFloatingCollectionByOC
//
//  Created by yurongde on 16/3/17.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SIFloatingCollectionScene;

@protocol SIFloatingCollectionSceneDelegate <NSObject>

- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene shouldSelectFloatingNodeAtIndex:(NSInteger)index;

- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene didSelectFloatingNodeAtIndex:(NSInteger)index;

- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene shouldDeselectFloatingNodeAtIndex:(NSInteger)index;

- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene didDeselectFloatingNodeAtIndex:(NSInteger)index;

- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene startedRemovingOfFloatingNodeAtIndex:(NSInteger)index;

- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene canceledRemovingOfFloatingNodeAtIndex:(NSInteger)index;

- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene shouldRemoveFloatingNodeAtIndex:(NSInteger)index;

- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene didRemoveFloatingNodeAtIndex:(NSInteger)index;

@end

//状态
typedef NS_ENUM(NSInteger, SIFloatingCollectionSceneMode) {
     SIFloatingCollectionSceneMode_Normal,
     SIFloatingCollectionSceneMode_Editing,
     SIFloatingCollectionSceneMode_Moving,
};

@interface SIFloatingCollectionScene : SKScene
@property (nonatomic) SKFieldNode *magneticField;
@property (nonatomic) NSMutableArray *floatingNodes;/**< 存储SIFloatingNode*/

@property (nonatomic,assign) NSTimeInterval timeToStartRemove;
@property (nonatomic,assign) NSTimeInterval timeToRemove;
@property (nonatomic,assign) BOOL allowEditing;
@property (nonatomic,assign) BOOL allowMultipleSelection;
@property (nonatomic,assign) BOOL restrictedToBounds;
@property (nonatomic,assign) CGFloat pushStrength;

@property (nonatomic,weak) id<SIFloatingCollectionSceneDelegate> floatingDelegate;

- (CGFloat)distanceBetweenPoints:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint;

- (void)removeFloatinNodeAtIndex:(NSInteger)index;
@end
