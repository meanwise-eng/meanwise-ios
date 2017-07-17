//
//  VideoLoopPlayer.h
//  VideoPlayerDemo
//
//  Created by Hardik on 10/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <QuartzCore/QuartzCore.h>

@interface VidLoopPlayer : UIView
{

    AVPlayerViewController *playerViewControl;
    
    NSString *pathFile;
    
    BOOL isPlayerPaused;
    
}
-(void)setUp;
-(void)cleanUpAndsetPath:(NSString *)path;

-(void)killPlayer;
-(void)pauseBtnClicked:(id)sender;
-(void)resumeBtnClicked:(id)sender;

@end
