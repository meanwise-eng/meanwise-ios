//
//  TrimSlider.h
//  VideoPlayerDemo
//
//  Created by Hardik on 21/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface TrimSlider : UIView
{
    NSString *urlPath;
    float videoDuration;
    
    float distanceFor2Seconds;
    
    UIView *baseSlider;
    UIView *node1Slider;
    UIView *node2Slider;
    UIView *progressSlider;
    
    UIView *prgressNodeToView1;
    UIView *prgressNodeToView2;

    UIView *playerMark;

    
    UILabel *blockView;
    
    int selected;
    
    id target;
    SEL onTrimmingDidChangeFunc;
    
}
-(void)setUp:(NSString *)path;
-(void)updateProgress:(CMTime)startTime endTime:(CMTime)endTime andCurrentTime:(CMTime)currentTime;
-(void)setTarget:(id)targetReceived andOnTrimmingDidChangeFunc:(SEL)func;


//Minimum duration required
//Don't allow them to cross two nodes



@end
