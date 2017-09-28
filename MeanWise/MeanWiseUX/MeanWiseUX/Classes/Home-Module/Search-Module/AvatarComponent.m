//
//  AvatarComponent.m
//  MeanWiseRedesignHelper
//
//  Created by Hardik on 31/08/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "UIColor+Hexadecimal.h"
#import "AvatarComponent.h"


@implementation AvatarComponent

-(void)setUp:(NSString *)avatarPath andNo:(int)no;
{
    int padding=8;
    
    isHiddenFlag=false;
    
    bgOverLay=[[UIView alloc] initWithFrame:self.bounds];
    [bgOverLay setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bgOverLay];
    bgOverLay.alpha=0;
    bgOverLay.layer.cornerRadius=self.frame.size.width/2;
    
    bgOverLay.hidden=true;
    
    CGRect rectWithPadding=CGRectMake(padding, padding, self.bounds.size.width-padding*2, self.bounds.size.height-padding*2);
    
    profileImgView=[[UIImageHM alloc] initWithFrame:rectWithPadding];
    [self addSubview:profileImgView];

    profileImgView.layer.cornerRadius=rectWithPadding.size.width/2;
    profileImgView.clipsToBounds=YES;
    
    self.userInteractionEnabled=false;

    
  
    
    [self startAnimation];

}
-(void)setAnimationWithHide:(BOOL)flag
{

    
    if(flag==true && isHiddenFlag==false)
    {
        profileImgView.hidden=true;

    
//        [self addSplash];
        [self stopAnimations];
        
        
    }
    else if(flag==false && isHiddenFlag==true)
    {
        profileImgView.hidden=false;
        
        [self addSplash];
        [self startAnimation];

        
        
    }

    isHiddenFlag=flag;
}
-(void)addSplash
{
    bgOverLay.hidden=false;

    bgOverLay.alpha=1;
    
        [UIView animateWithDuration:0.5 animations:^{
            
            bgOverLay.alpha=0;
            
        } completion:^(BOOL finished) {
            
            bgOverLay.hidden=true;

        }];
        
}
-(void)stopAnimations
{
    NSDictionary *newActions = @{
                                 @"onOrderIn": [NSNull null],
                                 @"onOrderOut": [NSNull null],
                                 @"sublayers": [NSNull null],
                                 @"contents": [NSNull null],
                                 @"bounds": [NSNull null]
                                 };
    
    profileImgView.layer.actions = newActions;
    
}
-(void)setURLString:(NSString *)path andUserId:(NSString *)uIdStr withColorString:(NSString *)color;
{
    userId=uIdStr;
    [profileImgView setUp:path];
    bgOverLay.backgroundColor=[UIColor colorWithHexString:color];
    
}
-(NSString *)getUserIdStr
{
    return userId;
}
-(void)clicked:(id)sender
{
    profileImgView.alpha=0;
    [UIView animateWithDuration:0.5 animations:^{
        profileImgView.alpha=1;
    }];
}
-(void)startAnimation
{
    int padding=8;


    float shakeRadius=padding*0.8;
    float startAngle=(arc4random()%5)+0.5f;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if(arc4random()%2==0)
    {
        [path moveToPoint:profileImgView.center];
        [path addLineToPoint:CGPointMake(profileImgView.center.x-shakeRadius, profileImgView.center.x)];
        [path addLineToPoint:CGPointMake(profileImgView.center.x+shakeRadius, profileImgView.center.x)];
    }
    else
    {
        [path moveToPoint:profileImgView.center];
        [path addLineToPoint:CGPointMake(profileImgView.center.x, profileImgView.center.x-shakeRadius)];
        [path addLineToPoint:CGPointMake(profileImgView.center.x, profileImgView.center.x+shakeRadius)];
    }
    
    //   [path addArcWithCenter:profileImgView.center radius:shakeRadius startAngle:startAngle endAngle:M_PI*2 clockwise:YES];
    
    CAKeyframeAnimation *animatePosition = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animatePosition.path = [path CGPath];
    animatePosition.duration = 4.0f;
    animatePosition.autoreverses = YES;
    animatePosition.repeatCount = HUGE_VALF;
    [profileImgView.layer addAnimation:animatePosition forKey:@"position"];
    
}
@end

