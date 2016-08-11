//
//  ViewController.h
//  xf-hitBrick
//
//  Created by 朱晓峰 on 16/8/8.
//  Copyright © 2016年 朱晓峰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class brickView;
@interface ViewController : UIViewController

@property(nonatomic,assign)NSInteger level;
@property(nonatomic,assign)NSInteger numOfBricks;
@property(nonatomic,assign)NSInteger score;
@property(nonatomic,assign)double speed;
@property(nonatomic,assign)CGPoint moveDis;
@property(nonatomic,strong)UIImageView *ball;
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,strong)brickView * board;
@property(nonatomic,strong)NSMutableArray *bricks;


@end

