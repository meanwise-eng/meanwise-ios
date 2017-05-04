//
//  ProfileFullScreen.h
//  MeanWiseUX
//
//  Created by Hardik on 12/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ASyncDisplayKit/AsyncDisplayKit.h>
#import "ZoomGestureView.h"
#import "ProfileAditionalScreen.h"
#import "APIObjects_ProfileObj.h"
#import <pop/POP.h>

@interface ProfileFullScreen : ZoomGestureView<ASNetworkImageNodeDelegate>
{
    APIObjects_ProfileObj *profileObj;
    
    UIImage *profileImage;
    
    ASNetworkImageNode *postIMGVIEW;
    
    id delegate;
    SEL pageChangeCallBackFunc;
    SEL downCallBackFunc;
    BOOL isStatic;
    
    NSIndexPath *globalPath;

    
    ProfileAditionalScreen *ck;
}

-(void)setUpProfileObj:(APIObjects_ProfileObj *)obj profileImage:(UIImage *)image;
-(void)setUpProfileObj:(APIObjects_ProfileObj *)obj;

-(void)setUpWithCellRect:(CGRect)rect;
-(void)setClosingFrame:(CGRect)rect;

-(void)setDelegate:(id)target andPageChangeCallBackFunc:(SEL)function1 andDownCallBackFunc:(SEL)function2;
-(void)setImage:(NSString *)string andNumber:(NSIndexPath *)indexPath;

@end
