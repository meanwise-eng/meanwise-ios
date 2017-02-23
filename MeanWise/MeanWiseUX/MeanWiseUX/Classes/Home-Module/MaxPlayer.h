//
//  MaxPlayer.h
//  MeanWiseUX
//
//  Created by Hardik on 17/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "LoaderMin.h"
#import "Constant.h"

@interface MaxPlayer : UIView
{
    NSString *urlStr;
    
    UIView *baseProgressView;
    UIView *currentProgressBar;
    UIView *bufferProgressBar;

}
@property (nonatomic, strong) AVPlayerViewController *playerViewController;
@property (nonatomic, strong) LoaderMin *videoLoader;

-(void)setUp;

-(void)setUnMute;
-(void)setMute;

-(void)setUpWithURLString:(NSString *)urlString;

-(void)playStart;
-(void)cleanWhenGoOut;
-(void)pausePlayer;
@end
