//
//  WalkthroughControl.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "LoginComponent.h"

@interface WalkthroughControl : UIView  <UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UIPageControl * pageControl;
    
    UIButton *skipBtn;
    
    id delegate;
    SEL skipButtonClickedFunc;
    
    LoginComponent *component;

    SEL func1;
    SEL func2;
}
-(void)setUp;
-(void)setTarget:(id)target andFunc1:(SEL)func;
-(void)setTarget:(id)target andFunc01:(SEL)func;
-(void)setTarget:(id)target andFunc02:(SEL)func;

@end

/*

 WalkthroughControl *c=[[WalkthroughControl alloc] initWithFrame:self.view.bounds];
 [self.view addSubview:c];
 [c setUp];
 
 */
