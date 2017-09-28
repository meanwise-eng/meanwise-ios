//
//  HMVideoPlayer.m
//  MeanWiseUX
//
//  Created by Hardik on 17/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "HMVideoPlayer.h"

@implementation HMVideoPlayer

-(void)setUp
{
    self.backgroundColor=[UIColor blackColor];
    self.clipsToBounds=YES;
    //
    self.opaque=YES;
    self.layer.drawsAsynchronously=YES;
    
    self.postIMGVIEW=[[UIImageView alloc] initWithFrame:self.bounds];
    self.postIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
    [self addSubview:self.postIMGVIEW];
    self.postIMGVIEW.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.postIMGVIEW.image=[UIImage imageNamed:@"placeholder.jpg"];
    self.postIMGVIEW.opaque=YES;
    self.postIMGVIEW.alpha=0;
    
    self.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    self.playerViewController = [[AVPlayerViewController alloc] init];
    [self addSubview:self.playerViewController.view];
    self.playerViewController.view.frame=self.bounds;
    self.playerViewController.showsPlaybackControls = false;
    self.playerViewController.videoGravity=AVLayerVideoGravityResizeAspectFill;
    self.playerViewController.view.hidden=true;
    self.playerViewController.allowsPictureInPicturePlayback=false;
    self.playerViewController.view.opaque=YES;

    
    self.videoLoader=[[LoaderMin alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [self addSubview:self.videoLoader];
    [self.videoLoader setUp];
    self.videoLoader.opaque=YES;
    
    
    loadedTimeRangeShowView=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-20, 0, 8)];
    loadedTimeRangeShowView.backgroundColor=[UIColor greenColor];
    [self addSubview:loadedTimeRangeShowView];
    loadedTimeRangeShowView.alpha=0.5;
loadedTimeRangeShowView.opaque=YES;
    
    progressView=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, 0, 2)];
    progressView.backgroundColor=[UIColor yellowColor];
    [self addSubview:progressView];
    progressView.alpha=0.5;
    progressView.opaque=YES;

    self.videoLoader.frame=CGRectMake(15, 15, 15, 5);
    
    viewLocal=[[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-15, 0, 15, 15)];
    [self addSubview:viewLocal];
    viewLocal.opaque=YES;

    viewLocal.backgroundColor=[UIColor purpleColor];
    viewLocal.hidden=true;
    progressView.hidden=true;
    loadedTimeRangeShowView.hidden=true;
    
}
-(void)cleanupPlayer
{

    [self.playerViewController.player pause];
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(keepPlaying:)
                                               object:nil];

    [self.playerViewController.player replaceCurrentItemWithPlayerItem:nil];
 
    self.playerViewController.view.hidden=true;
    
    self.playerViewController.player=nil;

    loadedTimeRangeShowView.frame=CGRectMake(0, self.frame.size.height-20, 0, 8);
    progressView.frame=CGRectMake(0, self.frame.size.height-2, 0, 2);

}
-(void)deletePlayer
{
    [self.playerViewController.view removeFromSuperview];
    self.playerViewController=nil;
    [self.videoLoader removeFromSuperview];
    self.videoLoader=nil;
}
-(void)setURL:(NSString *)stringURL
{
    [self cleanupPlayer];
    
    //NSLog(@"New URL : %@",stringURL);
    urlStr=stringURL;
    
    
    NSString *string=[VideoCacheManager getCachePathIfExists:urlStr];
    
    NSURL *url;
    if(string)
    {
        viewLocal.hidden=true;
        playingLocal=1;
        url = [NSURL fileURLWithPath:string];
        
    }
    else{
        viewLocal.hidden=false;
        playingLocal=0;
        url=[[NSURL alloc] initWithString:urlStr];
    }

    
    self.playerViewController.player=[AVPlayer playerWithURL:url];
    [self.playerViewController.player play];
    
    [self performSelector:@selector(keepPlaying:) withObject:nil afterDelay:0.2];
    
    

    
}
-(void)keepPlaying:(id)sender
{


    float dur = CMTimeGetSeconds([self.playerViewController.player.currentItem duration]);
    float cur=CMTimeGetSeconds(self.playerViewController.player.currentItem.currentTime);
    
    if(playingLocal==0)
    {
    NSString *string=[VideoCacheManager getCachePathIfExists:urlStr];
    if(string!=nil)
    {
       // CMTime time=self.playerViewController.player.currentItem.duration;
        [self setURL:urlStr];
                NSLog(@"seek to loaded");
        //[self.playerViewController.player.currentItem seekToTime:time];

    }
    }
    
    videoLength=dur;
    
    if(self.playerViewController.readyForDisplay)
    {
        self.playerViewController.view.hidden=false;
    }
    
    if(cur!=0)
    {
        
        float length=cur/dur;
        length=self.frame.size.width*length;
        
        progressView.frame=CGRectMake(0, self.frame.size.height-10, length, 8);
        
    }

    
    

    if(cur>=dur)
    {
        NSLog(@"seek to Zero");
        [self.playerViewController.player.currentItem seekToTime:kCMTimeZero];
    }
    

    
    if(self.playerViewController.player.currentItem.isPlaybackLikelyToKeepUp)
    {
        self.videoLoader.hidden=true;
        [self.playerViewController.player play];

    }
    else
    {

     
        
        NSArray *array=self.playerViewController.player.currentItem.loadedTimeRanges;

        if(array.count!=0)
        {
            
            int flag=0;
            int loader=0;
            for(int i=0;i<[array count];i++)
            {
            
                CMTimeRange range;
                [[array objectAtIndex:i] getValue:&range];
                
                if(CMTimeRangeContainsTime(range, self.playerViewController.player.currentItem.currentTime))
                {
                    flag=1;
                    loader=1;
                }
                if(CMTimeGetSeconds(range.duration)==0)
                {
                    loader=0;
                }

            }
            if(flag==1)
            {
                [self.playerViewController.player play];
            }
            else             {
                [self.playerViewController.player pause];

            }

            if(flag==1 && cur==0)
            {
                self.videoLoader.hidden=false;
                [self.videoLoader startAnimation];

            }
            else if(flag==1 && cur!=0)
            {
                self.videoLoader.hidden=true;
            }
            else if(flag==0 || loader==0)
            {
                self.videoLoader.hidden=false;
                [self.videoLoader startAnimation];
            }


        }
        
        else
        {
            self.videoLoader.hidden=false;
            [self.videoLoader startAnimation];

        }


    }

    
    
    [self calculateTimeRange];

    [self performSelector:@selector(keepPlaying:) withObject:nil afterDelay:0.2];

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

        loadedTimeRangeShowView.frame=CGRectMake(start, self.frame.size.height-20, length, 8);
        }


    }

}



@end
