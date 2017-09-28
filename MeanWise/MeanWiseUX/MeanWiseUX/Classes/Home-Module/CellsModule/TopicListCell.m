//
//  TopicListCell.m
//  ExactResearch
//
//  Created by Hardik on 20/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "TopicListCell.h"

@implementation TopicListCell

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.clipsToBounds=YES;
        
        
        self.bgView=[[UIView alloc] initWithFrame:self.bounds];
        self.bgView.backgroundColor=[UIColor blackColor];
        [self.contentView addSubview:self.bgView];
        self.bgView.layer.cornerRadius=self.bounds.size.height/2;
        self.bgView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        self.nameLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.contentView addSubview:self.nameLBL];
        self.nameLBL.textColor=[UIColor whiteColor];
        self.nameLBL.textAlignment=NSTextAlignmentLeft;
        self.nameLBL.font=[UIFont fontWithName:k_fontSemiBold size:16];
        self.nameLBL.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        self.nameLBL.textColor=[UIColor colorWithWhite:1.0f alpha:0.5f];
//        self.bgView.backgroundColor=[self.topicColor colorWithAlphaComponent:0.5f];

        
    }
    return self;
}
-(void)setTopicColor:(UIColor *)topicColor
{
    self.nameLBL.textColor=[UIColor colorWithWhite:1.0f alpha:0.5f];
    self.bgView.backgroundColor=[topicColor colorWithAlphaComponent:0.5f];

    _topicColor=topicColor;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if(selected==false)
        {
            self.nameLBL.textColor=[UIColor colorWithWhite:1.0f alpha:0.5f];
            self.bgView.backgroundColor=[self.topicColor colorWithAlphaComponent:0.5f];

           
        }
        if(selected==true)
        {
            self.nameLBL.textColor=[UIColor whiteColor];
            self.bgView.backgroundColor=self.topicColor;
        }

        
    }];
    
    
   /* if(selected==true)
    {
        self.nameLBL.font=[UIFont fontWithName:k_fontSemiBold size:10];

    }
    else
    {
        self.nameLBL.font=[UIFont fontWithName:k_fontSemiBold size:16];

    }*/
    
    
}




@end
