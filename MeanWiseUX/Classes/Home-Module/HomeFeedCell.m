//
//  HomeFeedCell.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "DataSession.h"
#import "HomeFeedCell.h"
#import "PINImageView+PINRemoteImage.h"
#import "PINButton+PINRemoteImage.h"

@implementation HomeFeedCell


-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        
        liked=0;
        self.clipsToBounds=YES;
        

        self.postIMGVIEW = [[ASNetworkImageNode alloc] init];
        [self.postIMGVIEW setFrame:CGRectZero];
        self.postIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
        
        [self addSubview:self.postIMGVIEW.view];
        
        
        
        /*        self.shadowImage=[[UIImageView alloc] initWithFrame:CGRectZero];
         self.shadowImage.image=[UIImage imageNamed:@"BlackShadow.png"];
         self.shadowImage.contentMode=UIViewContentModeScaleAspectFill;
         [self addSubview:self.shadowImage];
         self.shadowImage.alpha=0.5;
         */
        

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
        self.timeLBL.font=[UIFont fontWithName:k_fontBold size:14];
        
        self.profileIMGVIEW=[[ASNetworkImageNode alloc] init];
        [self.profileIMGVIEW setFrame:CGRectZero];
        [self addSubview:self.profileIMGVIEW.view];
       // self.profileIMGVIEW.image=[UIImage imageNamed:@"post_4.jpeg"];
        self.profileIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
        self.profileIMGVIEW.clipsToBounds=YES;
        
        self.nameLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
        [self addSubview:self.nameLBL];
        self.nameLBL.text=@"Marry Lee";
        self.nameLBL.textColor=[UIColor whiteColor];
        self.nameLBL.textAlignment=NSTextAlignmentLeft;
        self.nameLBL.font=[UIFont fontWithName:k_fontSemiBold size:12];
        
        
        self.profLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
        [self addSubview:self.profLBL];
        self.profLBL.text=@"Photographer";
        self.profLBL.textColor=[UIColor whiteColor];
        self.profLBL.textAlignment=NSTextAlignmentLeft;
        self.profLBL.font=[UIFont fontWithName:k_fontSemiBold size:12];
        
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
        
        
        self.likeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self.likeBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        [self addSubview:self.likeBtn];
        
        self.commentBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.commentBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.commentBtn setBackgroundImage:[UIImage imageNamed:@"comments.png"] forState:UIControlStateNormal];
        [self addSubview:self.commentBtn];
        
        self.shareBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [self addSubview:self.shareBtn];
        
        self.postIMGVIEW.hidden=false;
        
        
        hiddenView=[[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:hiddenView];
        hiddenView.hidden=true;
        hiddenView.backgroundColor=[UIColor whiteColor];
        
        self.backgroundColor=[UIColor clearColor];
        
    }
    return self;
    
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
    liked=dict.IsUserLiked.intValue;
    
    self.profileIMGVIEW.URL =[NSURL URLWithString:dict.user_profile_photo_small];
    
    if(dict.mediaType.intValue!=0)
    {
        self.postIMGVIEW.placeholderEnabled = YES;
        self.postIMGVIEW.placeholderColor =  [Constant colorGlobal:arc4random_uniform(14)];
        self.postIMGVIEW.placeholderFadeDuration = 0.25;
        self.postIMGVIEW.URL = [NSURL URLWithString:dict.image_url];
    }

    if(liked==1)
    {
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"Unlike.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
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
-(void)setFrameX:(CGRect)frame;
{
    // self.frame=frame;
    
    /// self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, frame.size.width, frame.size.height);
    
    hiddenView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.postIMGVIEW.frame=frame;
    self.shadowImage.frame=frame;
    
    [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
    
    //  self.statusLBL.frame=CGRectMake(15, 10, frame.size.width-30, frame.size.height-50);
    
    self.tagName.frame=CGRectMake(15, frame.size.height-40, frame.size.width-30, 30);
    self.timeLBL.frame=CGRectMake(15, frame.size.height-40, frame.size.width-30, 30);
    
    self.profileIMGVIEW.frame=CGRectMake(15, frame.size.height-40-50, 40, 40);
    self.profileIMGVIEW.layer.cornerRadius=20;
    
    self.nameLBL.frame=CGRectMake(15+45, frame.size.height-40-50, 200, 20);
    self.profLBL.frame=CGRectMake(15+45, frame.size.height-40-35, 200, 20);
    
    self.likeCountLBL.frame=CGRectMake(frame.size.width-150, frame.size.height-40-50, 40, 20);
    self.commentCountLBL.frame=CGRectMake(frame.size.width-100, frame.size.height-40-50, 40, 20);
    
    
    self.likeBtn.frame=CGRectMake(frame.size.width-150, frame.size.height-40-35, 20, 20);
    
    self.commentBtn.frame=CGRectMake(frame.size.width-100, frame.size.height-40-35, 40, 40);
    
    self.shareBtn.frame=CGRectMake(frame.size.width-50, frame.size.height-40-35, 40, 40);
    
    
    
    ////
    
    self.profileIMGVIEW.frame=CGRectMake(15, 15, 50, 50);
    self.profileIMGVIEW.layer.cornerRadius=25;
    self.nameLBL.frame=CGRectMake(15+50+5, 15+10, 200, 15);
    self.profLBL.frame=CGRectMake(15+50+5, 15+25, 200, 15);
    
    self.tagName.frame=CGRectMake(15, frame.size.height-110, frame.size.width-30, 30);
    self.timeLBL.frame=CGRectMake(15, frame.size.height-110, frame.size.width-30, 30);
    // self.statusLBL.frame=CGRectMake(15,  frame.size.height-50, frame.size.width-30,70);
    
    
    
    
    
    self.likeCountLBL.frame=CGRectMake(5, frame.size.height-70, 50, 20);
    self.commentCountLBL.frame=CGRectMake(frame.size.width/2-20, frame.size.height-70, 50, 20);
    
    self.likeBtn.frame=CGRectMake(5, frame.size.height-60, 50, 50);
    
    self.commentBtn.frame=CGRectMake(frame.size.width/2-20, frame.size.height-60, 50, 50);
    
    self.shareBtn.frame=CGRectMake(frame.size.width-50, frame.size.height-60, 50, 50);
    
    
    
}
-(void)setUpMediaType:(int)number andColorNumber:(int)Cnumber
{
    mediaType=number;
    
    if(mediaType==0)
    {
        
        self.postIMGVIEW.hidden = YES;
        
        self.backgroundColor=[Constant colorGlobal:Cnumber];
        self.statusLBL.frame=CGRectMake(15, 15+50, self.frame.size.width-30, self.frame.size.height-170);
        
        self.statusLBL.font=[UIFont fontWithName:k_fontExtraBold size:25];
        self.statusLBL.numberOfLines=0;
        self.statusLBL.adjustsFontSizeToFitWidth=YES;
        
    }
    else
    {
        
        self.postIMGVIEW.hidden = NO;
        
        self.statusLBL.frame=CGRectMake(15, self.frame.size.height-200, self.frame.size.width-30, 70);
        
        self.backgroundColor=[UIColor whiteColor];
        
        self.statusLBL.font=[UIFont fontWithName:k_fontRegular size:17];
        self.statusLBL.numberOfLines=2;
        self.statusLBL.adjustsFontSizeToFitWidth=false;
        
    }
    
    
}



-(void)loadThumbNail:(NSURL *)urlVideo
{
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AVAsset *asset = [AVURLAsset assetWithURL:urlVideo];
        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
        CMTime duration = asset.duration;
        CGFloat durationInSeconds = duration.value / duration.timescale;
        CMTime time = CMTimeMakeWithSeconds(durationInSeconds * 0.5, (int)duration.value);
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
      //  UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
           // self.postIMGVIEW.placeholderImage=thumbnail;
        });
        
        
    });
    
    */
}




-(void)likeBtnClicked:(id)sender
{
    if(liked==0)
    {
        liked=1;
     [self callLikeAPI];
        [[DataSession sharedInstance] postLiked:dataObj.postId];

    [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"Unlike.png"] forState:UIControlStateNormal];
    [self likeBtnAnimation];
        self.likeCountLBL.text=[NSString stringWithFormat:@"%d",dataObj.num_likes.intValue];

    }
    else
    {
        liked=0;
        [self callLikeAPI];
        [[DataSession sharedInstance] postUnliked:dataObj.postId];

        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
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
    imageView1.image=[UIImage imageNamed:@"Unlike.png"];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView1.transform=CGAffineTransformMakeScale(20, 20);
        imageView1.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [imageView1 removeFromSuperview];
        
    }];
    
    
    
    
}



@end
