//
//  HCDropDown.h
//  Exacto
//
//  Created by Hardik on 23/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCDropDown : UIView
{

    int touchEnabled;
    UIView *popUpView;
    NSArray *values;
    
    id target;
    SEL callBackFunc;
}
-(void)setPopUpPoint:(CGPoint)point;

-(void)setUp:(NSArray *)valueArray target:(id)tReceived callBack:(SEL)callBack;

@end
