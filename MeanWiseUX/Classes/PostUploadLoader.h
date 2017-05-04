//
//  PostUploadLoader.h
//  MeanWiseUX
//
//  Created by Hardik on 27/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PostUploadLoader : NSObject
{
    UIView *statusBarNotifierView;
    UILabel *statusBarNotifierText;
    
    UIWindow *window;
    
    CGRect hiddenRect;
    CGRect showingRect;
    
    id delegate;
    SEL showFunc;
    SEL hideFunc;

}
-(void)setDelegate:(id)target andFunc1:(SEL)func1 andFunc2:(SEL)func2;

-(void)setUp;

-(void)showProgress;
-(void)hideProgress;
-(void)FailedProgress;

@end
