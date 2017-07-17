//
//  ImageCropView.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "ImageCropView.h"

@implementation ImageCropView

-(void)setUp:(float)ratio andRect:(CGRect)frame
{
    ratioMain=ratio;
    profilePicRect=frame;
    
    self.backgroundColor=[UIColor whiteColor];
    
    CGRect photoframe=CGRectMake(0, 0, self.frame.size.width, self.frame.size.width*ratio);
    
    if(ratio>1)
    {
        photoframe=CGRectMake(0, 0, self.frame.size.width*0.8, self.frame.size.width*ratio*0.8);

    }
    else if(ratio==1)
    {
        photoframe=CGRectMake(0, 0, self.frame.size.width, self.frame.size.width*ratio);
    }
    
    palleteView=[[UIView alloc] initWithFrame:photoframe];
    [self addSubview:palleteView];
    palleteView.center=self.center;
    
    
    ViewContainer=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:ViewContainer];
    
    
    imageView=[[UIImageView alloc] initWithFrame:self.bounds];
    if(ratio!=1)
    {
        imageView.frame=photoframe;
    }
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    [ViewContainer addSubview:imageView];
    imageView.center=palleteView.center;


    float blurViewAlpha=0.5;
    
    blurView1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, palleteView.frame.origin.y)];
    [self addSubview:blurView1];
    blurView1.backgroundColor=[UIColor colorWithWhite:0 alpha:blurViewAlpha];
    
    blurView2=[[UIView alloc] initWithFrame:CGRectMake(0, palleteView.frame.origin.y+palleteView.frame.size.height, self.frame.size.width, self.frame.size.height-(palleteView.frame.origin.y+palleteView.frame.size.height))];
    
    [self addSubview:blurView2];
    blurView2.backgroundColor=[UIColor colorWithWhite:0 alpha:blurViewAlpha];
    
    
    blurView3=[[UIView alloc] initWithFrame:CGRectMake(0, palleteView.frame.origin.y, palleteView.frame.origin.x, palleteView.frame.size.height)];
    [self addSubview:blurView3];
    blurView3.backgroundColor=[UIColor colorWithWhite:0 alpha:blurViewAlpha];
    
    blurView4=[[UIView alloc] initWithFrame:
               CGRectMake(
                          palleteView.frame.origin.x+palleteView.frame.size.width,
                          palleteView.frame.origin.y,
                          self.frame.size.width-(palleteView.frame.origin.x+palleteView.frame.size.width),palleteView.frame.size.height)];
    
    
    [self addSubview:blurView4];
    blurView4.backgroundColor=[UIColor colorWithWhite:0 alpha:blurViewAlpha];
    
    
    
    
    frameView=[[UIView alloc] initWithFrame:palleteView.frame];
    [self addSubview:frameView];
    frameView.layer.borderWidth=1;
    frameView.layer.borderColor=[UIColor whiteColor].CGColor;

    
    UIView *grid1=[[UIView alloc] initWithFrame:CGRectMake(palleteView.frame.size.width/3, 0, 1, palleteView.frame.size.height)];
    UIView *grid2=[[UIView alloc] initWithFrame:CGRectMake(2*palleteView.frame.size.width/3, 0, 1, palleteView.frame.size.height)];
    
    UIView *grid3=[[UIView alloc] initWithFrame:CGRectMake(0, palleteView.frame.size.height/3, palleteView.frame.size.width, 1)];
    UIView *grid4=[[UIView alloc] initWithFrame:CGRectMake(0, 2*palleteView.frame.size.height/3, palleteView.frame.size.width, 1)];
    
    
    [frameView addSubview:grid1];
    [frameView addSubview:grid2];
    [frameView addSubview:grid3];
    [frameView addSubview:grid4];
    
    grid1.backgroundColor=[UIColor whiteColor];
    grid2.backgroundColor=[UIColor whiteColor];
    grid3.backgroundColor=[UIColor whiteColor];
    grid4.backgroundColor=[UIColor whiteColor];
    
    
    
    
    
    
    title=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width, 50)];
    [self addSubview:title];
    title.text=@"Crop Photo";
    title.textAlignment=NSTextAlignmentCenter;
    title.font=[UIFont fontWithName:k_fontBold size:16];
    title.textColor=[UIColor whiteColor];
    
    btnFinished=[[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-80, 20, 70, 50)];
    [self addSubview:btnFinished];
    [btnFinished setTitle:@"Done" forState:UIControlStateNormal];
    [btnFinished setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnFinished.titleLabel.font=[UIFont fontWithName:k_fontBold size:15];

    [btnFinished addTarget:self action:@selector(cropFinished:) forControlEvents:UIControlEventTouchUpInside];
    

    btnCancel=[[UIButton alloc] initWithFrame:CGRectMake(10, 20, 70, 50)];
    [self addSubview:btnCancel];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCancel.titleLabel.font=[UIFont fontWithName:k_fontBold size:15];
    
    [btnCancel addTarget:self action:@selector(btnCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    lastScale=1.0f;

    
    UIPinchGestureRecognizer *gesture1=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)];
    
    [self addGestureRecognizer:gesture1];
    
    UIPanGestureRecognizer *gesture2=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFinger:)];
    [self addGestureRecognizer:gesture2];

    
}
-(void)panFinger:(UIPanGestureRecognizer *)gesture
{
    
    static CGPoint currentTranslation;
    static CGFloat currentScale = 0;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        currentTranslation = translation;
        currentScale = imageView.frame.size.width / imageView.bounds.size.width;
    }
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation1 = [gesture translationInView:imageView];
        
        translation.x = translation1.x + currentTranslation.x;
        translation.y = translation1.y + currentTranslation.y;
        CGAffineTransform transform1 = CGAffineTransformMakeTranslation(translation.x , translation.y);
        CGAffineTransform transform2 = CGAffineTransformMakeScale(currentScale, currentScale);
        CGAffineTransform transform = CGAffineTransformConcat(transform1, transform2);
        imageView.transform = transform;
    }

}
- (void)twoFingerPinch:(UIPinchGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded
        || gesture.state == UIGestureRecognizerStateChanged) {
       
        NSLog(@"gesture.scale = %f", gesture.scale);
        
        lastScale =lastScale*gesture.scale;
        
       // lastScale=gesture.scale;
        
        if (lastScale > 5.0) {
            lastScale = 5.0;
        }
        if (lastScale < 1.0) {
            lastScale = 1.0;
        }

        CGAffineTransform transform1 = CGAffineTransformMakeTranslation(translation.x, translation.y);
        CGAffineTransform transform2 = CGAffineTransformMakeScale(lastScale, lastScale);
        CGAffineTransform transform = CGAffineTransformConcat(transform1, transform2);

        
        imageView.transform = transform;
        gesture.scale=1;
    }

    
    
}


-(void)setTarget:(id)delegate andDoneBtn:(SEL)func1 andCancelBtn:(SEL)func2;
{
    target=delegate;
    doneBtnClicked=func1;
    cancelBtnClicked=func2;
}
-(void)setUpImage:(UIImage *)image
{
    imageView.image=image;
    
}
-(void)btnCancel:(id)sender
{

    [self removeFromSuperview];
    
    
}
-(void)cropFinished:(id)sender
{

    
    UIImage *img=[self crop:palleteView.frame withImage:[self pb_takeSnapshot]];

    UIImageView *imageViewT=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    [self addSubview:imageViewT];
    imageViewT.image=img;
    imageViewT.center=self.center;
    
    [target performSelector:doneBtnClicked withObject:img afterDelay:0.01];

    [self removeFromSuperview];
    
//    
//    [UIView animateWithDuration:1 animations:^{
//        
//        NSArray *views=[self subviews];
//        
//        for(int i=0;i<[views count];i++)
//        {
//            UIView *view=[views objectAtIndex:i];
//            if(view!=imageViewT)
//            {
//                view.alpha=0;
//                
//            }
//            self.backgroundColor=[UIColor clearColor];
//        }
//        
//       // imageViewT.layer.cornerRadius=imageViewT.frame.size.width/2;
//
//        
//    } completion:^(BOOL finished) {
//        
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            
//            imageViewT.frame=profilePicRect;
//            
//          
//            
//            
//        } completion:^(BOOL finished) {
//            
//            [UIView animateWithDuration:0.5 animations:^{
//                
//                
//                if(ratioMain==1)
//                {
//                    imageViewT.layer.cornerRadius=profilePicRect.size.width/2;
//                }
//                
//                
//                
//            } completion:^(BOOL finished) {
//                
//                [self removeFromSuperview];
//                
//            }];
//            
//        }];
//    }];
//    
//    
  
    


    
    
}
- (UIImage *)crop:(CGRect)rect withImage:(UIImage *)image {
    if (image.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * image.scale,
                          rect.origin.y * image.scale,
                          rect.size.width * image.scale,
                          rect.size.height * image.scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

- (UIImage *)pb_takeSnapshot {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [ViewContainer drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

}

@end
