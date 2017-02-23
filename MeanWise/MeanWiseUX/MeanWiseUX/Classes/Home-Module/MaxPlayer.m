//
//  MaxPlayer.m
//  MeanWiseUX
//
//  Created by Hardik on 17/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "MaxPlayer.h"

@implementation MaxPlayer

-(void)setUp
{
    urlStr=nil;
    self.backgroundColor=[UIColor clearColor];
    self.playerViewController = [[AVPlayerViewController alloc] init];
    [self addSubview:self.playerViewController.view];
    self.playerViewController.view.frame=self.bounds;
    self.playerViewController.showsPlaybackControls = false;
    self.playerViewController.videoGravity=AVLayerVideoGravityResizeAspectFill;
    self.playerViewController.allowsPictureInPicturePlayback=false;
    self.playerViewController.view.opaque=YES;
    
    self.playerViewController.view.hidden=true;
    
    
    
    
    
    self.videoLoader=[[LoaderMin alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [self addSubview:self.videoLoader];
    [self.videoLoader setUp];
    self.videoLoader.opaque=YES;
    self.videoLoader.hidden=true;

    self.videoLoader.center=CGPointMake(self.bounds.size.width/2,150);
    
    
    baseProgressView=[[UIView alloc] initWithFrame:CGRectMake(0, 1, self.frame.size.width, 2)];
    baseProgressView.backgroundColor=[UIColor clearColor];
    [self addSubview:baseProgressView];
    
    bufferProgressBar=[[UIView alloc] initWithFrame:CGRectMake(0, 1, 0, 1)];
    bufferProgressBar.backgroundColor=[UIColor whiteColor];
    [self addSubview:bufferProgressBar];
    
    currentProgressBar=[[UIView alloc] initWithFrame:CGRectMake(0, 1, 0, 2)];
    currentProgressBar.backgroundColor=[UIColor whiteColor];
    [self addSubview:currentProgressBar];
    

    
}
-(void)setUpWithURLString:(NSString *)urlString;
{
//NSString  *stringURL=[NSString stringWithFormat:@"%@%@",KK_globalMediaURL,urlString];

    urlStr=urlString;
    

}
-(void)setUnMute
{
    [self.playerViewController.player setVolume:1.0f];
    
}
-(void)setMute
{
    [self.playerViewController.player setVolume:0.0f];
    
}
-(void)playStart
{
 
    if(urlStr!=nil)
    {
        
    //    urlStr=@"https://vt.media.tumblr.com/tumblr_oi3vig8Lqp1qbct3j.mp4";
    
        NSURL *url=[NSURL URLWithString:urlStr];
    self.playerViewController.player=[AVPlayer playerWithURL:url];
    [self.playerViewController.player play];
        
        self.videoLoader.hidden=false;
        [self.videoLoader startAnimation];
        
        baseProgressView.frame=CGRectMake(0, 1, self.frame.size.width, 2);
        
        bufferProgressBar.frame=CGRectMake(0, 1, 0, 1);
        
        currentProgressBar.frame=CGRectMake(0, 1, 0, 2);


        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(playerTimelineLoop:)
                                                   object:nil];

    [self performSelector:@selector(playerTimelineLoop:) withObject:nil afterDelay:0.2];
    }

}
-(void)playerTimelineLoop:(id)sender
{

    //Getting durations
    float dur = CMTimeGetSeconds([self.playerViewController.player.currentItem duration]);
    float cur=CMTimeGetSeconds(self.playerViewController.player.currentItem.currentTime);

    
    //Check if end reached
    if(cur>=dur)
    {
        [self.playerViewController.player seekToTime:kCMTimeZero];
        [self.playerViewController.player play];
        self.videoLoader.hidden=true;

    }
    else
    {
        
        
            BOOL flagAvaialble=0;
            BOOL showLoader=0;
            NSArray *array=self.playerViewController.player.currentItem.loadedTimeRanges;

            for(int i=0;i<[array count];i++)
            {
                
                CMTimeRange range;
                [[array objectAtIndex:i] getValue:&range];
                
               
                
                    if(CMTimeRangeContainsTime(range, self.playerViewController.player.currentItem.currentTime))
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
                [self.playerViewController.player play];
            }
            else             {
                [self.playerViewController.player pause];
            
            }
        
            if(flagAvaialble==1 && cur==0)
            {
                self.videoLoader.hidden=false;
                [self.videoLoader startAnimation];
            
            }
            else if(flagAvaialble==1 && cur!=0)
            {
                self.videoLoader.hidden=true;
            }
            else if(flagAvaialble==0 || flagAvaialble==0)
            {
                self.videoLoader.hidden=false;
                [self.videoLoader startAnimation];
            }


    }
    
    //Check if player is ready
    if(self.playerViewController.readyForDisplay)
    {
        self.playerViewController.view.hidden=false;
        
    }
    
    //Update Progress Value
    if(!isnan(dur) && !isnan(cur) && cur!=0)
    {
        float currentProgress=cur/dur;
        currentProgress=self.frame.size.width*currentProgress;
        
        if(currentProgress!=NAN)
        {
        currentProgressBar.frame=CGRectMake(0, 1, currentProgress, 2);
        }
    }
    
    //Checking Buffer Value
    [self calculateTimeRange];
    
    
    
    //Repeat Call
    [self performSelector:@selector(playerTimelineLoop:) withObject:nil afterDelay:0.2];
}

-(void)pausePlayer
{
    [self.playerViewController.player pause];
}


-(void)cleanWhenGoOut
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(playerTimelineLoop:)
                                               object:nil];

    self.videoLoader.hidden=true;

 
    baseProgressView.frame=CGRectMake(0, 1, self.frame.size.width, 2);
    
    bufferProgressBar.frame=CGRectMake(0, 1, 0, 1);
    
    currentProgressBar.frame=CGRectMake(0, 1, 0, 2);

    self.playerViewController.view.hidden=true;

    [self.playerViewController.player pause];
    self.playerViewController.player=nil;
    urlStr=nil;

}

-(void)calculateTimeRange
{
    NSArray *array=self.playerViewController.player.currentItem.loadedTimeRanges;
    
    float dur = CMTimeGetSeconds([self.playerViewController.player.currentItem duration]);
    
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
            
            bufferProgressBar.frame=CGRectMake(start, 1, length, 1);
        }
        
        
    }
    
}



@end
