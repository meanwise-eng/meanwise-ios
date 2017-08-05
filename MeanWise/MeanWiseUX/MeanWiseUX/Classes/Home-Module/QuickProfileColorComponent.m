//
//  NotificationsComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 05/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "QuickProfileColorComponent.h"
#import "ProfileCompleteCell.h"
#import "CompleteProfileItem.h"
#import "DataSession.h"

#import "EditBirthdayComponent.h"
#import "EditIntroBioComponent.h"
#import "EditLocationComponent.h"
#import "EditStoryComponent.h"


#import "EditPCComponent.h"
#import "EditSCComponent.h"
#import "UIColor+Hexadecimal.h"
#import "ViewController.h"

@implementation QuickProfileColorComponent

-(void)setTarget:(id)target andBackBtnFunc:(SEL)func1;
{
    delegate=target;
    backBtnClickedFunc=func1;
}
-(void)setUp:(NSString *)selectC;
{
    selectedColor=selectC;
    
    
    mainColorArray=[NSArray arrayWithObjects:
                    @"#66CCFF",
                    @"#FF5252",
                    @"#E040FB",
                    @"#00E676",
                    @"#536DFE",
                    @"#FF4081",
                    @"#FFD740",
                    @"#FFAB40",
                    @"#64FFDA",
                    @"#7C4DFF",
                    @"#448AFF",
                    @"#AEEA00",
                    @"#607D8B",
                    @"#757575",
                    @"#8D6E63",
                    @"#689F38",
                    @"#CD567C",
                    @"#6E6BD9",
                    @"#3E9AC3",
                    @"#A33CB2",
                    @"#EA6362",
                    @"#F3C67B",
                    @"#2BC7B0",
                    @"#049FE5",
                    
                    
                    
                    nil];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:blurEffectView];
    
    UILabel *footer = [[UILabel alloc]initWithFrame:CGRectMake(20, self.frame.size.height-50, self.bounds.size.width -40, 20)];
    footer.text = @"Choose a color from the palette.";
    footer.textColor = [UIColor whiteColor];
    footer.font = [UIFont fontWithName:k_fontRegular size:14];
    footer.textAlignment = NSTextAlignmentLeft;
    [self addSubview:footer];
    
    backBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 60, 40, 40)];
    [backBtn setShowsTouchWhenHighlighted:YES];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    
    backBtn.center=CGPointMake(self.frame.size.width-10-25/2, 20+65/2-10);
    
    float w=[self bounds].size.width;
    w=(w-40)/4;
    
    allButtons=[[NSMutableArray alloc] init];
    int coloNo=0;
    for(int i=0;i<6;i++)
    {
        
        for(int j=0;j<4;j++)
        {
            
            UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(20+w*j, 90+w*i, w, w)];
            [self addSubview:button];
            button.backgroundColor=[UIColor colorWithHexString:[self colorProfileColor:coloNo]];
            
            if([[self colorProfileColor:coloNo] isEqualToString:selectedColor])
            {
                button.layer.borderWidth=5;
                button.layer.borderColor=[UIColor whiteColor].CGColor;
                button.transform=CGAffineTransformMakeScale(0.7, 0.7);

            }
            else
            {
                button.transform=CGAffineTransformMakeScale(0.6, 0.6);

            }

            
            button.clipsToBounds=YES;
            button.layer.cornerRadius=w/2;
            button.tag=coloNo;
            [allButtons  addObject:button];
            [button addTarget:self action:@selector(profileColorSelected:) forControlEvents:UIControlEventTouchUpInside];
            coloNo++;
        }
    }
    
    

}
-(void)profileColorSelected:(UIButton *)sender
{
    [self resetAllButtons:sender];
    selectedColor=[mainColorArray objectAtIndex:sender.tag];
   // self.backgroundColor=[UIColor colorWithHexString:[mainColorArray objectAtIndex:sender.tag]];
    NSLog(@"%@",[mainColorArray objectAtIndex:sender.tag]);
    
//    NSString *color=[mainColorArray objectAtIndex:sender.tag];

    
}
-(void)resetAllButtons:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        for(int i=0;i<allButtons.count;i++)
        {
            UIButton *button=[allButtons objectAtIndex:i];
            if(button!=sender)
            {
                button.layer.borderWidth=0;
                button.transform=CGAffineTransformMakeScale(0.6, 0.6);

            }
            
        }
        
        sender.layer.borderWidth=5;
        sender.layer.borderColor=[UIColor whiteColor].CGColor;
        sender.transform=CGAffineTransformMakeScale(0.7, 0.7);

    }];
  

}

-(NSString *)colorProfileColor:(int)number
{
    
    return [mainColorArray objectAtIndex:number];
}


-(void)backBtnClicked:(id)sender
{
    [AnalyticsMXManager PushAnalyticsEventAction:@"Profile - Color Updated"];

        NSDictionary *dict=@{
                             @"profile_background_color":selectedColor,
                             };
    
        UINavigationController *vc=(UINavigationController *)[Constant topMostController];
        ViewController *t=(ViewController *)vc.topViewController;
        [t updateProfileWithDict:dict];

    [delegate performSelector:backBtnClickedFunc withObject:selectedColor afterDelay:0.01];
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.frame=CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}


@end
