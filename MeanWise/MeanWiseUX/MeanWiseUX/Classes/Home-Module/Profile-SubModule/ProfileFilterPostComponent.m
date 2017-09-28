//
//  ProfileFilterPostComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 12/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ProfileFilterPostComponent.h"
#import "APIObjects_FeedObj.h"
#import "Constant.h"

@implementation ProfileFilterPostComponent

-(void)setTarget:(id)delegateReceived ApplyFilter:(SEL)func1;
{
    
    delegate=delegateReceived;
    onApplyFilter=func1;
    
    
}
-(void)setUp
{
    self.backgroundColor=[UIColor clearColor];

    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:blurEffectView];
    
    
    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 50)];
    [titleLabel setText:@"Filter"];
    titleLabel.font=[UIFont fontWithName:k_fontBold size:15];
    [self addSubview:titleLabel];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    
    
    closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 60, 40, 40)];
    [closeBtn setShowsTouchWhenHighlighted:YES];
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [self addSubview:closeBtn];
    
    closeBtn.center=CGPointMake(self.frame.size.width-10-25/2, 20+65/2-10);

    
    [closeBtn setShowsTouchWhenHighlighted:YES];


}
-(void)closeBtnClicked:(id)sender
{
    
    [delegate performSelector:onApplyFilter withObject:nil afterDelay:0.001];
    
}

-(void)calculateFilterStats:(NSMutableArray *)dataRecords
{
    allDataRecords=dataRecords;
    
    postFilterBtns=[[NSMutableArray alloc] init];

    NSMutableArray *arrayOfInterests=[[NSMutableArray alloc] init];
    
    
    for(int i=0;i<dataRecords.count;i++)
    {
        
        APIObjects_FeedObj *obj=[dataRecords objectAtIndex:i];
        [arrayOfInterests addObject:obj.interest_name];
        
    }
    
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrayOfInterests];
    
    NSArray *uniqueArray = orderedSet.array;
    
    
    
    allRelatedInterests=[[NSMutableArray alloc] initWithObjects:@"All", nil];
    
    [allRelatedInterests addObjectsFromArray:uniqueArray];
    
    
    for(int i=0;i<allRelatedInterests.count;i++)
    {
        
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 100+i*50, self.frame.size.width, 50)];
        [self addSubview:button];
        button.tag=i;
        button.titleLabel.font=[UIFont fontWithName:k_fontRegular size:18];
        [button setTitle:[allRelatedInterests objectAtIndex:i] forState:UIControlStateNormal];
        [button setShowsTouchWhenHighlighted:YES];
        [button addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
}
-(void)filterButtonClicked:(UIButton *)sender
{
    
    NSString *channelName=[allRelatedInterests objectAtIndex:sender.tag];
    
    NSMutableArray *array=[[NSMutableArray alloc] init];
    
    if([channelName isEqualToString:@"All"])
    {
        [array addObjectsFromArray:allDataRecords];
    }
    else
    {
        
        for(int i=0;i<[allDataRecords count];i++)
        {

            APIObjects_FeedObj *obj=[allDataRecords objectAtIndex:i];
            
            if([obj.interest_name isEqualToString:channelName])
            {
                [array addObject:obj];
            }
            

        }
        
        
    }
    
    
    NSLog(@"%@",[allRelatedInterests objectAtIndex:sender.tag]);
    [delegate performSelector:onApplyFilter withObject:[NSArray arrayWithArray:array] afterDelay:0.001];

}

@end
