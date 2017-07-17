//
//  HMVideoPlayer.h
//  MeanWiseUX
//
//  Created by Hardik on 17/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "LoaderMin.h"
#import "VideoCacheManager.h"

@interface HMVideoPlayer : UIView
{
    
    NSString *urlStr;
    
 
    float videoLength;
    float timeRange;
    
    int playingLocal;
    
    UIView *viewLocal;
 
    UIView *progressView;
    UIView *loadedTimeRangeShowView;

    
}
@property (nonatomic, strong) AVPlayerViewController *playerViewController;
@property (nonatomic, strong) UIImageView *postIMGVIEW;
@property (nonatomic, strong) LoaderMin *videoLoader;

-(void)setURL:(NSString *)stringURL;
-(void)setUp;

-(void)cleanupPlayer;
-(void)deletePlayer;

@end


/*

 HMVideoPlayer *player=[[HMVideoPlayer alloc] initWithFrame:CGRectMake(0, 200*i,200
 , 200)];
 [self.view addSubview:player];
 [player setUp];
 [player setURL:[array objectAtIndex:i]];
 
 */
