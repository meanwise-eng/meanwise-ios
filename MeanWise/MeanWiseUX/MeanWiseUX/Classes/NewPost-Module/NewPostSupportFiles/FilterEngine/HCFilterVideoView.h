//
//  HCFilterVideoView.h
//  Exacto
//
//  Created by Hardik on 19/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HCFilterList.h"
#import "HCFilterHelper.h"

@interface HCFilterVideoView : UIView
{
    NSString *keyPath;
    NSURL *keyURL;
    AVPlayerViewController *loopPlayer;
    UIView *imageOverLay;
    CAGradientLayer *gLayer;

    NSMutableArray *CorefilterDB;
    NSMutableArray *MasterFilterDB;
    
    HCFilterList *filterListIB;
    
    HCFilterHelper *helper;

    int cFilterNo;
    AVMutableVideoComposition *currentCompo;
    BOOL isPlayerPaused;

}
-(void)setUp;

-(NSDictionary *)getFilterDict;


-(void)cleanUpAndsetPath:(NSString *)path; //Clean and Set New Path

-(void)killPlayer; //kill the player
-(void)pauseBtnClicked:(id)sender; //Pause the player
-(void)resumeBtnClicked:(id)sender; //Resume the player
-(void)setSoundSettings:(BOOL)flag; //Mute on/Off

@end
