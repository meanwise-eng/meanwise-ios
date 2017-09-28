//
//  HMPlayer.h
//  VideoPlayerDemo
//
//  Created by Hardik on 11/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "LoaderMin.h"
#import "HMPlayerManager.h"
#import "VideoCacheManager.h"

@interface HMPlayer : UIView
{
    NSString *urlStr;

//    UIView *baseProgressView;
//    UIView *currentProgressBar;
//    UIView *bufferProgressBar;
    
    BOOL isPlayerShouldPlay;
    
    NSString *debugNumber;
    AVPlayerViewController *playerViewController;
    LoaderMin *videoLoader;
    NSString *screenIdentifier;
    
    NSNumber *refreshIdentifier;
    
    BOOL isVideoLocal;
}
-(void)setUp;
-(void)setPlayerScreenIdeantifier:(NSString *)string;
-(void)setUpRefreshIdentifier:(NSNumber *)number;
-(void)setDebugNumber:(NSString *)number;
-(void)setURL:(NSString *)url;
-(void)playerPlay;
-(void)playerPause;

-(void)setIfItsPanoroma:(BOOL)flag;

@end


/*

 
 //    HMPlayer *player=[[HMPlayer alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
 //    [self.view addSubview:player];
 //    [player setUp];
 //    [player setURL:@"https://vt.media.tumblr.com/tumblr_oi3vig8Lqp1qbct3j.mp4"];
 //    [player playerPlay];
 //    player.center=self.view.center;
 //
 
*/
