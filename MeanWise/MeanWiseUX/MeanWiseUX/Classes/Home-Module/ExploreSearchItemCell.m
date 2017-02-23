//
//  ExploreSearchItemCell.m
//  ExactResearch
//
//  Created by Hardik on 24/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//
#import "ExploreSearchItemCell.h"

@implementation ExploreSearchItemCell

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.clipsToBounds=YES;
        
       
        self.bgView=[[UIView alloc] initWithFrame:CGRectMake(0,1, self.frame.size.width, self.frame.size.height-2)];
        [self.contentView addSubview:self.bgView];
        self.bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        
        self.hashtagOrTopic=[[UILabel alloc] initWithFrame:CGRectMake(30, 1, self.frame.size.width, self.frame.size.height-2)];
        [self.contentView addSubview:self.hashtagOrTopic];
        self.hashtagOrTopic.text=@"%back";
        self.hashtagOrTopic.textColor=[UIColor whiteColor];
        self.hashtagOrTopic.textAlignment=NSTextAlignmentLeft;
        self.hashtagOrTopic.font=[UIFont fontWithName:k_fontSemiBold size:18];

        
        self.post_profilePhoto=[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 50, self.frame.size.height-20)];
        [self.contentView addSubview:self.post_profilePhoto];
        self.post_profilePhoto.image=[UIImage imageNamed:@"pqr1.jpg"];
        self.post_profilePhoto.contentMode=UIViewContentModeScaleAspectFill;
        self.post_profilePhoto.clipsToBounds=YES;
        
        self.post_UserNameLBL=[[UILabel alloc] initWithFrame:CGRectMake(30+50+10, 10, self.frame.size.width, 20)];
        [self.contentView addSubview:self.post_UserNameLBL];
        self.post_UserNameLBL.font=[UIFont fontWithName:k_fontBold size:13];
        self.post_UserNameLBL.textAlignment=NSTextAlignmentLeft;
        self.post_UserNameLBL.textColor=[UIColor whiteColor];
        self.post_UserNameLBL.numberOfLines=1;
        self.post_UserNameLBL.text=@"Mary Lee";
        
        self.post_textLBL=[[UILabel alloc] initWithFrame:CGRectMake(30+50+10,30, self.frame.size.width, 20)];
        [self.contentView addSubview:self.post_textLBL];
        self.post_textLBL.font=[UIFont fontWithName:k_fontSemiBold size:13];
        self.post_textLBL.textAlignment=NSTextAlignmentLeft;
        self.post_textLBL.textColor=[UIColor whiteColor];
        self.post_textLBL.numberOfLines=1;
        self.post_textLBL.text=@"Lorem ipsum dummy text.";
        
        self.post_topicNameLBL=[[UILabel alloc] initWithFrame:CGRectMake(30+50+10,50, self.frame.size.width, 20)];
        [self.contentView addSubview:self.post_topicNameLBL];
        self.post_topicNameLBL.font=[UIFont fontWithName:k_fontSemiBold size:13];
        self.post_topicNameLBL.textAlignment=NSTextAlignmentLeft;
        self.post_topicNameLBL.textColor=[UIColor whiteColor];
        self.post_topicNameLBL.numberOfLines=1;
        self.post_topicNameLBL.text=@"@sportsTea";
        
       
        
        self.post_channelNameLBL=[[UILabel alloc] initWithFrame:CGRectMake(30+50+10,70, self.frame.size.width, 20)];
        [self.contentView addSubview:self.post_channelNameLBL];
        self.post_channelNameLBL.font=[UIFont fontWithName:k_fontBold size:13];
        self.post_channelNameLBL.textAlignment=NSTextAlignmentLeft;
        self.post_channelNameLBL.textColor=[UIColor whiteColor];
        self.post_channelNameLBL.numberOfLines=1;
        self.post_channelNameLBL.text=@"Photography";
        

//
//        @property (nonatomic, strong) UILabel *channelNameLBL;
//
        
        
        
    }
    return self;
}
-(void)setType:(int)number
{
    if(number==0)
    {
      //  self.bgView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
        self.post_profilePhoto.frame=CGRectMake(5, 5, 50, self.frame.size.height-10);

        self.post_profilePhoto.hidden=false;
        self.post_UserNameLBL.hidden=false;
        self.post_channelNameLBL.hidden=false;
        self.post_topicNameLBL.hidden=false;
        self.post_textLBL.hidden=false;
                self.hashtagOrTopic.hidden=true;
    }
    else
    {
//        self.bgView.backgroundColor=[UIColor colorWithRed:(arc4random()%255)/255.0f green:(arc4random()%255)/255.0f blue:(arc4random()%255)/255.0f alpha:1.0f];
        self.hashtagOrTopic.frame=CGRectMake(30, 1, self.frame.size.width, self.frame.size.height-2);

      
        self.hashtagOrTopic.hidden=false;
        self.post_profilePhoto.hidden=true;
        self.post_UserNameLBL.hidden=true;
        self.post_channelNameLBL.hidden=true;
        self.post_topicNameLBL.hidden=true;
        self.post_textLBL.hidden=true;
    }
    
}



@end