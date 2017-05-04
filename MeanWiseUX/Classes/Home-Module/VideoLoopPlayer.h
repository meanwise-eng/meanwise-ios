//
//  VideoLoopPlayer.h
//  MeanWiseUX
//
//  Created by Hardik on 13/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface VideoLoopPlayer : UIView
{
    
    AVPlayerViewController *playerViewController;
}

-(void)setUpWithURL:(NSString *)string;
-(void)clearLoopPlayer;

@end
