//
//  SignUpTransitionScreen.h
//  MeanWiseUX
//
//  Created by Hardik on 25/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIManager.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "ViewController.h"


@interface SignUpTransitionScreen : UIView
{
    
    NSString *accessToken;
    UILabel *msgLBL;
    UIImageView *loaderImageView;
    
    id delegate;
    SEL successFunc;
    SEL failFunc;
    
    APIManager *manager;
    
    
    NSString *emailUserId;
    
}
-(void)setUpForSignup:(id)target andFunc1:(SEL)func1 andFunc2:(SEL)func2;

@end
