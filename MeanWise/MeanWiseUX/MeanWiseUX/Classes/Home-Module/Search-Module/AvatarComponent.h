//
//  AvatarComponent.h
//  MeanWiseRedesignHelper
//
//  Created by Hardik on 31/08/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageHM.h"

@interface AvatarComponent : UIView
{
    UIView *bgOverLay;
    UIImageHM *profileImgView;
    
    NSString *userId;
    
    BOOL isHiddenFlag;

}
-(void)setUp:(NSString *)avatarPath andNo:(int)no;
-(void)clicked:(id)sender;

-(NSString *)getUserIdStr;
-(void)setURLString:(NSString *)path andUserId:(NSString *)uIdStr withColorString:(NSString *)color;

-(void)setAnimationWithHide:(BOOL)flag;

@end

