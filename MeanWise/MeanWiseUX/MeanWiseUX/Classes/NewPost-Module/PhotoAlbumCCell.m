//
//  PhotoAlbumCCell.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "PhotoAlbumCCell.h"

@implementation PhotoAlbumCCell


-(void)setAsset:(PHAsset *)assetReceived;
{
    asset=assetReceived;
    
        PHImageManager *manager = [PHImageManager defaultManager];
        //  NSMutableArray *images = [NSMutableArray arrayWithCapacity:[assets count]];
        
        
        PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
        requestOptions.resizeMode   = PHImageRequestOptionsResizeModeFast;
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    
    
   if(asset.mediaType==PHAssetMediaTypeVideo)
   {
       self.duration.hidden=false;

       
       self.duration.text=[NSString stringWithFormat:@"%1.0fs",asset.duration];
   }
    else
    {
        self.duration.hidden=true;
    }
        // this one is key
        requestOptions.synchronous = false;
        
    
        [manager requestImageForAsset:asset
                           targetSize:CGSizeMake(200, 200)
                          contentMode:PHImageContentModeAspectFill
                              options:requestOptions
                        resultHandler:^void(UIImage *image, NSDictionary *info) {
                            
                            
                            
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                self.photoView.image=image;

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
        
        
        
        self.photoView=[[UIImageView alloc] initWithFrame:CGRectMake(1, 1, self.frame.size.width-2, self.frame.size.height-2)];
        
        [self addSubview:self.photoView];
        self.photoView.contentMode=UIViewContentModeScaleAspectFill;
        self.photoView.clipsToBounds=YES;
        
        self.duration=[[UILabel alloc] initWithFrame:CGRectMake(2, self.frame.size.height-20, self.frame.size.width-4, 20)];
        self.duration.textColor=[UIColor whiteColor];
        self.duration.textAlignment=NSTextAlignmentLeft;
        self.duration.text=@"v";
        self.duration.hidden=true;
        self.duration.adjustsFontSizeToFitWidth=YES;
        [self addSubview:self.duration];
        self.duration.font=[UIFont fontWithName:k_fontExtraBold size:10];

    }
    return self;
}


@end
