//
//  ProfileWindowFullControl.h
//  MeanWiseUX
//
//  Created by Hardik on 12/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomPinchCircularModel.h"
#import "APIObjects_ProfileObj.h"
#import "UIImageHM.h"

#import "ProfileAditionalScreen.h"
#import "ProfileWindowAditionalScreen.h"

@interface ProfileWindowFullControl : ZoomPinchCircularModel
{
    APIObjects_ProfileObj *profileObj;
    
    UIImageHM *postIMGVIEW;
    
    id delegate;
    SEL pageChangeCallBackFunc;
    SEL downCallBackFunc;
    
    NSIndexPath *globalPath;
    
    
    ProfileAditionalScreen *ck;
    ProfileWindowAditionalScreen *mk;
    
    
}
-(void)setTarget:(id)target onCloseBtn:(SEL)func;

-(void)setUpProfileObj:(APIObjects_ProfileObj *)obj;

-(void)setUpCustom:(CGRect)rect;


@end
