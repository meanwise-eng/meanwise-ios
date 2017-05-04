//
//  TestView.h
//  MeanWiseUX
//
//  Created by Hardik on 01/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMVideoPlayer.h"

@interface TestView : UIView
{
    HMVideoPlayer *player;
    NSArray *videoURLarray;
}
-(void)setUp;

@end
