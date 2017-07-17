//
//  ShareBtn.h
//  ShareMenu
//
//  Created by Hardik on 01/02/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Social/Social.h"
#import "ShareObject.h"
#import <MessageUI/MessageUI.h>

@interface ShareDialogue : UIView <MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    
    CGPoint originPoint;
    
  
    
    NSMutableArray *btnArrays;
    BOOL isActive;
    
    UIViewController *controller;
    
    

    
    ////
    
    SHARE_fbObject *fbInstance;
    SHARE_twitterObject *twitInsance;
    SHARE_emailObject *emailInstance;
    SHARE_smsObject *smsInstance;
    SHARE_clipBoardObject *clipBoardInstance;
    
    
    int shareDirectly;
}

-(void)shareDirectly_Email;
-(void)shareDirectly_Facebook;
-(void)shareDirectly_Twitter;
-(void)shareDirectly_Copy;
-(void)shareDirectly_SMS;




-(void)setOriginPoint:(CGPoint)point;
-(void)setUpAll:(int)directly;
-(void)setUpViewController:(UIViewController *)viewcont;

-(void)setVariables;


-(void)setFBInstance:(SHARE_fbObject *)obj;
-(void)setTwitterInstance:(SHARE_twitterObject *)obj;
-(void)setEmailInstance:(SHARE_emailObject *)obj;
-(void)setSMSInstance:(SHARE_smsObject *)obj;
-(void)setClipBoardInstance:(SHARE_clipBoardObject *)obj;




@end



