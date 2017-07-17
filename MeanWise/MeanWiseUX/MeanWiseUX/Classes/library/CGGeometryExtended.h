//
//  helperModule.h
//  MeanWiseUX
//
//  Created by Hardik on 23/08/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#define CRX_MAX  [UIScreen mainScreen].bounds.size.height/568.0f
#define CRH_MAX  [UIScreen mainScreen].bounds.size.height
#define CRW_MAX  [UIScreen mainScreen].bounds.size.width


CG_INLINE CGPoint CGXPointMake(CGFloat x, CGFloat y);


CG_INLINE CGRect CGXRectMake(CGFloat x, CGFloat y, CGFloat width,
                            CGFloat height);

CG_INLINE CGFloat
CGX_scaleFactor();


CG_INLINE CGFloat
CGX_ScreenMaxWidth();

CG_INLINE CGFloat
CGX_ScreenMaxHeight();

CG_INLINE CGFloat
CGX_DeviceMaxWidth();

CG_INLINE CGFloat
CGX_DeviceMaxHeight();



CG_INLINE
CGSize CGXSizeMake(CGFloat width, CGFloat height);


CG_INLINE CGFloat
CGX_scaleFactor()
{
    return CRX_MAX;
}

CG_INLINE
CGSize CGXSizeMake(CGFloat width, CGFloat height)
{
        CGSize size; size.width = width*CRX_MAX; size.height = height*CRX_MAX; return size;
}


CG_INLINE CGPoint
CGXPointMake(CGFloat x, CGFloat y)
{
    CGPoint p; p.x = x*CRX_MAX; p.y = y*CRX_MAX; return p;
}


CG_INLINE CGRect
CGXRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    
    CGRect rect;
    rect.origin.x = x*CRX_MAX; rect.origin.y = y*CRX_MAX;
    rect.size.width = width*CRX_MAX; rect.size.height = height*CRX_MAX;
    return rect;
}

CG_INLINE CGFloat
CGX_ScreenMaxWidth()
{
//    return CRW_MAX;
    return 320;

}


CG_INLINE CGFloat
CGX_ScreenMaxHeight()
{
    return 568;
   
}

CG_INLINE CGFloat
CGX_DeviceMaxWidth()
{
        return CRW_MAX;
}

CG_INLINE CGFloat
CGX_DeviceMaxHeight()
{

     return CRH_MAX;

}




