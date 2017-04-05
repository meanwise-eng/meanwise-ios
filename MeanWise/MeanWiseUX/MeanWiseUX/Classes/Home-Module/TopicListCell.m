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
        self.nameLBL.textAlignment=NSTextAlignmentCenter;
        self.nameLBL.font=[UIFont fontWithName:k_fontSemiBold size:16];
        self.nameLBL.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
    }
    return self;
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
  if(selected==false)
  {
      self.nameLBL.textColor=[UIColor whiteColor];
      self.bgView.backgroundColor=self.topicColor;
  }
    if(selected==true)
    {
        self.nameLBL.textColor=self.topicColor;
        self.bgView.backgroundColor=[UIColor whiteColor];
    }
    
    
    
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
