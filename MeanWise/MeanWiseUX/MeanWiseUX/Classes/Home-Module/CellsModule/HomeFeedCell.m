//
//  HomeFeedCell.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "DataSession.h"
#import "HomeFeedCell.h"

@implementation HomeFeedCell


-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        
        liked=0;
        self.clipsToBounds=YES;
        

        self.postIMGVIEW=[[UIImageHM alloc] initWithFrame:CGRectZero];
        //  self.postIMGVIEW.image=[UIImage imageNamed:@"post_3.jpeg"];
        self.postIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
        [self addSubview:self.postIMGVIEW];
        
        
        
        self.shadowImage=[[UIImageView alloc] initWithFrame:CGRectZero];
         self.shadowImage.image=[UIImage imageNamed:@"fullpostshadow.png"];
         self.shadowImage.contentMode=UIViewContentModeScaleAspectFill;
         [self addSubview:self.shadowImage];
         self.shadowImage.alpha=0.8;
         
        
      

        
        
        self.statusLBL=[[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:self.statusLBL];
        self.statusLBL.text=@"Lorem Ipsum dummy text of the printing and typesettings industry.";
        self.statusLBL.textColor=[UIColor whiteColor];
        self.statusLBL.textAlignment=NSTextAlignmentLeft;
        self.statusLBL.font=[UIFont fontWithName:k_fontRegular size:17];
        self.statusLBL.numberOfLines=2;
        
        
        
        
        
        self.tagName=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
        [self addSubview:self.tagName];
        self.tagName.text=@"Wild Life";
        self.tagName.textColor=[UIColor whiteColor];
        self.tagName.textAlignment=NSTextAlignmentLeft;
        self.tagName.font=[UIFont fontWithName:k_fontSemiBold size:14];
        
        
        self.timeLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
        [self addSubview:self.timeLBL];
        self.timeLBL.text=@"2 hrs";
        self.timeLBL.textColor=[UIColor whiteColor];
        self.timeLBL.textAlignment=NSTextAlignmentRight;
        self.timeLBL.font=[UIFont fontWithName:k_fontSemiBold size:14];
        
        self.profileIMGVIEW=[[UIImageHM alloc] initWithFrame:CGRectZero];
        [self addSubview:self.profileIMGVIEW];
        self.profileIMGVIEW.image=[UIImage imageNamed:@"post_4.jpeg"];
        self.profileIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
        self.profileIMGVIEW.clipsToBounds=YES;
        
      

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
        self.profLBL.font=[UIFont fontWithName:k_fontRegular size:13];
        self.profLBL.adjustsFontSizeToFitWidth=YES;
        self.profLBL.numberOfLines=2;
        
        
        self.likeCountLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
        [self addSubview:self.likeCountLBL];
        self.likeCountLBL.text=@"12";
        self.likeCountLBL.textColor=[UIColor whiteColor];
        self.likeCountLBL.textAlignment=NSTextAlignmentCenter;
        self.likeCountLBL.font=[UIFont fontWithName:k_fontSemiBold size:11];
        
        
        self.commentCountLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
        [self addSubview:self.commentCountLBL];
        self.commentCountLBL.text=@"3";
        self.commentCountLBL.textColor=[UIColor whiteColor];
        self.commentCountLBL.textAlignment=NSTextAlignmentCenter;
        self.commentCountLBL.font=[UIFont fontWithName:k_fontSemiBold size:11];
        
        
        self.likeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.likeBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"ExploreFeed_LikeBtn.png"] forState:UIControlStateNormal];
        [self addSubview:self.likeBtn];
        
        self.commentBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.commentBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.commentBtn setBackgroundImage:[UIImage imageNamed:@"ExploreFeed_CommentBtn.png"] forState:UIControlStateNormal];
        [self addSubview:self.commentBtn];
        
        self.shareBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"ExploreFeed_ShareBtn.png"] forState:UIControlStateNormal];
        [self addSubview:self.shareBtn];
        
        self.postIMGVIEW.hidden=false;
        
        
        hiddenView=[[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:hiddenView];
        hiddenView.hidden=true;
        hiddenView.backgroundColor=[UIColor whiteColor];
        
       
        self.backgroundColor=[UIColor clearColor];
        
        self.postIMGVIEW.frame=self.bounds;
        self.shadowImage.frame=self.bounds;
        
        self.profileIMGVIEW.layer.borderWidth=1;
        self.profileIMGVIEW.layer.borderColor=[UIColor colorWithWhite:0.75 alpha:1.0f].CGColor;
        
        self.likeCountLBL.frame=CGRectMake(15, frame.size.height-70, 50, 20);
        self.commentCountLBL.frame=CGRectMake(frame.size.width/2-25, frame.size.height-70, 50, 20);

    }
    return self;
    
}
-(void)setFrameX:(CGRect)frame;
{
    
    self.profileIMGVIEW.frame=CGRectMake(15, 15, 40, 40);
    self.profileIMGVIEW.layer.cornerRadius=20;
    self.nameLBL.frame=CGRectMake(15+40+5, 15+5, 200, 15);
    self.profLBL.frame=CGRectMake(15+40+5, 15+15+5, 200, 15);
    
    
    self.likeBtn.frame=CGRectMake(20, self.frame.size.height-20/2-31/2, 32/2*1.2, 30/2*1.2);
    self.commentBtn.frame=CGRectMake(self.frame.size.width/2-18*1.2+5, self.frame.size.height-20/2-31/2, 36/2*1.2, 31/2*1.2);
    self.shareBtn.frame=CGRectMake(self.frame.size.width-20-29/2*1.2-10, self.frame.size.height-20/2-31/2, 29/2*1.2, 29/2*1.2);

    
    self.likeCountLBL.center=CGPointMake(self.likeBtn.center.x,self.likeBtn.center.y-20);
    self.commentCountLBL.center=CGPointMake(self.commentBtn.center.x,self.commentBtn.center.y-20);
    

    
    self.tagName.frame=CGRectMake(15, self.frame.size.height-(20+31+100)/2, frame.size.width-30, 30);
    self.timeLBL.frame=CGRectMake(15, self.frame.size.height-(20+31+100)/2, frame.size.width-30, 30);
    
    
    
    
    
}

-(void)commentBtnClicked:(id)sender
{
    
}
-(void)shareBtnClicked:(id)sender
{
    
}

-(void)setDataObj:(APIObjects_FeedObj *)dict;
{
    liked=0;
    dataObj=dict;
    dataObj=dict;
    liked=dict.is_liked.intValue;
    
    [self.profileIMGVIEW setUp:dict.user_profile_photo_small];
    
    if(dict.mediaType.intValue!=0)
    {
        [self.postIMGVIEW setUp:dict.image_url];
        self.shadowImage.alpha=0.8;

    }
    else
    {
        [self.postIMGVIEW clearImageAll];
        self.shadowImage.alpha=0;

    }
    
    if(liked==1)
    {
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"ExploreFeed_UnlikeBtn.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"ExploreFeed_LikeBtn.png"] forState:UIControlStateNormal];
    }
    
    [self setUpMediaType:dict.mediaType.intValue andColorNumber:dict.colorNumber.intValue];

    self.nameLBL.text=[NSString stringWithFormat:@"%@ %@",dict.user_firstname,dict.user_lastname];
    self.profLBL.text=dict.user_profession;
    self.likeCountLBL.text=[NSString stringWithFormat:@"%d",dict.num_likes.intValue];
    self.commentCountLBL.text=[NSString stringWithFormat:@"%d",dict.num_comments.intValue];
    self.tagName.text=dict.interest_name;
    self.statusLBL.text=dict.text;
    
    self.timeLBL.text=dict.timeString;


    
   /*
    NSString *dataText=[dict valueForKey:@"text"];
    NSString *dataImgURL=[dict valueForKey:@"image_url"];
    int mediaType1=1;
    
    if(dataImgURL!=nil && ![dataImgURL isEqualToString:@""])
    {
    }
    else
    {
        mediaType1=0;
    }

    NSString *user_firstname=[dict valueForKey:@"user_firstname"];
    NSString *user_lastname=[dict valueForKey:@"user_lastname"];

    int num_comments=[[dict valueForKey:@"num_comments"] intValue];
    int num_likes=[[dict valueForKey:@"num_likes"] intValue];
    int interest_id=[[dict valueForKey:@"interest_id"] intValue];

    NSArray *user_profession=[dict valueForKey:@"user_profession"];
    NSString *user_profile_photo_small=[dict valueForKey:@"user_profile_photo_small"];
    NSString *video_url=[dict valueForKey:@"video_url"];
    NSString *video_thumb_url=[dict valueForKey:@"video_thumb_url"];

    //numberOfLikes - x
    //profile picture - x
    //user profession - x
    //user firstname - x
    //user lastname - x
    //video url - x
    //interest id - x
    //number of comments = x
    //interest id = x
    
   
 
    
    
    self.statusLBL.text=dataText;
    
    */
    
    
    
    
    
    /*
 //   self.profileIMGVIEW.image=[UIImage imageNamed:[NSString stringWithFormat:@"profile%d.jpg",(int)indexPath.row%5+3]];
    
    int mediaType1=[[dict valueForKey:@"postType"] intValue];
    
    
    int colorNumber=[[dict valueForKey:@"color"] intValue];
    
    [self setUpMediaType:mediaType1 andColorNumber:colorNumber];
    
    
    if(mediaType1!=0)
    {
        NSString *imgURL=[dict valueForKey:@"imageURL"];
        self.postIMGVIEW.image=[UIImage imageNamed:imgURL];
    }
    else
    {
        
    }*/
    
    

    
}
-(void)setHiddenCustom:(BOOL)flag
{
    // hiddenView.hidden=!flag;
    self.hidden=flag;
    
}

-(void)setUpMediaType:(int)number andColorNumber:(int)Cnumber
{
    mediaType=number;
    
    if(mediaType==0)
    {
        [self.postIMGVIEW clearImageAll];
        self.backgroundColor=[Constant colorGlobal:Cnumber];
        self.statusLBL.frame=CGRectMake(15, 15+80, self.frame.size.width-30, self.frame.size.height-170-30);
        
        self.statusLBL.font=[UIFont fontWithName:k_fontSemiBold size:25];
        self.statusLBL.numberOfLines=0;
        self.statusLBL.adjustsFontSizeToFitWidth=YES;
        
    }
    else
    {
        
        int height=30;
       
     //   self.statusLBL.frame=CGRectMake(15, self.frame.size.height-90-height, self.frame.size.width-30, height);
      //  self.statusLBL.frame=CGRectMake(15, frame.size.height-(55+31+100+50+height)/2, frame.size.width-30, 30);
        self.statusLBL.frame=CGRectMake(15, self.frame.size.height-(20+31+100+50)/2, self.frame.size.width-30, 30);

        self.backgroundColor=[UIColor whiteColor];
        
        self.statusLBL.font=[UIFont fontWithName:k_fontRegular size:17];
        self.statusLBL.numberOfLines=2;
        self.statusLBL.adjustsFontSizeToFitWidth=false;
        
    }
    
    
}




-(void)loadThumbNail:(NSURL *)urlVideo
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AVAsset *asset = [AVURLAsset assetWithURL:urlVideo];
        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
        CMTime duration = asset.duration;
        CGFloat durationInSeconds = duration.value / duration.timescale;
        CMTime time = CMTimeMakeWithSeconds(durationInSeconds * 0.5, (int)duration.value);
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
        UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.postIMGVIEW.image=thumbnail;
        });
        
        
    });
    
    
}




-(void)likeBtnClicked:(id)sender
{
    if(liked==0)
    {
        liked=1;
     [self callLikeAPI];
        [[DataSession sharedInstance] postLiked:dataObj.postId];

    [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"ExploreFeed_UnlikeBtn.png"] forState:UIControlStateNormal];
    [self likeBtnAnimation];
        self.likeCountLBL.text=[NSString stringWithFormat:@"%d",dataObj.num_likes.intValue];

    }
    else
    {
        liked=0;
        [self callLikeAPI];
        [[DataSession sharedInstance] postUnliked:dataObj.postId];

        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"ExploreFeed_LikeBtn.png"] forState:UIControlStateNormal];
        self.likeCountLBL.text=[NSString stringWithFormat:@"%d",dataObj.num_likes.intValue];

    }
    
}
-(void)callLikeAPI
{
    if(liked==1)
    {
       

    }
    else
    {

        
    }
    APIManager *manager=[[APIManager alloc] init];

    [manager sendRequestForLikeAPostId:[NSString stringWithFormat:@"%@",dataObj.postId] delegate:self andSelector:@selector(likeActionFinished:) andIsLike:liked];

    

    

    
}
-(void)likeActionFinished:(APIResponseObj *)responseObj
{
    NSLog(@"%@",responseObj.message);
}


-(void)likeBtnAnimation
{
    
    UIImageView *imageView1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    imageView1.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addSubview:imageView1];
    imageView1.image=[UIImage imageNamed:@"ExploreFeed_UnlikeBtn.png"];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView1.transform=CGAffineTransformMakeScale(20, 20);
        imageView1.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [imageView1 removeFromSuperview];
        
    }];
    
    
    
    
}

-(void)UpdateCommentCountIfRequired
{
    int count=[[DataSession sharedInstance] getUpdatedCommentCountForPostId:dataObj.postId];
    
    if(count!=-1)
    {
        self.commentCountLBL.text=[NSString stringWithFormat:@"%d",count];
    }

    
}

@end
