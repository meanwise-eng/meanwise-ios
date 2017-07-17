//
//  GUIScaleManager.m
//  MeanWiseUX
//
//  Created by Hardik on 22/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "GUIScaleManager.h"
#import "ResolutionVersion.h"
#import "Constant.h"

@implementation GUIScaleManager

+(void)setTransform:(UIView *)view
{
    
    if(RX_isiPhone5Res)
    {
        view.frame=CGRectMake(0,0,375,667);
        view.transform=CGAffineTransformMakeScale(0.851574, 0.851574);
    }
    else if(RX_isiPhone7PlusRes)
    {
        view.frame=CGRectMake(0,0,375,667);
        view.transform=CGAffineTransformMakeScale(1.10344827586, 1.10344827586);

    }
    else if(RX_isiPhone4Res)
    {
        view.frame=CGRectMake(0,0,375,667);
        view.transform=CGAffineTransformMakeScale(0.7196401799, 0.7196401799);
        view.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
       
        
    

    }
    //0.7196401799,0.853333
    else
    {
        view.frame=[UIScreen mainScreen].bounds;
    }
    
}
+(void)setInverseTransform:(UIView *)view
{
     if(RX_isiPhone7PlusRes)
    {
        view.transform=CGAffineTransformMakeScale(1.0f/1.10344827586, 1.0f/1.10344827586);
        
    }
}
@end
