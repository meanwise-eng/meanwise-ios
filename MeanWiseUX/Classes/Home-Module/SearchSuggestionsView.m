//
//  SearchSuggestionsView.m
//  MeanWiseUX
//
//  Created by Hardik on 07/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "SearchSuggestionsView.h"
#import "Constant.h"

@implementation SearchSuggestionsView

-(void)setTarget:(id)targetReceived OnOptionSelect:(SEL)func1;
{
    target=targetReceived;
    onSelectFunc=func1;
}
-(void)setUp
{
 
    optionsName=[NSArray arrayWithObjects:@"username",@"skill", nil];
    
    int btnHeight=((self.frame.size.height)/(optionsName.count))-4-(optionsName.count-1)*2;
    
    
   // self.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.4f];
    
    listOfOptions=[[NSMutableArray alloc] init];
    listOfOptionsLBL=[[NSMutableArray alloc] init];
    
    int btnLeftPadding=80;
    for(int i=0;i<optionsName.count;i++)
    {
        
        

        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = CGRectMake(0, 2*i+i*btnHeight, self.frame.size.width, btnHeight);
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:blurEffectView];
        
        blurEffectView.layer.cornerRadius=2;
        blurEffectView.clipsToBounds=YES;

        
        UIButton *optionBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 2*i+i*btnHeight, self.frame.size.width, btnHeight)];
        [self addSubview:optionBtn];
        [optionBtn setTitle:[optionsName objectAtIndex:i] forState:UIControlStateNormal];
        optionBtn.backgroundColor=[UIColor clearColor];
        optionBtn.tag=i;
        optionBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        optionBtn.contentEdgeInsets=UIEdgeInsetsMake(0, 0, 0,self.frame.size.width-btnLeftPadding);
        optionBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:14];
        

        [optionBtn addTarget:self action:@selector(optionSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *optionLBL=[[UILabel alloc] initWithFrame:CGRectMake(btnLeftPadding, 2*i+i*btnHeight, self.frame.size.width, btnHeight)];
        [self addSubview:optionLBL];
        optionLBL.font=[UIFont fontWithName:k_fontBold size:14];
        optionLBL.textColor=[UIColor whiteColor];

        optionLBL.userInteractionEnabled=false;
        
        [listOfOptionsLBL addObject:optionLBL];
        [listOfOptions addObject:optionBtn];
    }
    
    self.clipsToBounds=YES;
    
    [self setSearchString:@""];
    
    
}
-(void)setSearchString:(NSString *)searchTerm
{
    if([searchTerm isEqualToString:@""])
    {
    
        [self hideThisView];
        
    }
    else
    {
        [self showThisView];
    }
    
    for(int i=0;i<[listOfOptions count];i++)
    {
        UILabel *label=[listOfOptionsLBL objectAtIndex:i];
        
        NSString *optionStr=[NSString stringWithFormat:@" : \"%@\"",searchTerm];
        
        label.text=optionStr;
        
        //        [button setTitle:optionStr forState:UIControlStateNormal];
    }
    
}
-(void)hideThisView
{
    
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        self.alpha=0;
        
    } completion:^(BOOL finished) {
        self.hidden=true;
 
    }];
    

}
-(void)showThisView
{
    if(self.hidden==true)
    {
    self.hidden=false;
    self.alpha=0;

    
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        self.alpha=1;
        
    } completion:^(BOOL finished) {
        
    }];
    }

}
-(void)optionSelected:(UIButton *)senderBtn
{
    [target performSelector:onSelectFunc withObject:[NSNumber numberWithInt:(int)senderBtn.tag] afterDelay:0.01];
}
@end








