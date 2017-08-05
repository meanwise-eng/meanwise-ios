//
//  HCFilterVideoView.m
//  Exacto
//
//  Created by Hardik on 19/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "AnalyticsMXManager.h"
#import "HCFilterVideoView.h"

@implementation HCFilterVideoView

-(void)setSoundSettings:(BOOL)flag;
{
    loopPlayer.player.muted=flag;
}
-(void)cleanUpAndsetPath:(NSString *)path; //Clean and Set New Path
{
    if(loopPlayer.player!=nil)
    {
        [loopPlayer.player pause];
        loopPlayer.player=nil;
    }
    isPlayerPaused=false;

    keyPath=path;
    keyURL=[NSURL fileURLWithPath:path];
    
    loopPlayer.player=[[AVPlayer alloc] initWithURL:keyURL];

    [loopPlayer.player play];
    
    [self autoplayContinue:nil];


    
}
-(void)setUp
{
    
    
    helper=[[HCFilterHelper alloc] init];
    [helper setForView:self];

    CorefilterDB=[helper setUpCoreFilterData];
    MasterFilterDB=[helper setUpMasterVideoFilterData];

    cFilterNo=0;
    
    
    loopPlayer=[[AVPlayerViewController alloc] init];
    [self addSubview:loopPlayer.view];
    
    loopPlayer.view.frame=self.bounds;
    loopPlayer.showsPlaybackControls=false;
    loopPlayer.view.userInteractionEnabled=false;
    
    
    imageOverLay=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:imageOverLay];
    imageOverLay.contentMode=UIViewContentModeScaleAspectFill;
    imageOverLay.userInteractionEnabled=false;
    
    
    gLayer=[helper flavescentGradientLayer:[UIColor clearColor] andColor2:[UIColor clearColor] andPoints:nil];
    [imageOverLay.layer insertSublayer:gLayer atIndex:0];


    
//    filterListIB=[[HCFilterList alloc] initWithFrame:CGRectMake(0, self.frame.size.height-120, self.frame.size.width, 100)];
//    [self addSubview:filterListIB];
//    [filterListIB setUp:MasterFilterDB];
//    [filterListIB setTarget:self OnFilterSelect:@selector(onFilterSelect:)];
//    

}
-(void)autoplayContinue:(id)sender
{
    if(loopPlayer.player!=nil)
    {
        if(isPlayerPaused==false)
        {
            AVPlayerItem *currentItem = loopPlayer.player.currentItem;
            
            NSTimeInterval currentTime = CMTimeGetSeconds(currentItem.currentTime);
            
            NSTimeInterval duration = CMTimeGetSeconds(currentItem.duration);
            
            if(currentTime>=duration)
            {
                [loopPlayer.player seekToTime:kCMTimeZero];
                
            }
            
            [loopPlayer.player play];
        }
        else
        {
            [loopPlayer.player pause];
            
            
        }
    }
    
    [self performSelector:@selector(autoplayContinue:) withObject:nil afterDelay:0.2f];
    
}
-(void)killPlayer
{
    [loopPlayer.player pause];
    loopPlayer.player=nil;
    [loopPlayer.view removeFromSuperview];
    loopPlayer=nil;
    
    
    
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint location=[touch locationInView:self];
    
    
    if(touch.tapCount==2)
    {
        [AnalyticsMXManager PushAnalyticsEventAction:@"Video Filter"];

        if(location.x>self.frame.size.width/2)
        {
            cFilterNo++;
            if(cFilterNo>MasterFilterDB.count-1)
            {
                cFilterNo=0;
            }
            [self applyMasterFilter:location];
        }
        else
        {
            cFilterNo--;
            if(cFilterNo<0)
            {
                cFilterNo=(int)MasterFilterDB.count-1;
            }
            [self applyMasterFilter:location];
            
        }
    }
}

-(void)pauseBtnClicked:(id)sender
{
    isPlayerPaused=true;

}

-(void)resumeBtnClicked:(id)sender
{
    isPlayerPaused=false;
}



-(void)onFilterSelect:(NSDictionary *)dict
{
    
    
    
    CGRect rect=[[dict valueForKey:@"rect"] CGRectValue];
    
    CGPoint point=CGPointMake(rect.origin.x + ( rect.size.width / 2 ), rect.origin.y + ( rect.size.height / 2 +filterListIB.center.y));
    
    cFilterNo=[[dict valueForKey:@"filterNo"] intValue];
    [self applyMasterFilter:point];
    
    
}
-(NSDictionary *)getFilterDict
{
    if(cFilterNo!=0)
    {
        
        UIImage *snapshotImage = [self createSnapShotImagesFromUIview:imageOverLay];

        NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:snapshotImage,@"OVERLAY",currentCompo,@"COMPOSITION",nil];
        return dict;

        
    }
    else
    {
    NSDictionary *dict=[[NSDictionary alloc] init];
    return dict;
    }
}
-(UIImage *)createSnapShotImagesFromUIview:(UIView *)view
{
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width,view.frame.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img_screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img_screenShot;
}

-(void)applyMasterFilter:(CGPoint)point
{
    NSDictionary *dict=[MasterFilterDB objectAtIndex:cFilterNo];
    
    
    
    NSString *name=[dict valueForKey:@"MNAME"];
    
    NSArray *colors=[dict valueForKey:@"colors"];
    
    NSArray *points=[dict valueForKey:@"points"];
    
    
    
    
    if(colors.count!=0)
    {
        UIColor *colorA=[colors objectAtIndex:0];
        UIColor *colorB=[colors objectAtIndex:1];
        
        CGFloat red1 = 0.0, green1 = 0.0, blue1 = 0.0, alpha1 =0.0;
        [colorA getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
        
        CGFloat red2 = 0.0, green2 = 0.0, blue2 = 0.0, alpha2 =0.0;
        [colorB getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
        
        
        NSLog(@"\n\n %d\n[UIColor colorWithRed:%1.2f green:%1.2f blue:%1.2f alpha:%1.2f]\n[UIColor colorWithRed:%1.2f green:%1.2f blue:%1.2f alpha:%1.2f];\n\n",[[dict valueForKey:@"filter"] intValue],red1,green1,blue1,alpha1,red2,green2,blue2,alpha2);
    }
    
    [helper rippleWithView:self center:point colorFrom:[UIColor whiteColor] colorTo:[UIColor whiteColor]];
    
    [helper showFancyToastWithMessage:name];
    
 /*   NSString *imageName=[NSString stringWithFormat:@"%d",[[dict valueForKey:@"filter"] intValue]];
    [keyImageView setImage:[helper getUIImageFromName:imageName]];
    
    */
    
    int filterNO=[[[MasterFilterDB objectAtIndex:cFilterNo] valueForKey:@"filter"] intValue];
    NSArray *array=[[CorefilterDB objectAtIndex:filterNO] valueForKey:@"DATA"];
    
    currentCompo=[self createNewComposition:array];
    loopPlayer.player.currentItem.videoComposition=currentCompo;

    [gLayer removeFromSuperlayer];
    
    if(colors.count!=0)
    {
        gLayer=[helper flavescentGradientLayer:[colors objectAtIndex:0] andColor2:[colors objectAtIndex:1] andPoints:points];
        [imageOverLay.layer insertSublayer:gLayer atIndex:0];
    }
    

    
}
-(AVMutableVideoComposition *)createNewComposition:(NSArray *)array
{
    
    
    AVAsset *asset=[AVAsset assetWithURL:keyURL];
    
    
    if(array.count!=0 && ![[[array objectAtIndex:0] valueForKey:@"filter"] isEqualToString:@"NONE"])
    {
        AVMutableVideoComposition *composition = [AVMutableVideoComposition videoCompositionWithAsset: asset
                                                                         applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest *request){
                                                                             // Clamp to avoid blurring transparent pixels at the image edges
                                                                             CIImage *source = [request.sourceImage imageByClampingToExtent];
                                                                             
                                                                             
                                                                             
                                                                             for(int i=0;i<array.count;i++)
                                                                             {
                                                                                 NSDictionary *dict=[array objectAtIndex:i];
                                                                                 
                                                                                 
                                                                                 CIFilter *filter = [CIFilter filterWithName:[dict valueForKey:@"filter"]];
                                                                                 
                                                                                 [filter setValue:source forKey:kCIInputImageKey];
                                                                                 
                                                                                 NSArray *keys=[dict allKeys];
                                                                                 for(int k=0;k<keys.count;k++)
                                                                                 {
                                                                                     NSString *keyName=[keys objectAtIndex:k];
                                                                                     // id valueKey=[dict valueForKey:keyName];
                                                                                     
                                                                                     if(![keyName isEqualToString:@"filter"] && ![keyName isEqualToString:@"inputCenter"])
                                                                                     {
                                                                                         [filter setValue:[dict valueForKey:keyName] forKey:keyName];
                                                                                     }
                                                                                     
                                                                                     if([keyName isEqualToString:@"inputCenter"])
                                                                                     {
                                                                                         CIVector *vector=[CIVector vectorWithX:request.sourceImage.extent.size.width/2 Y:request.sourceImage.extent.size.height/2];
                                                                                         
                                                                                         [filter setValue:vector forKey:@"inputCenter"];
                                                                                         
                                                                                     }
                                                                                     
                                                                                     
                                                                                 }
                                                                                 
                                                                                 
                                                                                 source = [filter.outputImage imageByCroppingToRect:request.sourceImage.extent];
                                                                             }
                                                                             
                                                                             
                                                                             
                                                                             
                                                                             
                                                                             
                                                                             
                                                                             // Provide the filter output to the composition
                                                                             [request finishWithImage:source context:nil];
                                                                         }];
        
        return composition;
        
    }
    else
    {
        AVMutableVideoComposition *compo=[AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:asset];
        return compo;
        
    }
    
    
    
}



@end
