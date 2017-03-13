//
//  NotificationBadgeView.h
//  MeanWiseUX
//
//  Created by Hardik on 27/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIImageHM.h"
#import "NotificationsComponent.h"

@interface NotificationBadgeView : NSObject
{
    UIButton *fullSizeBtn;
    
    UIView *statusBarNotifierView;
    NotificationsComponent *expandedView;
    
    UIImageHM *profilePic;
    UILabel *notifierFullNameLBL;
    UILabel *notifierMsgLBL;
    UILabel *timeLBL;
    UIButton *buttonAccept;
    
    UIWindow *window;
    CGRect hiddenRect;
    CGRect showingRect;
    id delegate;
    SEL showFunc;
    SEL hideFunc;
    
    id objMain;
    
}
-(void)setDelegate:(id)target andFunc1:(SEL)func1 andFunc2:(SEL)func2;

-(void)setUp:(id)dataObj;

-(void)showProgress;
-(void)hideProgress;
@end
