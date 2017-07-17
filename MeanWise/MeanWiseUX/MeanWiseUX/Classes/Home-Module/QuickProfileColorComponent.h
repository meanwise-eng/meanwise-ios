//
//  NotificationsComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 05/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"

@interface QuickProfileColorComponent : UIView
{
   
    UIButton *backBtn;
    id delegate;
    SEL backBtnClickedFunc;
    
    NSArray *mainColorArray;
    NSMutableArray *allButtons;
    
    NSString *selectedColor;
}
-(void)setUp:(NSString *)selectC;
-(void)setTarget:(id)target andBackBtnFunc:(SEL)func1;


@end
