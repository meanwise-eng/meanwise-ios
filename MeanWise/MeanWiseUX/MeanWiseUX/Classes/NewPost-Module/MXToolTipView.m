//
//  MXToolTipView.m
//  MeanWiseUX
//
//  Created by Hardik on 08/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "MXToolTipView.h"
#import "Constant.h"

@implementation MXToolTipView

-(void)setPointDownAt:(CGPoint)point
{
    int height=mainView.frame.size.height;
    
    float yPos=point.y-height;
    mainView.frame=CGRectMake(mainView.frame.origin.x,yPos, mainView.frame.size.width, height);
    
    
}
-(void)setUp
{
    mainView=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:mainView];
    self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    
    
    bubbleView=[[UIView alloc] init];
    [mainView addSubview:bubbleView];
    bubbleView.backgroundColor=[UIColor blueColor];
    bubbleView.layer.cornerRadius=10;
    bubbleView.clipsToBounds=YES;
    
    tipLabel=[[UILabel alloc] init];
    tipLabel.font=[UIFont fontWithName:k_fontBold size:14];
    tipLabel.text=@"Press and hold to record video or tap once to take photo.";
    [mainView addSubview:tipLabel];
    tipLabel.textColor=[UIColor whiteColor];
    
    tipLabel.numberOfLines=0;
    
    tipLabel.textAlignment=NSTextAlignmentCenter;
    
    int padding=30;
    CGSize size=[tipLabel sizeThatFits:CGSizeMake(300, 300)];
    
    
    tipLabel.frame=CGRectMake(padding/2, +padding/2, size.width, size.height);
    bubbleView.frame=CGRectMake(0, 0, size.width+padding, size.height+padding);
    
    
    mainView.frame=bubbleView.frame;
    

    arrowView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [mainView addSubview:arrowView];
    arrowView.backgroundColor=[UIColor blueColor];
    arrowView.transform=CGAffineTransformMakeRotation(M_PI/4);
    arrowView.center=CGPointMake(mainView.frame.size.width/2, mainView.frame.size.height);


    mainView.center=self.center;

    [UIView animateWithDuration:1.0 animations:^{
        
        self.alpha=1;
    }];
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [arrowView removeFromSuperview];
        [bubbleView removeFromSuperview];
        [tipLabel removeFromSuperview];
        
        arrowView=nil;
        bubbleView=nil;
        tipLabel=nil;
        
        
        [self removeFromSuperview];

        
    }];
}


@end
