//
//  FeedCell.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "FeedCell.h"

@implementation FeedCell


-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        
        self.clipsToBounds=YES;
        
        videoURLString=nil;
        
        self.postIMGVIEW=[[UIImageView alloc] initWithFrame:CGRectZero];
        //  self.postIMGVIEW.image=[UIImage imageNamed:@"post_3.jpeg"];
        self.postIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
        [self addSubview:self.postIMGVIEW];
        
        /*        self.shadowImage=[[UIImageView alloc] initWithFrame:CGRectZero];
         self.shadowImage.image=[UIImage imageNamed:@"BlackShadow.png"];
         self.shadowImage.contentMode=UIViewContentModeScaleAspectFill;
         [self addSubview:self.shadowImage];
         self.shadowImage.alpha=0.5;
         */
        
        
        
        self.playerViewController = [[AVPlayerViewController alloc] init];
        [self addSubview:self.playerViewController.view];
        self.playerViewController.view.frame=self.bounds;
        self.playerViewController.showsPlaybackControls = false;
        self.playerViewController.videoGravity=AVLayerVideoGravityResizeAspectFill;
        self.playerViewController.view.hidden=true;
        
        
        self.videoLoader=[[LoaderMin alloc] initWithFrame:CGRectZero];
        [self addSubview:self.videoLoader];
        [self.videoLoader setUp];
        [self.videoLoader startAnimation];
        
        
        
        
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
        
        self.profileIMGVIEW=[[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.profileIMGVIEW];
        self.profileIMGVIEW.image=[UIImage imageNamed:@"post_4.jpeg"];
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
        
        
        self.likeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.likeBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        [self addSubview:self.likeBtn];
        
        self.commentBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.commentBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.commentBtn setBackgroundImage:[UIImage imageNamed:@"comments.png"] forState:UIControlStateNormal];
        [self addSubview:self.commentBtn];
        
        self.shareBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.shareBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [self addSubview:self.shareBtn];
        
        self.playerViewController.view.hidden=true;
        self.postIMGVIEW.hidden=false;
        
        
        hiddenView=[[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:hiddenView];
        hiddenView.hidden=true;
        hiddenView.backgroundColor=[UIColor whiteColor];
        
        self.backgroundColor=[UIColor clearColor];
        self.videoLoader.hidden=true;
        
    }
    return self;
    
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
    
    self.videoLoader.frame=CGRectMake(15, 15, 15, 5);
    self.tagName.frame=CGRectMake(15, frame.size.height-40, frame.size.width-30, 30);
    self.timeLBL.frame=CGRectMake(15, frame.size.height-40, frame.size.width-30, 30);
    
    self.profileIMGVIEW.frame=CGRectMake(15, frame.size.height-40-50, 40, 40);
    self.profileIMGVIEW.layer.cornerRadius=20;
    
    self.nameLBL.frame=CGRectMake(15+45, frame.size.height-40-50, 200, 20);
    self.profLBL.frame=CGRectMake(15+45, frame.size.height-40-35, 200, 20);
    
    self.likeCountLBL.frame=CGRectMake(frame.size.width-150, frame.size.height-40-50, 40, 20);
    self.commentCountLBL.frame=CGRectMake(frame.size.width-100, frame.size.height-40-50, 40, 20);
    
    
    self.likeBtn.frame=CGRectMake(frame.size.width-150, frame.size.height-40-35, 40, 40);
    
    self.commentBtn.frame=CGRectMake(frame.size.width-100, frame.size.height-40-35, 40, 40);
    
    self.shareBtn.frame=CGRectMake(frame.size.width-50, frame.size.height-40-35, 40, 40);
    
    
    
    ////
    
    self.profileIMGVIEW.frame=CGRectMake(15, 50, 50, 50);
    self.profileIMGVIEW.layer.cornerRadius=25;
    self.nameLBL.frame=CGRectMake(25+50, 50, 200, 25);
    self.profLBL.frame=CGRectMake(25+50, 75, 200, 25);
    
    self.tagName.frame=CGRectMake(15, frame.size.height-110, frame.size.width-30, 30);
    self.timeLBL.frame=CGRectMake(15, frame.size.height-110, frame.size.width-30, 30);
    // self.statusLBL.frame=CGRectMake(15,  frame.size.height-50, frame.size.width-30,70);
    
    
    
    
    
    self.likeCountLBL.frame=CGRectMake(15, frame.size.height-70, 50, 20);
    self.commentCountLBL.frame=CGRectMake(frame.size.width/2-25, frame.size.height-70, 50, 20);
    
    self.likeBtn.frame=CGRectMake(15, frame.size.height-60, 50, 50);
    
    self.commentBtn.frame=CGRectMake(frame.size.width/2-25, frame.size.height-60, 50, 50);
    
    self.shareBtn.frame=CGRectMake(frame.size.width-15-50, frame.size.height-60, 50, 50);
    
    
    
}
-(void)setUpMediaType:(int)number andColorNumber:(int)Cnumber
{
    mediaType=number;
    
    if(mediaType==0)
    {
        self.postIMGVIEW.image=nil;
        self.backgroundColor=[Constant colorGlobal:Cnumber];
        self.statusLBL.frame=CGRectMake(15, 10, self.frame.size.width-30, self.frame.size.height-50);

        self.statusLBL.font=[UIFont fontWithName:k_fontExtraBold size:25];
        self.statusLBL.numberOfLines=0;
        self.statusLBL.adjustsFontSizeToFitWidth=YES;

    }
    else
    {
        self.statusLBL.frame=CGRectMake(15, self.frame.size.height-200, self.frame.size.width-30, 70);

        self.backgroundColor=[UIColor whiteColor];

        self.statusLBL.font=[UIFont fontWithName:k_fontRegular size:17];
        self.statusLBL.numberOfLines=2;
        self.statusLBL.adjustsFontSizeToFitWidth=false;

    }
    
    
}

-(void)removeURL
{
    videoURLString=nil;
}

-(void)setURL:(NSString *)url
{
    
    
    
    NSString *string=[VideoCacheManager getCachePathIfExists:url];
    
    NSURL *urlMaster;
    if(string)
    {
        urlMaster = [NSURL fileURLWithPath:string]; // like file:///...

    }
    else{
        
        urlMaster=[[NSURL alloc] initWithString:url];
    }
    
    self.playerViewController.player = [AVPlayer playerWithURL:urlMaster];
    [self.playerViewController.player pause];
    
    self.playerViewController.view.hidden=true;
    self.postIMGVIEW.hidden=false;

    videoURLString=url;
   // [self loadThumbNail:[[NSURL alloc] initWithString:url]];
    
}
-(void)animateLoader
{
    [self.videoLoader startAnimation];
    
//    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
//        
//        self.videoLoader.transform=CGAffineTransformRotate(self.videoLoader.transform, M_PI);
//        
//    } completion:^(BOOL finished) {
//        
//    }];
    
}
- (UIImage *)screenshotOfVideo{
    
    CGSize maxSize=self.bounds.size;
    CMTime actualTime=self.playerViewController.player.currentItem.currentTime;
    NSError *error;
    
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:self.playerViewController.player.currentItem.asset];
    
    // Setting a maximum size is not necessary for this code to
    // successfully get a screenshot, but it was useful for my project.
    generator.maximumSize = maxSize;
    
    CGImageRef cgIm = [generator copyCGImageAtTime:kCMTimeZero
                                        actualTime:&actualTime
                                             error:&error];
    UIImage *image = [UIImage imageWithCGImage:cgIm];
    CFRelease(cgIm);
    
    if (nil != error) {
        NSLog(@"Error making screenshot: %@", [error localizedDescription]);
      //  NSLog(@"Actual screenshot time: %f Requested screenshot time: %f", CMTimeGetSeconds(actualTime),
        //      CMTimeGetSeconds(self.recordPlayer.currentTime));
        return nil;
    }
    
    return image;
}

-(void)setKeepPlaying:(BOOL)flag
{
    if(videoURLString!=nil)
    {
    
    keepPlaying=flag;
    
    if(keepPlaying==true)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(continuePlaying:)
                                                   object:nil];

        
        [self.playerViewController.player play];
        self.playerViewController.player.volume=0;
        [self performSelector:@selector(continuePlaying:) withObject:nil afterDelay:0.2];
    }
    else
    {
        //UIImage *image=[self screenshotOfVideo];
        
        [self.playerViewController.player.currentItem seekToTime:kCMTimeZero];
        [self.playerViewController.player pause];
        
        self.playerViewController.view.hidden=true;
        self.postIMGVIEW.hidden=false;
        self.videoLoader.hidden=true;

        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(continuePlaying:)
                                                   object:nil];

    }
    }
    else
    {
        NSLog(@"Not playing because url nil");
    }

}

-(void)continuePlaying:(id)sender
{
    
    if(keepPlaying==true)
    {
        float dur = CMTimeGetSeconds([self.playerViewController.player.currentItem duration]);
        float cur=CMTimeGetSeconds(self.playerViewController.player.currentItem.currentTime);
        
       // NSLog(@"%f,%f",dur,cur);
       // NSLog(@"Cell");

        if(cur>0)
        {
            self.playerViewController.view.hidden=false;
            self.postIMGVIEW.hidden=true;
            self.videoLoader.hidden=true;

        }
        else
        {
            self.videoLoader.hidden=false;

            [self animateLoader];
            self.playerViewController.view.hidden=true;
            self.postIMGVIEW.hidden=false;
        }
        
        if(cur>=dur)
        {
            
            [self.playerViewController.player.currentItem seekToTime:kCMTimeZero];
        }
       

        [self.playerViewController.player play];
        [self performSelector:@selector(continuePlaying:) withObject:nil afterDelay:0.2];
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
 
    
    [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"Unlike.png"] forState:UIControlStateNormal];
    [self likeBtnAnimation];
    
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
