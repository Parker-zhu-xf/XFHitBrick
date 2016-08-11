//
//  ViewController.m
//  xf-hitBrick
//
//  Created by 朱晓峰 on 16/8/8.
//  Copyright © 2016年 朱晓峰. All rights reserved.
//
//暂停两种方式，_speed设置，nstimer
#import "ViewController.h"
#import "brickView.h"

#define BRICKHIGHT 15
#define BRICKWIDTH 44

#define BOARDHIGHT 10
#define BOARDWIDTH 48
#define TOP 40

#define WIDTH (self.view.frame.size.width)
#define NUM ((NSInteger)(self.view.frame.size.width-20)/53)
static NSInteger ca=0;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentGrade;
@property (weak, nonatomic) IBOutlet UILabel *heightest;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UILabel *pauseLable;

@end

@implementation ViewController
- (void)puaseXF{
    self.timer.fireDate=[NSDate distantFuture];
}
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:_speed target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        _timer.fireDate=[NSDate distantFuture];
    }
   
    return _timer;
}
- (IBAction)startBtnClick:(id)sender {
//    self.startBtn.hidden=YES;
    _startBtn.selected=!_startBtn.selected;
    
    if (!_startBtn.selected) {
        [self puaseXF];
    }
    else{
        if (!_timer) {
            [self timer];
            self.ball.frame=CGRectMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0-20, 20, 20);
            [self.view addSubview:_ball];
            _board.frame=CGRectMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0, BOARDWIDTH, BOARDHIGHT);
        }
       
        
        
        
        _timer.fireDate=[NSDate dateWithTimeIntervalSinceNow:0];
    }
    
    
    
}
-(brickView *)board{
    if (!_board) {
        _board=[[brickView alloc] initWithImage:[UIImage imageNamed:@"2.png"]];
        //定义图像的用户交互作用属性值
        [_board setUserInteractionEnabled:YES];
        //定义弹板的坐标，尺寸
        _board.frame=CGRectMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0, BOARDWIDTH, BOARDHIGHT);
        [self.view addSubview:_board];
    }
    return _board;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _moveDis=CGPointMake(-3, -3);
    _speed=0.03;
    
    [self board];
    _ball=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3.png"]];

    _level=1; _score=0;
    self.rank.text=@"游戏级别：黄铜";
    self.currentGrade.text=[NSString stringWithFormat:@"现时得分: %ld",_score];
    self.heightest.text=[NSString stringWithFormat:@"最高成绩: %d",0];
    //调用显示游戏级数方法
    [self levelMap:self.level];
}

-(void)levelMap:(NSInteger)inlevel {
    UIImageView *brick;
    NSArray *arr=@[@"游戏级别：黄铜",@"游戏级别：白银",@"游戏级别：黄金",@"游戏级别：白金",@"游戏级别：钻石",@"游戏级别：大师",@"游戏级别：王者"];
    self.rank.text=arr[inlevel-1];
    [self brickNum:brick addLevel:inlevel];
   
    
}
-(void)brickNum:(UIImageView *)brick addLevel:(NSInteger)level{
    
    self.bricks=[NSMutableArray arrayWithCapacity:(level+2)*NUM];
    _speed-=0.003;
    self.numOfBricks=(level+2)*NUM;
    
    for (int i=0; i<(level+2); i++) {
        
        for (int j=0;j<NUM;j++) {
            
            brick=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]];
            brick.frame=CGRectMake(20+j*BRICKWIDTH+j*5, TOP+10+BRICKHIGHT*i+5*i, BRICKWIDTH, BRICKHIGHT);
            [self.view addSubview:brick];
            [self.bricks addObject:brick];
        }
    }
}
- (void)onTimer{
    
    float posx,posy;
    //球的中心坐标
    posx=self.ball.center.x;
    posy=self.ball.center.y;
    self.ball.center = CGPointMake(posx+self.moveDis.x, posy+self.moveDis.y);
    //球边界限制
    if (self.ball.center.x>WIDTH || self.ball.center.x<0 ) {
        _moveDis.x=-self.moveDis.x;
    }

    if ( _ball.center.y<TOP ) {
        _moveDis.y=-_moveDis.y;
    }
    
    NSInteger j=[_bricks count];
    for (int i=0; i<j; i++) {
        UIImageView *brick=(UIImageView *)[_bricks objectAtIndex:i];
        
        if (CGRectIntersectsRect(_ball.frame, brick.frame)&&[brick superview]) {
            _score+=100;
            [brick removeFromSuperview];
            //设置随机大头像
            if (rand()%5==0) {
                UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4.png"]];
                imageView.frame = CGRectMake(brick.frame.origin.x, brick.frame.origin.y, 48, 48);
                [self.view addSubview:imageView];
                [UIView animateWithDuration:5 animations:^{
                    imageView.frame = CGRectMake(brick.frame.origin.x, _board.frame.origin.y+20, 48, 48);
                    _score+=200;
                } completion:^(BOOL finished) {
                    [imageView removeFromSuperview];
                }];

            }
            _numOfBricks--;
            if ((_ball.center.y-16<brick.frame.origin.y+BRICKHIGHT || _ball.center.y+16>brick.frame.origin.y)
                && _ball.center.x>brick.frame.origin.x && _ball.center.x<brick.frame.origin.x+BRICKWIDTH) {
                _moveDis.y=-_moveDis.y;
            }else if (_ball.center.y>brick.frame.origin.y && _ball.center.y<brick.frame.origin.y+BRICKHIGHT
                      && (_ball.center.x+16>brick.frame.origin.x || _ball.center.x-16<brick.frame.origin.x+BRICKWIDTH)){
                _moveDis.x=-_moveDis.x;
            }else{
                _moveDis.x=-_moveDis.x;
                _moveDis.y=-_moveDis.y;
            }
            break;
        }
    }
    if (_numOfBricks==0) {
        if (_level<NUM) {
            [_ball removeFromSuperview];
            [_timer invalidate];
//            [self puaseXF];
            _level++;
            _speed=_speed-0.003;

            [self levelMap:_level];
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"K.O."
                                                          message:@"恭喜！你赢了" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
            self.heightest.text=[NSString stringWithFormat:@"最高成绩: %ld",[self grade]];
            
        }
    }
    if (CGRectIntersectsRect(_ball.frame, _board.frame)) {
        if (_ball.center.x>_board.frame.origin.x&&_ball.center.x<_board.frame.origin.x+BOARDWIDTH) {
            _moveDis.y=-_moveDis.y;
        }else {
            _moveDis.x=-_moveDis.x;
            _moveDis.y=-_moveDis.y;
        }
    }else{
        if (_ball.center.y>_board.center.y){
            [_ball removeFromSuperview];
            [_timer invalidate];
            _timer=NULL;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Game over"message:@"你输了，继续获取更好的成绩..." delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
            [alert show];
            
            self.heightest.text=[NSString stringWithFormat:@"最高成绩: %ld",[self grade]];
        }
    }
    self.currentGrade.text=[NSString stringWithFormat:@"现时得分: %ld",_score];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) buttonIndex{
    NSString *b=[alertView buttonTitleAtIndex:buttonIndex];
    
    if([b isEqualToString:@"确定"]){
        self.startBtn.hidden=NO;
        //点击确定之后得分归零
        _score=0;
        _startBtn.selected=!_startBtn.selected;
        [self levelMap:_level];
        self.currentGrade.text=[NSString stringWithFormat:@"现时得分: %ld",_score];
    }
    
    
}

-(NSInteger)grade{
    
    if (ca==0) {
        ca=_score;
    }
    else{
        ca=ca>=_score?ca:_score;
    }
    
    return ca;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
