//
//  SharePostVC.h
//  MeanWiseUX
//
//  Created by Hardik on 08/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>


@interface SharePostVC : UIView <MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    
    ViewController *mainVCRef;
    MFMailComposeViewController *mail;
    MFMessageComposeViewController *messageController;
    
}
-(void)shareOn:(NSDictionary *)dict andNetwork:(int)network withVC:(ViewController *)vc;


@end
