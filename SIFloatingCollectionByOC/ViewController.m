//
//  ViewController.m
//  SIFloatingCollectionByOC
//
//  Created by yurongde on 16/3/17.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "ViewController.h"
#import "BubblesScene.h"
#import "BubbleNode.h"
@interface ViewController ()<SIFloatingCollectionSceneDelegate>
@property (nonatomic) SKView *skView;/**< 游戏根视图*/
@property (nonatomic) BubblesScene *floatingCollectionScene;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.skView = [[SKView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.skView.backgroundColor = [SKColor whiteColor];
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    self.skView.ignoresSiblingOrder = YES;

    [self.view addSubview:self.skView];
    
    self.floatingCollectionScene = [[BubblesScene alloc]initWithSize:self.skView.bounds.size];
    self.floatingCollectionScene.topOffset = 64;
    self.floatingCollectionScene.floatingDelegate = self;
    [self.skView presentScene:self.floatingCollectionScene];
    
    
    for (int i=0; i < 10; i++) {
        CGFloat bubbleRadius = 40;
        
        if (i%2 == 0) {
            bubbleRadius = 60;
        }
        else if (i % 3 == 0) {
            bubbleRadius = 20;
        }
        
        BubbleNode *node = [BubbleNode initWithRadius:bubbleRadius];
        [self.floatingCollectionScene addChild:node];
        
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.floatingCollectionScene performCommitSelectionAnimation];
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i=0; i < 10; i++) {
            CGFloat bubbleRadius = 40;
            
            if (i%2 == 0) {
                bubbleRadius = 60;
            }
            else if (i % 3 == 0) {
                bubbleRadius = 20;
            }
            
            BubbleNode *node = [BubbleNode initWithRadius:bubbleRadius];
            [self.floatingCollectionScene addChild:node];
            
        }

    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - delegate

- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene shouldSelectFloatingNodeAtIndex:(NSInteger)index {
    return YES;
}
- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene shouldDeselectFloatingNodeAtIndex:(NSInteger)index {
    return YES;
}
- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene didSelectFloatingNodeAtIndex:(NSInteger)index {
    NSLog(@"select index=%d",index);
    return YES;
}
- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene didDeselectFloatingNodeAtIndex:(NSInteger)index {
    NSLog(@"deselect index= %d",index);
    return YES;
}
- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene shouldRemoveFloatingNodeAtIndex:(NSInteger)index {
    return YES;
}
- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene didRemoveFloatingNodeAtIndex:(NSInteger)index {
    NSLog(@"remove :%d",index);
    return YES;
}
@end
