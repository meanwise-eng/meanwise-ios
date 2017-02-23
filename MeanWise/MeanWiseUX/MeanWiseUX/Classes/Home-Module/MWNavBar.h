//
//  MWNavBar.h
//  MeanWiseUX
//
//  Created by Hardik on 18/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@interface MWNavBar : UIView

{
//    UIButton *userNavBtn;
//    UIButton *msgNavBtn;
    UIButton *backBtn;
    
    SEL rightFunc;
    SEL leftFunc;
    SEL centerFunc;
    id delegate;
    
}

@property (nonatomic, strong) UILabel *navDetailTitle;
@property (nonatomic, strong) UIButton *centerLogo;

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIVisualEffectView *blurEffectView;

-(void)setUp;
-(void)hideBar:(BOOL)flag;

-(void)setTarget:(id)target andCenterOpen:(SEL)func;
-(void)setTarget:(id)target andRightOpen:(SEL)func1;
-(void)setTarget:(id)target andLeftOpen:(SEL)func2;

-(void)pushInto;
-(void)pushOut;
-(void)comeIn;
@end
