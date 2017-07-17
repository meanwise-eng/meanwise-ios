//
//  VideoLoopPlayer.m
//  VideoPlayerDemo
//
//  Created by Hardik on 10/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "VidLoopPlayer.h"

@implementation VidLoopPlayer

-(void)setUp
{
    playerViewControl =
    [[AVPlayerViewController alloc] init];
    playerViewControl.view.frame=self.frame;
    [self addSubview:playerViewControl.view];
    //   [playerViewControl.player play];
     playerViewControl.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    
    playerViewControl.showsPlaybackControls = false;
    playerViewControl.videoGravity=AVLayerVideoGravityResize;
    
    
    
    
    self.userInteractionEnabled=false;

    
}
-(void)cleanUpAndsetPath:(NSString *)path
{
    if(playerViewControl.player!=nil)
    {
        [playerViewControl.player pause];
        playerViewControl.player=nil;
    }
    
    isPlayerPaused=false;
    pathFile=path;

    playerViewControl.player =
    [AVPlayer playerWithURL:[NSURL fileURLWithPath:path]];
    
    [playerViewControl.player play];
    [self autoplayContinue:nil];
    
    
}
-(void)pauseBtnClicked:(id)sender
{
    isPlayerPaused=true;
}
-(void)resumeBtnClicked:(id)sender
{
    isPlayerPaused=false;
}
-(void)killPlayer
{
    [playerViewControl.player pause];
    playerViewControl.player=nil;
    [playerViewControl.view removeFromSuperview];
    playerViewControl=nil;
    



    
}

-(void)replayBtnClicked:(id)sender
{
    [playerViewControl.player.currentItem seekToTime:kCMTimeZero];
    [playerViewControl.player play];
    
}
-(void)autoplayContinue:(id)sender
{
    if(playerViewControl.player!=nil)
    {
        if(isPlayerPaused==false)
        {
            AVPlayerItem *currentItem = playerViewControl.player.currentItem;
            
            NSTimeInterval currentTime = CMTimeGetSeconds(currentItem.currentTime);
            
            NSTimeInterval duration = CMTimeGetSeconds(currentItem.duration);
            
            if(currentTime>=duration)
            {
                [playerViewControl.player seekToTime:kCMTimeZero];
                
            }
            
            [playerViewControl.player play];
        }
        else
        {
            [playerViewControl.player pause];
            
            
        }
    }
    
    [self performSelector:@selector(autoplayContinue:) withObject:nil afterDelay:0.2f];
    
}
@end
