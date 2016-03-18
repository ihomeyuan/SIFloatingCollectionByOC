//
//  BubbleNode.h
//  SIFloatingCollectionByOC
//
//  Created by yurongde on 16/3/17.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "SIFloatingNode.h"

@interface BubbleNode : SIFloatingNode
/**
 *  初始化
 *
 *  @param radius
 *  @param index  在数组中的位置
 *
 *  @return
 */
+ (instancetype)initWithRadius:(CGFloat)radius;
@end
