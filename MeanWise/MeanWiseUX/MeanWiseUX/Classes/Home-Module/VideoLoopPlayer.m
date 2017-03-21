//
//  VideoLoopPlayer.m
//  MeanWiseUX
//
//  Created by Hardik on 13/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "VideoLoopPlayer.h"

@implementation VideoLoopPlayer

-(void)setUpWithURL:(NSString *)string
{
 
    playerViewController=[[AVPlayerViewController alloc] init];
    [self addSubview:playerViewController.view];
    playerViewController.view.frame=self.bounds;
    
    playerViewController.player=[AVPlayer playerWithURL:[NSURL URLWithString:string]];
    [playerViewController.player play];
    playerViewController.videoGravity=AVLayerVideoGravityResizeAspectFill;
    playerViewController.showsPlaybackControls=false;
    
    [self performSelector:@selector(loopPlay:) withObject:nil afterDelay:0.2];
    
}
-(void)loopPlay:(id)sender
{
    CMTime videoLen=playerViewController.player.currentItem.duration;
    
    CMTime currentPos=playerViewController.player.currentTime;
    

    float videoLenSecond=CMTimeGetSeconds(videoLen);
    float currentPosSecond=CMTimeGetSeconds(currentPos);
    
    if(currentPosSecond>=videoLenSecond)
    {
        [playerViewController.player seekToTime:kCMTimeZero];
        [playerViewController.player play];
    }
    
    
    [self performSelector:@selector(loopPlay:) withObject:nil afterDelay:0.2];

}
-(void)clearLoopPlayer
{
    
    [playerViewController.player pause];
    [playerViewController.player replaceCurrentItemWithPlayerItem:nil];
    playerViewController.player=nil;

}

@end
