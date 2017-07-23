//
//  HandsfreeBtn.m
//  Exacto
//
//  Created by Hardik on 23/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "HandsFreeBtn.h"

@implementation HandsFreeBtn

-(void)setTarget:(id)tReceived OnVideoStopCallBack:(SEL)callBack
{
    target=tReceived;
    videoStopCallBackFunc=callBack;
}
-(void)continueAnimation
{
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options: UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionBeginFromCurrentState
                     animations: ^(void)
    {
        circleView.alpha=0.6;
        
        
                     }
                     completion:NULL];

}

-(void)setUpWithTime:(float)timer
{
    duration=timer;
    status=0;
    circleView=[[UIView alloc] initWithFrame:self.bounds];
    circleView.backgroundColor=[UIColor redColor];
    circleView.layer.cornerRadius=self.bounds.size.width/2;
    circleView.layer.borderWidth=10;
    circleView.layer.borderColor=[UIColor colorWithWhite:1 alpha:0.5f].CGColor;
    [self addSubview:circleView];
    circleView.backgroundColor=[UIColor redColor];

    fullScreenBtn=[[UIButton alloc] initWithFrame:self.bounds];
    [self addSubview:fullScreenBtn];
    [fullScreenBtn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
  
    
}
-(void)startAnimation
{
    status=1;

    float arcWidth=5;
    UIColor *arcColor=[UIColor whiteColor];
    CGPoint center=circleView.center;
    float radius=self.bounds.size.width/2-2.5;
    BOOL clockwise=true;
    
    
    circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:-M_PI_2 endAngle:2 * M_PI - M_PI_2 clockwise:clockwise].CGPath;
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = arcColor.CGColor;
    circle.lineWidth = arcWidth;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = duration;
    animation.removedOnCompletion = YES;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [circle addAnimation:animation forKey:@"drawCircleAnimation"];
    
    [self.layer addSublayer:circle];

}
-(void)onClicked:(id)sender
{
    if(status==1)
    {
        status=2;
        [circle removeAllAnimations];
        
        [target performSelector:videoStopCallBackFunc withObject:nil afterDelay:0.0001];
        
        circleView.backgroundColor=[UIColor redColor];
    }
    NSLog(@"cancel");
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
- (UIBezierPath *)arcWithRoundedCornerAt:(CGPoint)center
                              startAngle:(CGFloat)startAngle
                                endAngle:(CGFloat)endAngle
                             innerRadius:(CGFloat)innerRadius
                             outerRadius:(CGFloat)outerRadius
                            cornerRadius:(CGFloat)cornerRadius
{
    CGFloat innerTheta = asin(cornerRadius / 2.0 / (innerRadius + cornerRadius)) * 2.0;
    CGFloat outerTheta = asin(cornerRadius / 2.0 / (outerRadius - cornerRadius)) * 2.0;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path addArcWithCenter:center
                    radius:innerRadius + cornerRadius
                startAngle:endAngle - innerTheta
                  endAngle:startAngle + innerTheta
                 clockwise:false];
    
    [path addArcWithCenter:center
                    radius:outerRadius - cornerRadius
                startAngle:startAngle + outerTheta
                  endAngle:endAngle - outerTheta
                 clockwise:true];
    
    [path closePath];
    
    return path;
}

@end
