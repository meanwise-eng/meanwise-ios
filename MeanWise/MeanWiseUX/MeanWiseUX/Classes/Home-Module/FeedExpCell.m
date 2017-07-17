//
//  feedExpCell.m
//  MeanWiseUX
//
//  Created by Hardik on 03/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//


#import "FeedExpCell.h"

@implementation FeedExpCell

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.clipsToBounds=YES;
        
//        self.backgroundColor=[UIColor whiteColor];
        
        self.postIMGVIEW=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.postIMGVIEW];
        self.postIMGVIEW.image=[UIImage imageNamed:@"CoverPhoto.jpg"];
        self.postIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
        self.postIMGVIEW.clipsToBounds=YES;
        self.layer.cornerRadius=3;
        
        self.shadowImage=[[UIImageView alloc] initWithFrame:self.profileIMGVIEW.frame];
        self.shadowImage.image=[UIImage imageNamed:@"BlackShadow.png"];
        self.shadowImage.contentMode=UIViewContentModeScaleAspectFill;
        [self addSubview:self.shadowImage];
        self.shadowImage.alpha=0.3;
        self.shadowImage.clipsToBounds=YES;
        self.shadowImage.transform=CGAffineTransformMakeScale(1, -1);
        
        self.profileIMGVIEW=[[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
        [self addSubview:self.profileIMGVIEW];
        self.profileIMGVIEW.image=[UIImage imageNamed:@"CoverPhoto.jpg"];
        self.profileIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
        self.profileIMGVIEW.clipsToBounds=YES;
        self.profileIMGVIEW.layer.cornerRadius=30;
        
        self.nameLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
        [self addSubview:self.nameLBL];
        self.nameLBL.text=@"Marry Lee";
        self.nameLBL.textColor=[UIColor whiteColor];
        self.nameLBL.textAlignment=NSTextAlignmentLeft;
        self.nameLBL.font=[UIFont fontWithName:k_fontSemiBold size:15];
        
        
        self.profLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
        [self addSubview:self.profLBL];
        self.profLBL.text=@"Photographer";
        self.profLBL.textColor=[UIColor whiteColor];
        self.profLBL.textAlignment=NSTextAlignmentLeft;
        self.profLBL.font=[UIFont fontWithName:k_fontSemiBold size:15];


        
        self.nameLBL.frame=CGRectMake(15+65+10,25, 200, 20);
        self.profLBL.frame=CGRectMake(15+65+10,45, 200, 20);

        
        
        self.statusLBL=[[UILabel alloc] initWithFrame:CGRectMake(15, self.frame.size.height-200, self.frame.size.width-30, 80)];
        [self addSubview:self.statusLBL];
        self.statusLBL.text=@"Travelling arround Southern Europe";
        self.statusLBL.textColor=[UIColor whiteColor];
        self.statusLBL.textAlignment=NSTextAlignmentLeft;
        self.statusLBL.font=[UIFont fontWithName:k_fontSemiBold size:18];
        self.statusLBL.numberOfLines=2;
        
        
        
        
        self.tagName=[[UILabel alloc] initWithFrame:CGRectMake(15, self.frame.size.height-100, 40, 15)];
        [self addSubview:self.tagName];
        self.tagName.text=@"Travel";
        self.tagName.textColor=[UIColor whiteColor];
        self.tagName.textAlignment=NSTextAlignmentLeft;
        self.tagName.font=[UIFont fontWithName:k_fontSemiBold size:12];
        
        self.timeLBL=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-40-15, self.frame.size.height-100, 40, 15)];
        [self addSubview:self.timeLBL];
        self.timeLBL.text=@"2 hrs";
        self.timeLBL.textColor=[UIColor whiteColor];
        self.timeLBL.textAlignment=NSTextAlignmentRight;
        self.timeLBL.font=[UIFont fontWithName:k_fontBold size:12];

        
        
        self.likeCountLBL=[[UILabel alloc] initWithFrame:CGRectMake(15, self.frame.size.height-60, 40, 15)];
        [self addSubview:self.likeCountLBL];
        self.likeCountLBL.text=@"12";
        self.likeCountLBL.textColor=[UIColor whiteColor];
        self.likeCountLBL.textAlignment=NSTextAlignmentCenter;
        self.likeCountLBL.font=[UIFont fontWithName:k_fontSemiBold size:11];
        
        
        self.commentCountLBL=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-20, self.frame.size.height-60, 40, 15)];
        [self addSubview:self.commentCountLBL];
        self.commentCountLBL.text=@"3";
        self.commentCountLBL.textColor=[UIColor whiteColor];
        self.commentCountLBL.textAlignment=NSTextAlignmentCenter;
        self.commentCountLBL.font=[UIFont fontWithName:k_fontSemiBold size:11];
        

        
        self.likeBtn=[[UIButton alloc] initWithFrame:CGRectMake(15, self.frame.size.height-50, 40, 40)];
//        [self.likeBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        [self addSubview:self.likeBtn];
        
        
        self.commentBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-20, self.frame.size.height-50, 40, 40)];
 //       [self.commentBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.commentBtn setBackgroundImage:[UIImage imageNamed:@"comments.png"] forState:UIControlStateNormal];
        [self addSubview:self.commentBtn];
        
        self.shareBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-15-40, self.frame.size.height-50, 40, 40)];
//        [self.shareBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [self addSubview:self.shareBtn];

        [self hasMedia:arc4random()%2];
        
    }
    return self;
}
-(void)hasMedia:(BOOL)flag
{
    if(flag==false)
    {
        self.commentCountLBL.textColor=[UIColor colorWithRed:0.53 green:0.62 blue:0.66 alpha:1.00];
        self.likeCountLBL.textColor=[UIColor colorWithRed:0.53 green:0.62 blue:0.66 alpha:1.00];
        self.nameLBL.textColor=[UIColor blackColor];
        self.tagName.textColor=[UIColor colorWithRed:0.53 green:0.62 blue:0.66 alpha:1.00];
        self.statusLBL.textColor=[UIColor colorWithRed:0.53 green:0.62 blue:0.66 alpha:1.00];
        self.nameLBL.textColor=[UIColor blackColor];
        self.profLBL.textColor=[UIColor colorWithRed:0.53 green:0.62 blue:0.66 alpha:1.00];
        self.timeLBL.textColor=[UIColor colorWithRed:0.53 green:0.62 blue:0.66 alpha:1.00];
        self.shadowImage.hidden=true;
        self.postIMGVIEW.hidden=true;
        self.backgroundColor=[UIColor whiteColor];
        
        self.statusLBL.frame=CGRectMake(15, self.frame.size.height-300, self.frame.size.width-30, 150);

        self.statusLBL.font=[UIFont fontWithName:k_fontSemiBold size:30];
        self.statusLBL.adjustsFontSizeToFitWidth=YES;

        [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"blackShare.png"] forState:UIControlStateNormal];
        [self.commentBtn setBackgroundImage:[UIImage imageNamed:@"blackComments.png"] forState:UIControlStateNormal];
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"blackLike.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        self.commentCountLBL.textColor=[UIColor whiteColor];
        self.likeCountLBL.textColor=[UIColor whiteColor];
        self.nameLBL.textColor=[UIColor whiteColor];
        self.tagName.textColor=[UIColor whiteColor];
        self.statusLBL.textColor=[UIColor whiteColor];
        self.nameLBL.textColor=[UIColor whiteColor];
        self.profLBL.textColor=[UIColor whiteColor];
        self.timeLBL.textColor=[UIColor whiteColor];
        self.shadowImage.hidden=false;
        self.postIMGVIEW.hidden=false;
        self.backgroundColor=[UIColor whiteColor];
        
        self.statusLBL.frame=CGRectMake(15, self.frame.size.height-200, self.frame.size.width-30, 80);
        
        self.statusLBL.font=[UIFont fontWithName:k_fontSemiBold size:15];
        self.statusLBL.adjustsFontSizeToFitWidth=YES;

        
        [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [self.commentBtn setBackgroundImage:[UIImage imageNamed:@"comments.png"] forState:UIControlStateNormal];
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
    }
    
    
}



@end



