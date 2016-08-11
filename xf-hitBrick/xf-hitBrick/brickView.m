//
//  brickView.m
//  xf-hitBrick
//
//  Created by 朱晓峰 on 16/8/8.
//  Copyright © 2016年 朱晓峰. All rights reserved.
//
//拿到挡板的frame
#import "brickView.h"

@implementation brickView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    startLocation=[[touches anyObject] locationInView:self];
    
    [[self superview] bringSubviewToFront:self];
}
//实时改变自身坐标
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    CGPoint point=[[touches anyObject] locationInView:self];
    CGRect frame=self.frame;
    

        frame.origin.x = frame.origin.x + (point.x-startLocation.x);
        
        self.frame=frame;
    
    
    
    
}

@end
