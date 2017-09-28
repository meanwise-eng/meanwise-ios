//
//  PhotoAlbumCCell.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "PhotoAlbumCCell.h"

@implementation PhotoAlbumCCell

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    if(hours==0)
    {
    return [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
    }
    else
    {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
    }
}

-(void)setAsset:(PHAsset *)assetReceived;
{
    self.backgroundColor=[Constant colorGlobal:arc4random()%12];
    
    self.shadowImage.hidden=true;
    asset=assetReceived;
    
        PHImageManager *manager = [PHImageManager defaultManager];
        PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
        requestOptions.resizeMode   = PHImageRequestOptionsResizeModeFast;
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    
    
   if(asset.mediaType==PHAssetMediaTypeVideo)
   {
       self.duration.hidden=false;

       
       self.duration.text=[self timeFormatted:(int)asset.duration];

   }
    else
    {
        self.duration.hidden=true;
    }
    
        requestOptions.synchronous = false;
        requestOptions.networkAccessAllowed=YES;
    
        [manager requestImageForAsset:asset
                           targetSize:CGSizeMake(150, 150)
                          contentMode:PHImageContentModeAspectFill
                              options:requestOptions
                        resultHandler:^void(UIImage *image, NSDictionary *info) {
                            
                          //  NSLog(@"Image size:%@",NSStringFromCGSize(image.size));

                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                
                                self.shadowImage.hidden=false;
                                self.photoView.image=image;
                              //  self.photoView.frame=CGRectMake(0, 0, image.size.width, image.size.height);
                               // self.photoView.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
                               // self.photoView.contentMode=UIViewContentModeScaleAspectFit;
                                

//                                self.photoView.alpha=0;
//                                //self.photoView.transform=CGAffineTransformMakeScale(0, 0);
//                                [UIView animateWithDuration:0.3 animations:^{
//                                    self.photoView.alpha=1;
//                                  //  self.photoView.transform=CGAffineTransformMakeScale(1, 1);
//                                }];
                                
                                
                            });
                            
                        }];
        
        
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.clipsToBounds=YES;
        
        
        
        
        self.photoView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.photoView.frame=self.bounds;
        
        [self addSubview:self.photoView];
        self.photoView.contentMode=UIViewContentModeScaleAspectFill;
        self.photoView.clipsToBounds=YES;
        
        self.photoView.backgroundColor=[UIColor clearColor];
        
        
        
        self.shadowImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.shadowImage.frame=self.bounds;
        
        [self addSubview:self.shadowImage];
        self.shadowImage.contentMode=UIViewContentModeScaleAspectFill;
        self.shadowImage.clipsToBounds=YES;
        self.shadowImage.image=[UIImage imageNamed:@"BlackShadow.png"];
        self.shadowImage.alpha=0.3;
        self.shadowImage.transform=CGAffineTransformMakeScale(1, -1);
        
        
        self.duration=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        self.duration.textColor=[UIColor whiteColor];
        self.duration.textAlignment=NSTextAlignmentCenter;
        self.duration.text=@"v";
        self.duration.hidden=true;
        self.duration.adjustsFontSizeToFitWidth=YES;
        [self addSubview:self.duration];
        self.duration.font=[UIFont fontWithName:k_fontExtraBold size:10];

        self.duration.layer.cornerRadius=2;
        self.duration.clipsToBounds=YES;
        self.duration.backgroundColor=[UIColor colorWithWhite:1 alpha:0.3f];

        self.shadowImage.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

        self.photoView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return self;
}


@end
