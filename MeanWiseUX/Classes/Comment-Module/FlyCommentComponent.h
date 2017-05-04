//
//  FlyCommentComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 21/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@interface FlyCommentComponentCell : UIView
{
    UIView *shadowView;
    UIImageView *profileIMGVIEW;
    UILabel *nameLBL;
    int height;
    
}
-(int)setUp:(NSString *)string;
-(int)getHeightValue;
-(void)fadeOut;

@end


@interface FlyCommentComponent : UIView
{

    
    NSMutableArray *arrayData;
    NSMutableArray *cellStack;
    int currentIndex;
    
    NSMutableArray *displayStack;
}
-(void)setUp;
-(void)addNewMessage;

@end

