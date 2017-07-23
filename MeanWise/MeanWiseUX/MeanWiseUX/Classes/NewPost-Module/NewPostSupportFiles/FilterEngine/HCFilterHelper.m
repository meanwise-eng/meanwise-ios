//
//  HCFilterHelper.m
//  Exacto
//
//  Created by Hardik on 19/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "HCFilterHelper.h"

@implementation HCFilterHelper

typedef enum {
    UIImageFilterTypeNone = 0,
    UIImageFilterTypeInstant = 1,
    UIImageFilterTypeNoir = 2,
    UIImageFilterTypeFade = 3,
    UIImageFilterTypeTransfer = 4,
    UIImageFilterTypeProcess = 5,
    UIImageFilterTypeTonal = 6,
    UIImageFilterTypeChrome = 7,
    UIImageFilterTypeZoomBlur=8,
    
    UIImageFilterTypeColorClamp=9,
    
} UIImageFilterType;

-(void)setForView:(UIView *)view;
{
    mainView=view;
}
-(UIImage *)getUIImageFromName:(NSString *)string
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName=[NSString stringWithFormat:@"%@.jpg",string];
    
    
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSData *pngData = [NSData dataWithContentsOfFile:filePath];
    
    return [UIImage imageWithData:pngData];
}

-(void)saveFile:(UIImage *)image withName:(NSString *)string
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:string];
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    // Save image.
    [UIImageJPEGRepresentation(image,1.0f) writeToFile:filePath atomically:YES];
    
}
- (UIImage *)makeUIImageFromCIImage:(CIImage *)ciImage
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:ciImage fromRect:[ciImage extent]];
    
    UIImage* uiImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return uiImage;
}
- (CAGradientLayer *)flavescentGradientLayer:(UIColor *)color1 andColor2:(UIColor *)color2 andPoints:(NSArray *)pointArray
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = mainView.bounds;
    
    
    if(pointArray!=nil)
    {
        gradient.startPoint = [[pointArray objectAtIndex:0] CGPointValue];
        gradient.endPoint = [[pointArray objectAtIndex:1] CGPointValue];
    }
    gradient.colors = [NSArray arrayWithObjects:(id)[color1 CGColor],(id)[color2 CGColor], nil];
    
    return gradient;
}
-(void)showFancyToastWithMessage:(NSString *)string
{
    fancyToast=[[UILabel alloc] initWithFrame:mainView.bounds];
    fancyToast.textAlignment=NSTextAlignmentCenter;
    [mainView addSubview:fancyToast];
    fancyToast.textColor=[UIColor whiteColor];
    fancyToast.font=[UIFont boldSystemFontOfSize:40];
    fancyToast.text=[string uppercaseString];

    
    [UIView animateWithDuration:0.5 animations:^{
        
        //fancyToast.transform=CGAffineTransformMakeScale(4, 4);
        fancyToast.alpha=0;
        fancyToast.center=CGPointMake(fancyToast.center.x, fancyToast.center.y-50);
        
        
    } completion:^(BOOL finished) {
        [fancyToast removeFromSuperview];
        fancyToast=nil;
        
        
    }];
    
    
    
}
- (void)rippleWithView:(UIView *)view center:(CGPoint)center  colorFrom:(UIColor *)colorFrom colorTo:(UIColor *)colorTo
{
    if (!view) {
        return;
    }
    CGFloat radius = 20;
    UIView *ripple = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, radius, radius)];
    ripple.layer.cornerRadius = radius * 0.5f;
    ripple.backgroundColor = colorFrom;
    ripple.alpha = 1.0f;
    [view insertSubview:ripple atIndex:5];
    ripple.center = center;
    CGFloat scale = 200;
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        ripple.transform = CGAffineTransformMakeScale(scale, scale);
        ripple.alpha = 0.0f;
        ripple.backgroundColor = colorTo;
    } completion:^(BOOL finished) {
        [ripple removeFromSuperview];
    }];
}

-(NSMutableArray *)setUpCoreFilterData
{
    
    NSMutableArray *CorefilterDB=[[NSMutableArray alloc] init];
    
    {
        
        
        NSDictionary *dictFull=@{@"ENAME":@(UIImageFilterTypeNone),
                                 @"DATA":@[
                                         ]};
        [CorefilterDB addObject:dictFull];
    }
    
    
    {
        NSDictionary *dict1=@{@"filter":@"CIPhotoEffectInstant"};
        
        NSDictionary *dictFull=@{@"ENAME":@(UIImageFilterTypeInstant),
                                 @"DATA":@[
                                         dict1,
                                         ]};
        [CorefilterDB addObject:dictFull];
    }
    {
        NSDictionary *dict1=@{@"filter":@"CIPhotoEffectNoir"};
        
        NSDictionary *dictFull=@{@"ENAME":@(UIImageFilterTypeNoir),
                                 @"DATA":@[
                                         dict1,
                                         ]};
        [CorefilterDB addObject:dictFull];
    }
    
    {
        NSDictionary *dict1=@{@"filter":@"CIPhotoEffectFade"};
        NSDictionary *dict2=@{@"filter":@"CIGloom"};

        NSDictionary *dictFull=@{@"ENAME":@(UIImageFilterTypeFade),
                                 @"DATA":@[
                                         dict1,dict2,
                                         ]};
        [CorefilterDB addObject:dictFull];
    }
    {
        NSDictionary *dict1=@{@"filter":@"CIPhotoEffectTransfer"};
        
        NSDictionary *dictFull=@{@"ENAME":@(UIImageFilterTypeTransfer),
                                 @"DATA":@[
                                         dict1,
                                         ]};
        [CorefilterDB addObject:dictFull];
    }
    
    {
        NSDictionary *dict1=@{@"filter":@"CIPhotoEffectProcess"};
        NSDictionary *dict2=@{@"filter":@"CIGloom"};
        
        NSDictionary *dictFull=@{@"ENAME":@(UIImageFilterTypeProcess),
                                 @"DATA":@[
                                         dict1,dict2,
                                         ]};
        [CorefilterDB addObject:dictFull];
    }
    {
        NSDictionary *dict1=@{@"filter":@"CIPhotoEffectTonal"};
        
        NSDictionary *dictFull=@{@"ENAME":@(UIImageFilterTypeTonal),
                                 @"DATA":@[
                                         dict1,
                                         ]};
        [CorefilterDB addObject:dictFull];
    }
   
    
    {
        NSDictionary *dict1=@{@"filter":@"CIPhotoEffectChrome"};
        
        NSDictionary *dictFull=@{@"ENAME":@(UIImageFilterTypeChrome),
                                 @"DATA":@[
                                         dict1,
                                         ]};
        [CorefilterDB addObject:dictFull];
    }
    {
        
        NSDictionary *dict1=@{@"filter":@"CIZoomBlur",@"inputCenter":@"CENTER",@"inputAmount":@2.0f};
        
        NSDictionary *dictFull=@{@"ENAME":@(UIImageFilterTypeZoomBlur),
                                 @"DATA":@[
                                         dict1,
                                         ]};
        [CorefilterDB addObject:dictFull];
    }
    
  
   
    
    ////////// Test Filters
    
    {
        NSDictionary *dict1=@{@"filter":@"CIColorClamp",@"inputMinComponents":[CIVector vectorWithX:0.2 Y:0.0 Z:0.0 W:1],@"inputMaxComponents":[CIVector vectorWithX:0.8 Y:0.8 Z:0.9 W:1]};
        
        NSDictionary *dictFull=@{@"ENAME":@(UIImageFilterTypeColorClamp),
                                 @"DATA":@[
                                         dict1,
                                         ]};
        [CorefilterDB addObject:dictFull];
    }
    
    
    
    
    return CorefilterDB;
}


-(NSMutableArray *)setUpMasterVideoFilterData
{
    NSMutableArray *MasterFilterDB=[[NSMutableArray alloc] init];
    {
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
        
        
        NSArray *colorArray=[[NSArray alloc] init];
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeNone),@"colors":colorArray,@"MNAME":@"NONE",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    
    
    {
        
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
        
        NSArray *colorArray=[[NSArray alloc] init];
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeFade),@"colors":colorArray,@"MNAME":@"A1",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    
    {
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
        
        
        NSArray *colorArray=[[NSArray alloc] init];
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeTonal),@"colors":colorArray,@"MNAME":@"A2",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    
    
    
    {
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
        
        UIColor *color1=
        [UIColor colorWithRed:0.79 green:0.18 blue:0.77 alpha:0.23];
        UIColor *color2=
        [UIColor colorWithRed:0.38 green:0.76 blue:0.92 alpha:0.49];
        NSArray *colorArray=[NSArray arrayWithObjects:color1,color2, nil];
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeChrome),@"colors":colorArray,@"MNAME":@"A3",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    {
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
        
        UIColor *color1=
        [UIColor colorWithRed:0.93 green:0.04 blue:0.47 alpha:0.40];
        UIColor *color2=
        [UIColor colorWithRed:1.00 green:0.42 blue:0.00 alpha:0.3];
        NSArray *colorArray=[NSArray arrayWithObjects:color1,color2, nil];
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeProcess),@"colors":colorArray,@"MNAME":@"A4",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    
    
    {
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
        
        UIColor *color1=
        [UIColor colorWithRed:0.86 green:0.89 blue:0.36 alpha:0.30];
        UIColor *color2=
        [UIColor colorWithRed:0.27 green:0.71 blue:0.29 alpha:0.10];
        NSArray *colorArray=[NSArray arrayWithObjects:color1,color2, nil];
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeTransfer),@"colors":colorArray,@"MNAME":@"A5",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    {
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
        
        UIColor *color1=
        
        [UIColor colorWithRed:0.87f green:0.87f blue:0.02f alpha:0.20f];
        UIColor *color2=
        
        [UIColor colorWithRed:0.9f green:0.0f blue:0.0f alpha:0.10f];
        NSArray *colorArray=[NSArray arrayWithObjects:color1,color2, nil];
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeInstant),@"colors":colorArray,@"MNAME":@"A6",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    
    {
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
        
        UIColor *color1=
        
        [UIColor colorWithRed:0.86 green:0.99 blue:0.45 alpha:0.1];
        UIColor *color2=
        [UIColor colorWithRed:0.46 green:0.71 blue:0.91 alpha:0.1];
        NSArray *colorArray=[NSArray arrayWithObjects:color1,color2, nil];
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeProcess),@"colors":colorArray,@"MNAME":@"A7",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    
    
    {
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
        
        UIColor *color1=
        [UIColor colorWithRed:1.00 green:0.42 blue:0.70 alpha:0.34];
        UIColor *color2=
        [UIColor colorWithRed:1/255.0f green:71/255.0f blue:145/255.0f alpha:0.23];
        NSArray *colorArray=[NSArray arrayWithObjects:color1,color2, nil];
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeNoir),@"colors":colorArray,@"MNAME":@"A8",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    
    
    
    {
        UIColor *color1=
        [UIColor colorWithRed:0.66 green:0.36 blue:0.80 alpha:0.3];
        UIColor *color2=
        [UIColor colorWithRed:0.31 green:0.86 blue:0.04 alpha:0.2];
        NSArray *colorArray=[NSArray arrayWithObjects:color1,color2, nil];
        
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0, 0)],[NSValue valueWithCGPoint:CGPointMake(1, 1)], nil];
        
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeInstant),@"colors":colorArray,@"MNAME":@"A9",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    
    return MasterFilterDB;
}
-(NSMutableArray *)setUpMasterImageFilterData
{
    
    NSMutableArray *MasterFilterDB=[[NSMutableArray alloc] init];
    
    
    
    //    for(int i=0;i<20;i++)
    //    {
    //
    //        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
    //
    //        UIColor *color1=[UIColor colorWithRed:(arc4random()%100)*0.01 green:(arc4random()%100)*0.01 blue:(arc4random()%100)*0.01 alpha:(arc4random()%80)*0.01];
    //        UIColor *color2=[UIColor colorWithRed:(arc4random()%100)*0.01 green:(arc4random()%100)*0.01 blue:(arc4random()%100)*0.01 alpha:(arc4random()%80)*0.01];
    //
    //        color1=[UIColor clearColor];
    //        color2=[UIColor clearColor];
    //
    //        NSArray *colorArray=[NSArray arrayWithObjects:color1,color2, nil];
    //        NSDictionary *dict=@{@"filter":@(arc4random()%9),@"colors":colorArray,@"MNAME":[NSString stringWithFormat:@"B%d",arc4random()%300],@"points":pointArray};
    //        [MasterFilterDB addObject:dict];
    //
    //    }
    
    //    for(int i=0;i<20;i++)
    //    {
    //
    //        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
    //
    //        UIColor *color1=[UIColor colorWithRed:(arc4random()%100)*0.01 green:(arc4random()%100)*0.01 blue:(arc4random()%100)*0.01 alpha:(arc4random()%80)*0.01];
    //        UIColor *color2=[UIColor colorWithRed:(arc4random()%100)*0.01 green:(arc4random()%100)*0.01 blue:(arc4random()%100)*0.01 alpha:(arc4random()%80)*0.01];
    //
    //        NSArray *colorArray=[NSArray arrayWithObjects:color1,color2, nil];
    //        NSDictionary *dict=@{@"filter":@(arc4random()%9),@"colors":colorArray,@"MNAME":[NSString stringWithFormat:@"B%d",arc4random()%300],@"points":pointArray};
    //        [MasterFilterDB addObject:dict];
    //
    //    }
    //
    
    
    
    
    
    ////
    
    
    {
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
        
        
        NSArray *colorArray=[[NSArray alloc] init];
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeNone),@"colors":colorArray,@"MNAME":@"NONE",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    
    
    {
        
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
        
        NSArray *colorArray=[[NSArray alloc] init];
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeZoomBlur),@"colors":colorArray,@"MNAME":@"A1",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    
    {
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
        
        
        NSArray *colorArray=[[NSArray alloc] init];
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeTonal),@"colors":colorArray,@"MNAME":@"A2",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    
    
    
    {
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
        
        UIColor *color1=
        [UIColor colorWithRed:0.79 green:0.18 blue:0.77 alpha:0.23];
        UIColor *color2=
        [UIColor colorWithRed:0.38 green:0.76 blue:0.92 alpha:0.49];
        NSArray *colorArray=[NSArray arrayWithObjects:color1,color2, nil];
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeChrome),@"colors":colorArray,@"MNAME":@"A3",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    {
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
        
        UIColor *color1=
        [UIColor colorWithRed:0.93 green:0.04 blue:0.47 alpha:0.40];
        UIColor *color2=
        [UIColor colorWithRed:1.00 green:0.42 blue:0.00 alpha:0.3];
        NSArray *colorArray=[NSArray arrayWithObjects:color1,color2, nil];
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeProcess),@"colors":colorArray,@"MNAME":@"A4",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    
    
    {
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
        
        UIColor *color1=
        [UIColor colorWithRed:0.86 green:0.89 blue:0.36 alpha:0.30];
        UIColor *color2=
        [UIColor colorWithRed:0.27 green:0.71 blue:0.29 alpha:0.10];
        NSArray *colorArray=[NSArray arrayWithObjects:color1,color2, nil];
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeTransfer),@"colors":colorArray,@"MNAME":@"A5",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    {
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
        
        UIColor *color1=
        
        [UIColor colorWithRed:0.87f green:0.87f blue:0.02f alpha:0.20f];
        UIColor *color2=
        
        [UIColor colorWithRed:0.9f green:0.0f blue:0.0f alpha:0.10f];
        NSArray *colorArray=[NSArray arrayWithObjects:color1,color2, nil];
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeInstant),@"colors":colorArray,@"MNAME":@"A6",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    
    {
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
        
        UIColor *color1=
        
        [UIColor colorWithRed:0.86 green:0.99 blue:0.45 alpha:0.1];
        UIColor *color2=
        [UIColor colorWithRed:0.46 green:0.71 blue:0.91 alpha:0.1];
        NSArray *colorArray=[NSArray arrayWithObjects:color1,color2, nil];
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeProcess),@"colors":colorArray,@"MNAME":@"A7",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    
    
    {
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0, 0)], nil];
        
        UIColor *color1=
        [UIColor colorWithRed:1.00 green:0.42 blue:0.70 alpha:0.34];
        UIColor *color2=
        [UIColor colorWithRed:1/255.0f green:71/255.0f blue:145/255.0f alpha:0.23];
        NSArray *colorArray=[NSArray arrayWithObjects:color1,color2, nil];
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeNoir),@"colors":colorArray,@"MNAME":@"A8",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    
    
    
    {
        UIColor *color1=
        [UIColor colorWithRed:0.66 green:0.36 blue:0.80 alpha:0.3];
        UIColor *color2=
        [UIColor colorWithRed:0.31 green:0.86 blue:0.04 alpha:0.2];
        NSArray *colorArray=[NSArray arrayWithObjects:color1,color2, nil];
        
        NSArray *pointArray=[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0, 0)],[NSValue valueWithCGPoint:CGPointMake(1, 1)], nil];
        
        NSDictionary *dict=@{@"filter":@(UIImageFilterTypeInstant),@"colors":colorArray,@"MNAME":@"A9",@"points":pointArray};
        [MasterFilterDB addObject:dict];
    }
    
    return MasterFilterDB;
    
}
@end
