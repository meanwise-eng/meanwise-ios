//
//  TutorialComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TutorialComponent : UIView  <UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UIPageControl * pageControl;
    
    UIButton *skipBtn;
    
    id delegate;
    SEL skipButtonClickedFunc;
    
    
    
    int numberOfItems;
}
-(void)setUp;
-(void)setTarget:(id)target andDoneBtnCallBack:(SEL)func;

@end

