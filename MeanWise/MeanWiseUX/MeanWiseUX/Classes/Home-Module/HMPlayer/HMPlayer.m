//
//  HMPlayer.m
//  VideoPlayerDemo
//
//  Created by Hardik on 11/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "HMPlayer.h"

@implementation HMPlayer

-(void)setDebugNumber:(NSString *)number;
{
    debugNumber=number;
}
-(void)setPlayerScreenIdeantifier:(NSString *)string;
{
    screenIdentifier=string;
}
-(void)setUpRefreshIdentifier:(NSNumber *)number;
{
    refreshIdentifier=number;
    
}

-(void)setUp
{
    isVideoLocal=false;
    isPlayerShouldPlay=false;
    urlStr=nil;
    self.backgroundColor=[UIColor clearColor];
    playerViewController = [[AVPlayerViewController alloc] init];
    [self addSubview:playerViewController.view];
    playerViewController.view.frame=self.bounds;
    playerViewController.showsPlaybackControls = false;
    playerViewController.videoGravity=AVLayerVideoGravityResizeAspectFill;
    playerViewController.allowsPictureInPicturePlayback=false;
    playerViewController.view.opaque=YES;
    
    playerViewController.view.hidden=true;
    
    
    videoLoader=[[LoaderMin alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [self addSubview:videoLoader];
    [videoLoader setUp];
    videoLoader.opaque=YES;
    videoLoader.hidden=true;
    
    videoLoader.center=CGPointMake(self.bounds.size.width/2,150);
    
    
//    baseProgressView=[[UIView alloc] initWithFrame:CGRectMake(0, 1, self.frame.size.width, 2)];
//    baseProgressView.backgroundColor=[UIColor clearColor];
//    [self addSubview:baseProgressView];
//    
//    bufferProgressBar=[[UIView alloc] initWithFrame:CGRectMake(0, 1, 0, 2)];
//    bufferProgressBar.backgroundColor=[UIColor colorWithWhite:1 alpha:0.5];
//    [self addSubview:bufferProgressBar];
//    
//    currentProgressBar=[[UIView alloc] initWithFrame:CGRectMake(0, 1, 0, 2)];
//    currentProgressBar.backgroundColor=[UIColor whiteColor];
//    [self addSubview:currentProgressBar];
//    
//    baseProgressView.hidden=true;
//    bufferProgressBar.hidden=true;
//    currentProgressBar.hidden=true;

}
-(void)setURL:(NSString *)url
{
    
    
    
    urlStr=url;
    
  //  baseProgressView.frame=CGRectMake(0, 1, self.frame.size.width, 2);
    
   // bufferProgressBar.frame=CGRectMake(0, 1, 0, 2);
    
   // currentProgressBar.frame=CGRectMake(0, 1, 0, 2);
    [self killPlayer];
    
}
-(void)killPlayer
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(playerTimelineLoop:)
                                               object:nil];
    
    

    [playerViewController.player pause];
    [playerViewController.player replaceCurrentItemWithPlayerItem:nil];
    playerViewController.player=nil;
    playerViewController.view.hidden=true;
   // [playerViewController.view removeFromSuperview];
   // playerViewController=nil;
    

    
}
-(void)playerPause
{
    isPlayerShouldPlay=false;
    [playerViewController.player pause];

}
-(void)playerPlay
{
    isPlayerShouldPlay=true;
    
    playerViewController.view.hidden=true;
    
    NSURL *url;

    if(urlStr!=nil)
    {
        NSString *string=[VideoCacheManager getCachePathIfExists:urlStr];
    
        if(string)
        {
                isVideoLocal=YES;
            videoLoader.alpha=0;
            
                url = [NSURL fileURLWithPath:string];
        
        }
        else
        {
                isVideoLocal=FALSE;
            videoLoader.alpha=1;
                url=[[NSURL alloc] initWithString:urlStr];
        }
    }
    else
    {
        isVideoLocal=FALSE;
        url=[NSURL URLWithString:urlStr];
    }
    
//    NSURL *
    playerViewController.player=[AVPlayer playerWithURL:url];
    [playerViewController.player play];
    
    videoLoader.hidden=false;
    [videoLoader startAnimation];
    
    
    
  //  baseProgressView.frame=CGRectMake(0, 1, self.frame.size.width, 2);
    
   // bufferProgressBar.frame=CGRectMake(0, 1, 0, 2);
    
   // currentProgressBar.frame=CGRectMake(0, 1, 0, 2);


    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(playerTimelineLoop:)
                                               object:nil];
    
    [self performSelector:@selector(playerTimelineLoop:) withObject:nil afterDelay:0.2];

}
-(void)checkIfNeedsToStop
{
    
    if([[HMPlayerManager sharedInstance] MX_shouldPlayPlayerForURL:urlStr withIdentifier:screenIdentifier])
    {
        isPlayerShouldPlay=true;
    }
    else
    {
        isPlayerShouldPlay=false;
    }
    
    
    
    if([screenIdentifier isEqualToString:[HMPlayerManager sharedInstance].Profile_screenIdentifier])
    {
        int p=0;
    }
    
    
    //isPaused, screenIdentifier, urlIdentifier, fullscreen,
  /*
    if(
       [HMPlayerManager sharedInstance].HM_isPaused==false
       && [screenIdentifier isEqualToString:[HMPlayerManager sharedInstance].HM_screenIdentifier]
       && [urlStr isEqualToString:[HMPlayerManager sharedInstance].HM_urlIdentifier]
       && [HMPlayerManager sharedInstance].HM_isFullScreen==true
       )
    {
        
        // self.hidden=false;
        isPlayerShouldPlay=true;
    }
    else
    {
        isPlayerShouldPlay=false;
    }*/

    /*
    if(![urlStr isEqualToString:@""] && [HMPlayerManager sharedInstance].All_isPaused==false)
    {
        if([HMPlayerManager sharedInstance].Home_isPaused==false && [HMPlayerManager sharedInstance].Home_isVisibleBounds==true && [screenIdentifier isEqualToString:[HMPlayerManager sharedInstance].Home_screenIdentifier] && [urlStr isEqualToString:[HMPlayerManager sharedInstance].Home_urlIdentifier] && [HMPlayerManager sharedInstance].Home_RefreshIdentifier==refreshIdentifier)
        {
        
               // self.hidden=false;
                isPlayerShouldPlay=true;
        }
        else if([HMPlayerManager sharedInstance].Explore_isPaused==false && [HMPlayerManager sharedInstance].Explore_isVisibleBounds==true && [screenIdentifier isEqualToString:[HMPlayerManager sharedInstance].Explore_screenIdentifier] && [urlStr isEqualToString:[HMPlayerManager sharedInstance].Explore_urlIdentifier])
        {
            
          //  self.hidden=false;
            isPlayerShouldPlay=true;
        }
        else if([HMPlayerManager sharedInstance].Profile_isPaused==false && [HMPlayerManager sharedInstance].Profile_isVisibleBounds==true && [screenIdentifier isEqualToString:[HMPlayerManager sharedInstance].Profile_screenIdentifier] && [urlStr isEqualToString:[HMPlayerManager sharedInstance].Profile_urlIdentifier] && [HMPlayerManager sharedInstance].Profile_RefreshIdentifier==refreshIdentifier)
        {
            
            //  self.hidden=false;
            isPlayerShouldPlay=true;
        }
        else if([HMPlayerManager sharedInstance].NotificationPost_isPaused==false && [HMPlayerManager sharedInstance].NotificationPost_isVisibleBounds==true && [screenIdentifier isEqualToString:[HMPlayerManager sharedInstance].NotificationPost_screenIdentifier] && [urlStr isEqualToString:[HMPlayerManager sharedInstance].NotificationPost_urlIdentifier])
        {
            
            //  self.hidden=false;
            isPlayerShouldPlay=true;
        }
        else if([HMPlayerManager sharedInstance].DeepLinkPost_isPaused==false && [HMPlayerManager sharedInstance].DeepLinkPost_isVisibleBounds==true && [screenIdentifier isEqualToString:[HMPlayerManager sharedInstance].DeepLinkPost_screenIdentifier] && [urlStr isEqualToString:[HMPlayerManager sharedInstance].DeepLinkPost_urlIdentifier] && [HMPlayerManager sharedInstance].DeepLink_RefreshIdentifier==refreshIdentifier)
        {
            
            isPlayerShouldPlay=true;
   
        }
        else
        {
          //  self.hidden=true;
         //   NSLog(@"NO %@,%@",screenIdentifier,debugNumber);
            isPlayerShouldPlay=false;

        }
        
     
    }
    else
    {
       // self.hidden=true;
        isPlayerShouldPlay=false;
    }*/
   
}
-(void)playerTimelineLoop:(id)sender
{
    if([[HMPlayerManager sharedInstance] MX_shouldKillThePlayerForIdentifier:screenIdentifier])
    {
        if(urlStr!=nil)
        {
            NSLog(@"%@",urlStr);
        }
        [self killPlayer];
        urlStr=nil;
        isPlayerShouldPlay=false;
        [playerViewController.view removeFromSuperview];
        playerViewController=nil;
        
        [self removeFromSuperview];
        
    }
    
    if([HMPlayerManager sharedInstance].HM_isKilling==true && [[HMPlayerManager sharedInstance].HM_screenIdentifier isEqualToString:screenIdentifier])
    {
        if(urlStr!=nil)
        {
            NSLog(@"%@",urlStr);
        }
        [self killPlayer];
        urlStr=nil;
        isPlayerShouldPlay=false;
        [playerViewController.view removeFromSuperview];
        playerViewController=nil;
        
        [self removeFromSuperview];

    }
   
    if([HMPlayerManager sharedInstance].Explore_isKilling==true && [[HMPlayerManager sharedInstance].Explore_screenIdentifier isEqualToString:screenIdentifier])
    {
        
        //NSLog(@"Kill");

        [self killPlayer];
        urlStr=nil;
        isPlayerShouldPlay=false;
         [playerViewController.view removeFromSuperview];
         playerViewController=nil;

        [self removeFromSuperview];
        
    }
    if([HMPlayerManager sharedInstance].Profile_isKilling==true && [[HMPlayerManager sharedInstance].Profile_screenIdentifier isEqualToString:screenIdentifier])
    {
        
     //   NSLog(@"Kill Profile player");
        
        [self killPlayer];
        urlStr=nil;
        isPlayerShouldPlay=false;
        [playerViewController.view removeFromSuperview];
        playerViewController=nil;
        
        [self removeFromSuperview];
        
    }
    if([HMPlayerManager sharedInstance].NotificationPost_isKilling==true && [[HMPlayerManager sharedInstance].NotificationPost_screenIdentifier isEqualToString:screenIdentifier])
    {
        
      //  NSLog(@"Kill Notification player");
        
        [self killPlayer];
        urlStr=nil;
        isPlayerShouldPlay=false;
        [playerViewController.view removeFromSuperview];
        playerViewController=nil;
        
        [self removeFromSuperview];
        
    }
    if([HMPlayerManager sharedInstance].DeepLinkPost_isKilling==true && [[HMPlayerManager sharedInstance].DeepLinkPost_screenIdentifier isEqualToString:screenIdentifier])
    {
        
     //   NSLog(@"Kill Deep link player");
        
        [self killPlayer];
        urlStr=nil;
        isPlayerShouldPlay=false;
        [playerViewController.view removeFromSuperview];
        playerViewController=nil;
        
        [self removeFromSuperview];
        
    }
    
    

    
    
    [self checkIfNeedsToStop];
    
    if(isPlayerShouldPlay==true && urlStr!=nil)
    {

      //  NSLog(@"YES-%@ %@",screenIdentifier,debugNumber);
        
    //Getting durations
    float dur = CMTimeGetSeconds([playerViewController.player.currentItem duration]);
    float cur=CMTimeGetSeconds(playerViewController.player.currentItem.currentTime);
    
    
    //Check if end reached
    if(cur>=dur)
    {
        [playerViewController.player seekToTime:kCMTimeZero];
        [playerViewController.player play];
        videoLoader.hidden=true;
        
    }
    else
    {
        
        
        BOOL flagAvaialble=0;
        BOOL showLoader=0;
        NSArray *array=playerViewController.player.currentItem.loadedTimeRanges;
        
        for(int i=0;i<[array count];i++)
        {
            
            CMTimeRange range;
            [[array objectAtIndex:i] getValue:&range];
            
            
            
            if(CMTimeRangeContainsTime(range, playerViewController.player.currentItem.currentTime))
            {
                flagAvaialble=1;
                showLoader=1;
                
            }
            
            if(CMTimeGetSeconds(range.duration)==0)
            {
                showLoader=0;
            }
            
            
            
            
            
        }
        
        if(flagAvaialble==1)
        {
            [playerViewController.player play];
        }
        else             {
            [playerViewController.player pause];
            
        }
        
        if(flagAvaialble==1 && cur==0)
        {
            videoLoader.hidden=false;
            [videoLoader startAnimation];
            
        }
        else if(flagAvaialble==1 && cur!=0)
        {
            videoLoader.hidden=true;
        }
        else if(flagAvaialble==0 || flagAvaialble==0)
        {
            videoLoader.hidden=false;
            [videoLoader startAnimation];
        }
        
        
    }
    
    //Check if player is ready
    if(playerViewController.readyForDisplay)
    {
        playerViewController.view.hidden=false;
    }
    
    
    //Update Progress Value
    if(!isnan(dur) && !isnan(cur) && cur!=0)
    {
        float currentProgress=cur/dur;
        currentProgress=self.frame.size.width*currentProgress;
        
        if(currentProgress!=NAN)
        {
          //  currentProgressBar.frame=CGRectMake(0, 1, currentProgress, 2);
        }
    }
    
    //Checking Buffer Value
    [self calculateTimeRange];
    
    }
    else
    {
        [playerViewController.player pause];
    }
    
    //Repeat Call
    [self performSelector:@selector(playerTimelineLoop:) withObject:nil afterDelay:0.2];
}
-(void)calculateTimeRange
{
    NSArray *array=playerViewController.player.currentItem.loadedTimeRanges;
    
    float dur = CMTimeGetSeconds([playerViewController.player.currentItem duration]);
    
    if(dur!=0 && array.count!=0)
    {
        CMTimeRange range;
        [[array objectAtIndex:0] getValue:&range];
        
        
        
        if(CMTimeGetSeconds(range.duration)!=0)
        {
            
            float start=CMTimeGetSeconds(range.start)/dur;
            float length=CMTimeGetSeconds(range.duration)/dur;
            length=self.frame.size.width*length;
            start=self.frame.size.width*start;
            
          //  bufferProgressBar.frame=CGRectMake(start, 1, length, 2);
        }
        
        
    }
    
}

@end
