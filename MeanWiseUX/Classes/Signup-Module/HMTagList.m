//
//  HMTagList.m
//  MeanWiseUX
//
//  Created by Hardik on 05/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "HMTagList.h"


@implementation HMTagList

-(void)setUp
{

    arrayTags=[[NSMutableArray alloc] init];
    tagUILabel=[[NSMutableArray alloc] init];
    
  //  [arrayTags addObject:@"javascript"];
//    
//    [arrayTags addObject:@"javascript"];
//    [arrayTags addObject:@"xcode"];
//    
//    [arrayTags addObject:@"javascript"];
//    [arrayTags addObject:@"xcode"];
//    
//    [arrayTags addObject:@"xcode"];
//    
    
    
    
    
    
    [self updateUI];
    
}
-(NSArray *)getNumberOfTagsSelected
{
    return arrayTags;
}
-(void)addNewTag:(NSString *)tag
{
    [arrayTags addObject:tag];
    [self updateUI];
}
-(void)updateUI
{
    [[self subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [tagUILabel removeAllObjects];
    
    
    float x=0;
    float y=-50;
    
    for(int i=0;i<[arrayTags count];i++)
    {
        
        if(i%2==0)
        {
            y=y+50;
            x=0;
        }
        
        HMTagLabel *tag=[[HMTagLabel alloc] initWithFrame:CGRectMake(x, y, 200, 40)];
        [tag setUpString:[[arrayTags objectAtIndex:i] valueForKey:@"text"] withHeight:40];
        [self addSubview:tag];
        [tag setDelegate:self andFunc:@selector(tagRemoved:)];
        
        
        CGRect getFrame=[tag getFrame];
        tag.frame=CGRectMake(x, y, getFrame.size.width+55, getFrame.size.height);
        
        x=x+getFrame.size.width+55+10;
        
        
        
        
    }
    
    
}
-(void)tagRemoved:(NSString *)string
{
    for(int i=0;i<[arrayTags count];i++)
    {
        if([[[arrayTags objectAtIndex:i] valueForKey:@"text"] isEqualToString:string])
        {
            [arrayTags removeObjectAtIndex:i];
            break;

        }
    }
    
   // [arrayTags removeObject:string];
    [self updateUI];

}


@end

@implementation HMTagLabel

-(void)setUpString:(NSString *)string withHeight:(int)height
{
    tagString=string;
    
    label=[[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:label];
    label.textAlignment=NSTextAlignmentRight;
    label.font=[UIFont fontWithName:k_fontRegular size:17];

    label.text=[NSString stringWithFormat:@"   %@",string];
    label.numberOfLines = 0; // allows label to have as many lines as needed
    [label sizeToFit];
    
    label.frame=CGRectMake(10, 10, label.frame.size.width, label.frame.size.height);
    
    
    NSLog(@"Label's frame is: %@", NSStringFromCGRect(label.frame));
    label.textColor=[UIColor whiteColor];
    
    self.backgroundColor=[UIColor colorWithRed:64/255.0f green:196/255.0f blue:255/255.0f alpha:1.0f];
    
    
    self.frame=CGRectMake(0, 0, label.frame.size.width, height);
    
    self.layer.cornerRadius=height/2;
    self.clipsToBounds=YES;
    
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(label.frame.size.width+10, 0, height, height)];
    lbl.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.0f];
    [self addSubview:lbl];
    lbl.text=@"X";
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.textColor=[UIColor whiteColor];
    lbl.font=[UIFont fontWithName:k_fontRegular size:17];

    btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, label.frame.size.width+height+10, height)];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(removeThisTag:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
-(void)setDelegate:(id)sender andFunc:(SEL)func;
{
    delegate=sender;
    selector=func;
    
}
-(void)removeThisTag:(id)sender
{
    [delegate performSelector:selector withObject:tagString afterDelay:0.1];
    
}
-(CGRect)getFrame
{
    return self.frame;
}



@end
