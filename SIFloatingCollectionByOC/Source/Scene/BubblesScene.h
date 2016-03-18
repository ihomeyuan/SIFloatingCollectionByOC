//
//  BubblesScene.h
//  SIFloatingCollectionByOC
//
//  Created by yurongde on 16/3/17.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "SIFloatingCollectionScene.h"

@interface BubblesScene : SIFloatingCollectionScene
@property (nonatomic,assign) CGFloat bottomOffset;
@property (nonatomic,assign) CGFloat topOffset;
//移除
- (void)performCommitSelectionAnimation;
@end
