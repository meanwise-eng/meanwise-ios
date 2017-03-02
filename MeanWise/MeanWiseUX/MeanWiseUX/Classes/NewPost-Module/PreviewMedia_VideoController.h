//
//  PreviewMedia_VideoController.h
//  ExactResearch
//
//  Created by Hardik on 13/02/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FTIndicator.h"

@interface PreviewMedia_VideoController : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *filePathStr;
    BOOL isVideo;
  
    
    UIButton *EditingCorrectBtn;
    UIButton *EditingCancelBtn;
    UIButton *AddNewBtn;

    AVPlayerViewController *playerViewControl;

    NSMutableArray *arrayOfSentences;
    NSMutableArray *arrayHeightOfCell;
    
    
    UIScrollView *listOfTextTBL;
    NSMutableArray *visualElements;

    id target;
    SEL onSuccessFunc;
    SEL onCancelFunc;

}
-(void)setTarget:(id)targetReceived OnSuccess:(SEL)func1 OnFail:(SEL)func2;

-(void)setUpWithString:(NSString *)strPath;
@end
