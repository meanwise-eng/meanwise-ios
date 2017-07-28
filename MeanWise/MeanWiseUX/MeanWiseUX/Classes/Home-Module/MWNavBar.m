//
//  MWNavBar.m
//  MeanWiseUX
//
//  Created by Hardik on 18/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "MWNavBar.h"
#import "DataSession.h"
#import "FTIndicator.h"
#import "APIObjects_NotificationObj.h"

@implementation MWNavBar

-(void)setUp
{
 
    self.backgroundColor=[UIColor clearColor];
    
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//    self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    self.blurEffectView.frame = self.bounds;
//    self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self addSubview:self.blurEffectView];
//    
    self.navDetailTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 26)];
    [self addSubview:self.navDetailTitle];
    self.navDetailTitle.center=CGPointMake(self.bounds.size.width/2, 20+65/2-10);
    self.navDetailTitle.text=@"Detail";
    self.navDetailTitle.textAlignment=NSTextAlignmentCenter;
    self.navDetailTitle.textColor=[UIColor blackColor];
    self.navDetailTitle.font=[UIFont fontWithName:k_fontSemiBold size:18];
    self.navDetailTitle.hidden=true;


    self.centerLogo=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 31, 26)];
    [self addSubview:self.centerLogo];
    [self.centerLogo setBackgroundImage:[UIImage imageNamed:@"MeanwiseLogo.png"] forState:UIControlStateNormal];
    
//    self.centerLogo.image=[UIImage imageNamed:@"MeanwiseLogo.png"];
    self.centerLogo.contentMode=UIViewContentModeScaleAspectFill;
    self.centerLogo.center=CGPointMake(self.bounds.size.width/2, 20+65/2-10);
    [self.centerLogo addTarget:self action:@selector(centerLogoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    

  
    
    
    self.clipsToBounds=YES;
    
    self.leftBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 30, 25, 25)];
    [self.leftBtn setShowsTouchWhenHighlighted:YES];
    [self.leftBtn addTarget:self action:@selector(userBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"userNavBtn.png"] forState:UIControlStateNormal];
    [self addSubview:self.leftBtn];
    [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:10];

    self.rightBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-25-10, 30, 25, 25)];
    [self.rightBtn setShowsTouchWhenHighlighted:YES];
    [self.rightBtn addTarget:self action:@selector(messageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"msgNavBtn.png"] forState:UIControlStateNormal];
    [self addSubview:self.rightBtn];
    [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:10];

    self.leftBtn.center=[self leftPosition];
    self.rightBtn.center=[self rightPosition];
    self.centerLogo.center=[self centerPostion];
    
    label=[[UILabel alloc] initWithFrame:CGRectMake(25/2,-10, 18, 18)];
    [self.rightBtn addSubview:label];
    label.adjustsFontSizeToFitWidth=YES;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor redColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont fontWithName:k_fontBold size:8];
    label.layer.cornerRadius=18/2;
    label.clipsToBounds=YES;
    
    
    [self setNotificationNumber:0];
   // [self setUpWatchForNotifications];

    [self hideForHomeScreen];
}
-(void)hideForHomeScreen
{
    self.leftBtn.hidden=true;
    self.rightBtn.hidden=true;
}
#pragma mark - Notification Watch

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)setUpWatchForNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkIfNewNotificationReceived)
                                                 name:@"NewNotificationDataReceived"
                                               object:nil];
    
}
-(void)checkIfNewNotificationReceived
{
    int no=[DataSession sharedInstance].noOfNewNotificationReceived.intValue;
    [self setNotificationNumber:no];
    
    
    
    
}

-(void)setNotificationNumber:(int)number
{
    if(number>0)
    {
        label.text=[NSString stringWithFormat:@"%d",number];
        label.hidden=false;
    }
    else
    {
        label.text=@"";
        label.hidden=true;
    }
    
}


#pragma mark - Notification Watch End



-(void)backBtnClicked:(id)sender
{

  
    
    [UIView animateWithDuration:0.5 animations:^{


        

        
    } completion:^(BOOL finished) {
        
        

    }];

}
-(void)hideBar:(BOOL)flag
{
}
-(void)messageBtnClicked:(id)sender
{
    [self setNotificationNumber:0];
    [DataSession sharedInstance].noOfNewNotificationReceived=[NSNumber numberWithInt:0];
    
  //  [self pushInto];
    
//    [self AddOneStack:@"Message"];
    [delegate performSelector:rightFunc withObject:nil afterDelay:0.01];
}
-(void)centerLogoBtnClicked:(id)sender
{
    [delegate performSelector:centerFunc withObject:nil afterDelay:0.01];
    
}
-(void)userBtnClicked:(id)sender
{
//    [self pushInto];

    [delegate performSelector:leftFunc withObject:nil afterDelay:0.01];

   // [self hideBar:true];

 //   [self AddOneStack:@"Settings"];
}
-(void)pushOut
{
    [UIView animateWithDuration:0.5 animations:^{
        
        
        self.backgroundColor=[UIColor clearColor];
        
        self.centerLogo.center=[self centerPostion];
        self.centerLogo.alpha=1;
        
        self.leftBtn.alpha=1;
        self.leftBtn.center=[self leftPosition];
        
        self.rightBtn.alpha=1;
        self.rightBtn.center=[self rightPosition];
        
        
        
    } completion:^(BOOL finished) {
        
        
        
    }];

    
}
-(void)comeIn
{
    self.navDetailTitle.center=[self rightPosition];
    self.navDetailTitle.alpha=0;
    self.leftBtn.alpha=0;
    self.leftBtn.center=[self centerPostion];
    self.rightBtn.alpha=0;
    self.rightBtn.center=[self rightrightPosition];
    
    [UIView animateKeyframesWithDuration:0.5f delay:0.0f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        
        self.navDetailTitle.center=[self centerPostion];
        self.navDetailTitle.alpha=1;
        self.leftBtn.alpha=1;
        self.leftBtn.center=[self leftPosition];
        self.rightBtn.alpha=1;
        self.rightBtn.center=[self rightPosition];
        
        
    } completion:^(BOOL finished) {
        
        self.backgroundColor=[UIColor whiteColor];

    }];

}
-(void)pushInto
{
    [UIView animateKeyframesWithDuration:0.5f delay:0.5f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        self.backgroundColor=[UIColor whiteColor];
        
        self.centerLogo.center=[self leftPosition];
        self.centerLogo.alpha=0;
        
        self.leftBtn.alpha=0;
        self.leftBtn.center=[self leftleftPosition];
        
        self.rightBtn.alpha=0;
        self.rightBtn.center=[self centerPostion];

        
    } completion:^(BOOL finished) {
        
    }];
    
   


}
-(void)AddOneStack:(NSString *)title
{
  
    
}
-(CGPoint)leftPosition
{
    return CGPointMake(10+25/2, 20+65/2-10);
}
-(CGPoint)rightPosition
{
    return CGPointMake(self.bounds.size.width-(10+25/2), 20+65/2-10);
}
-(CGPoint)leftleftPosition
{
    return CGPointMake(-self.bounds.size.width/2, 20+65/2-10);

}
-(CGPoint)rightrightPosition
{
    return CGPointMake(self.bounds.size.width*3/2, 20+65/2-10);
    
}



-(CGPoint)centerPostion
{
    return CGPointMake(self.bounds.size.width/2, 20+65/2-10);
}
-(void)setTarget:(id)target andCenterOpen:(SEL)func
{
    delegate=target;
    centerFunc=func;
    
}
-(void)setTarget:(id)target andRightOpen:(SEL)func1
{
    delegate=target;
    rightFunc=func1;
}
-(void)setTarget:(id)target andLeftOpen:(SEL)func2;
{
    delegate=target;
    leftFunc=func2;
}
@end
