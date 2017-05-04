//
//  UIFilterImageView.m
//  VideoPlayerDemo
//
//  Created by Hardik on 27/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "UIFilterImageView.h"
#import "FTIndicator.h"

@implementation UIFilterImageView

-(NSString *)getCompressedPathFromImagePath:(NSString *)sourcePath
{
    UIImage *inputImage=[UIImage imageWithContentsOfFile:sourcePath];
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = (int)(1524);
    
    NSData *imageData = UIImageJPEGRepresentation(inputImage, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        NSLog(@"compression=%f",compression);
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(inputImage, compression);
    }
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"compressedFile.jpg"];
    
    
    [imageData writeToFile:savedImagePath atomically:NO];
    
    NSLog(@"FILTERED IMAGE: %@",savedImagePath);
    
    return savedImagePath;
    
}
-(void)createdImage
{
    
    effectedImages=[[NSMutableArray alloc] init];
    effectNameList=[[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    

    for (int i=0;i<arrayOfEffects.count+1; i++) {
        
        
   
        dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
        dispatch_async(myQueue, ^{
            
            UIImage *image=[UIImage imageWithContentsOfFile:imagePath];
            
            NSData *imageData = UIImageJPEGRepresentation([self preEffect:image WithNo:i], 1.0f);
            
            NSString *path=[NSString stringWithFormat:@"effected%d.jpg",i];
            
            NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:path];
            [imageData writeToFile:savedImagePath atomically:NO];
            
            [effectedImages addObject:savedImagePath];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                
                if(i==arrayOfEffects.count)
                {
                    [effectNameList addObject:@"Original"];

                }
                else
                {
                    [effectNameList addObject:[arrayOfEffects objectAtIndex:i]];
   
                }
                
            });
        }); 


        
    }


}


- (UIImage *)preEffect:(UIImage *)image WithNo:(int)no
{
    if(no==arrayOfEffects.count)
    {
        return image;
    }
    CIImage *beginImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *exposure = [CIFilter filterWithName:[arrayOfEffects objectAtIndex:no]];
    [exposure setValue:beginImage forKey:kCIInputImageKey];
    CIImage *exposurePlus=exposure.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgiimage = [context createCGImage:exposurePlus fromRect:exposurePlus.extent];
    //UIImage *newImage = [UIImage imageWithCGImage:cgiimage];
    UIImage *newImage = [UIImage imageWithCGImage:cgiimage scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(cgiimage);
    
    return newImage;
}


-(void)setUpWithImage:(NSString *)path
{
 
    imagePath=path;
    
    
   // imagePath=[self getCompressedPathFromImagePath:path];
    
    
    arrayOfImageViews=[[NSMutableArray alloc] init];
    arrayOfEffects=@[@"CIPhotoEffectMono",
                     @"CIPhotoEffectNoir",
                     @"CIPhotoEffectProcess",
                     @"CIPhotoEffectTonal",
                     @"CIPhotoEffectTransfer",
                     @"CIPhotoEffectChrome",
                     @"CIPhotoEffectFade",
                     @"CIPhotoEffectInstant",
                     @"CISepiaTone",
                     ];
    
    
    
    [self createdImage];

    
    nextImageNo=0;
   
    
    
    UIImageView *imageV=[[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:imageV];
    imageV.image=[UIImage imageWithContentsOfFile:imagePath];
    imageV.contentMode=UIViewContentModeScaleAspectFill;
    
    [arrayOfImageViews addObject:imageV];
  

    
   /*
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    tapGesture.cancelsTouchesInView = YES;
    tapGesture.delaysTouchesBegan = YES;

    [self addGestureRecognizer:tapGesture];
    
    */

}
-(void)generateNextEffectImage
{
   
    
    nextEffectImage=[UIImage imageWithContentsOfFile:[effectedImages objectAtIndex:nextImageNo]];
    
    
}
/*- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    
    
    nextImageNo++;
    
    if(nextImageNo+1>arrayOfEffects.count)
    {
        nextImageNo=0;
    }

    if(effectedImages.count>nextImageNo+1)
    {
      //  NSLog(@"%ld",effectedImages.count);
        
        if (sender.state == UIGestureRecognizerStateRecognized) {
        
            
            NSString *effectName=[[effectNameList objectAtIndex:nextImageNo] stringByReplacingOccurrencesOfString:@"CIPhotoEffect" withString:@""];

            effectName=[effectName stringByReplacingOccurrencesOfString:@"CI" withString:@""];


            effectName=[NSString stringWithFormat:@"FILTER: %@",effectName];
            
            [FTIndicator showToastMessage:[effectName uppercaseString]];
        
        CGPoint point    = [sender locationInView:self];
        
        NSLog(@"%@",NSStringFromCGPoint(point));
        [self addNewFilterAt:point];
        

        }
        
    }
    else
    {
        [FTIndicator showToastMessage:@"Preaparing Effects.."];
    }
}*/

-(void)generateNewEffectPoint:(CGPoint)point
{
    nextImageNo++;
    
    if(nextImageNo+1>arrayOfEffects.count)
    {
        nextImageNo=0;
    }
    
    if(effectedImages.count>nextImageNo+1)
    {
        //  NSLog(@"%ld",effectedImages.count);
        
        
            
            NSString *effectName=[[effectNameList objectAtIndex:nextImageNo] stringByReplacingOccurrencesOfString:@"CIPhotoEffect" withString:@""];
            
            effectName=[effectName stringByReplacingOccurrencesOfString:@"CI" withString:@""];
        effectName=[NSString stringWithFormat:@"%@",effectName];

        
            [FTIndicator showToastMessage:[effectName uppercaseString]];
            
        
            NSLog(@"%@",NSStringFromCGPoint(point));
            [self addNewFilterAt:point];
            
            
        
    }
    else
    {
        [FTIndicator showToastMessage:@"Preaparing Effects.."];
    }
}
-(void)addNewFilterAt:(CGPoint)point
{
    
    
    
    [self generateNextEffectImage];

    
    UIImageView *imageV=[[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:imageV];
    imageV.image=nextEffectImage;
    imageV.contentMode=UIViewContentModeScaleAspectFill;
    [arrayOfImageViews addObject:imageV];
    
    
    
    
    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
    layer.frame = imageV.bounds;
    [layer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x, point.y, 0, 0)] CGPath]];
    imageV.layer.mask = layer;
    

    CGPathRef pathNew=[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-1000, -1000, 2000, 2000)] CGPath];
    
    CABasicAnimation *morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.duration = 0.7;
    morph.toValue = (__bridge id) pathNew;
    morph.removedOnCompletion=false;
    morph.fillMode  = kCAFillModeForwards;

    [layer addAnimation:morph forKey:nil];

    if(arrayOfImageViews.count>2)
    {
        UIImageView *image=[arrayOfImageViews objectAtIndex:0];
        image.image=nil;
        [image removeFromSuperview];
        [arrayOfImageViews removeObject:image];
        
    }
    

    

}
- (UIImage *)effect6:(UIImage *)image
{
    if(nextImageNo==-1)
    {
        return image;
    }
    CIImage *beginImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *exposure = [CIFilter filterWithName:[arrayOfEffects objectAtIndex:nextImageNo]];
    [exposure setValue:beginImage forKey:kCIInputImageKey];
    CIImage *exposurePlus=exposure.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgiimage = [context createCGImage:exposurePlus fromRect:exposurePlus.extent];
    //UIImage *newImage = [UIImage imageWithCGImage:cgiimage];
    UIImage *newImage = [UIImage imageWithCGImage:cgiimage scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(cgiimage);
    
    return newImage;
}


@end
