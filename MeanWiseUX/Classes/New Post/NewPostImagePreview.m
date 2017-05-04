//
//  NewPostImagePreview.m
//  MeanWiseUX
//
//  Created by Mohamed Aas on 4/16/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "NewPostImagePreview.h"
#import "FTIndicator.h"
#import "Constant.h"

@implementation NewPostImagePreview

-(void)setImage:(UIImage*)image andRect:(CGRect)rect
{

    
    
    initialRect=rect;

    
    fullRect=[UIScreen mainScreen].bounds;
    smallRect=rect;
    self.backgroundColor=[UIColor blackColor];
    
    fullPreviewRect=CGRectMake(0, 0,fullRect.size.width, fullRect.size.height);
    
    self.photo = image;
    
    
    [self setUpGeneral];
    
}

-(void)setUpGeneral
{
    self.hidden=false;
    
    mainView = [[UIView alloc]initWithFrame:fullRect];
    [self addSubview:mainView];
    
    filterSwitcherView = [[SCSwipeableFilterView alloc]initWithFrame:fullRect];
    [filterSwitcherView setImageByUIImage:self.photo];
    [filterSwitcherView setContentMode:UIViewContentModeScaleAspectFill];
    
    filterSwitcherView.contentMode = UIViewContentModeScaleAspectFill;
    [mainView addSubview:filterSwitcherView];
    
    filterSwitcherView.filters = @[
                                        [SCFilter emptyFilter],
                                        [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"bw" withExtension:@"cisf"]],
                                        [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"mono" withExtension:@"cisf"]],
                                        [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"false" withExtension:@"cisf"]],
                                        [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"tonal" withExtension:@"cisf"]],
                                        [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"sharp" withExtension:@"cisf"]],
                                        [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"sepia" withExtension:@"cisf"]],
                                        [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"comic" withExtension:@"cisf"]],
                                        [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"xray" withExtension:@"cisf"]],
                                        [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"thermal" withExtension:@"cisf"]]
                                        ];
    
    tapToFullBtn=[[UIButton alloc] initWithFrame:self.bounds];
    [self addSubview:tapToFullBtn];
    [tapToFullBtn addTarget:self action:@selector(openFullMode:) forControlEvents:UIControlEventTouchUpInside];
    
    fullModeBtnDone=[[UIButton alloc] initWithFrame:CGRectMake(20,20, 40, 40)];
    fullModeBtnDone.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [fullModeBtnDone setBackgroundImage:[UIImage imageNamed:@"photoCancelBtn.png"] forState:UIControlStateNormal];
    [fullModeBtnDone addTarget:self
                        action:@selector(cleanUp) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:fullModeBtnDone];
    
    closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(smallRect.size.width-10-35, 10, 35, 35)];
    [self addSubview:closeBtn];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"removePic.png"] forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(cleanUp) forControlEvents:UIControlEventTouchUpInside];
    
    downloadBtn=[[UIButton alloc] initWithFrame:CGRectMake(20, fullPreviewRect.size.height-50-40/2, 28, 48.5)];
    [self addSubview:downloadBtn];
    [downloadBtn setBackgroundImage:[UIImage imageNamed:@"saveImage.png"] forState:UIControlStateNormal];
    [downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [downloadBtn addTarget:self action:@selector(downloadImageToDevice:) forControlEvents:UIControlEventTouchUpInside];
    
    nextBtn=[[UIButton alloc] initWithFrame:CGRectMake(fullPreviewRect.size.width-65, fullPreviewRect.size.height-50-40/2, 45, 45)];
    [self addSubview:nextBtn];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"nextView.png"] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(closeFullMode:) forControlEvents:UIControlEventTouchUpInside];
    
    downloadBtn.alpha=0;
    nextBtn.alpha=0;
    
    editBtn1=[[UIButton alloc] initWithFrame:CGRectMake(fullPreviewRect.size.width-32.5-15, 35, 32.5, 18)];
   // [self addSubview:editBtn1];
    
    editBtn2=[[UIButton alloc] initWithFrame:CGRectMake(fullPreviewRect.size.width-32.5-15, 35+18+20, 32.5,32.5)];
    //[self addSubview:editBtn2];
    
   // editBtn3=[[UIButton alloc] initWithFrame:CGRectMake(fullPreviewRect.size.width-20.5-23, 35+18+20, 20.5,32.5)];
    editBtn3=[[UIButton alloc] initWithFrame:CGRectMake(fullPreviewRect.size.width-20.5-23, 35, 20.5,32.5)];
    [self addSubview:editBtn3];
    
    editBtn4=[[UIButton alloc] initWithFrame:CGRectMake(fullPreviewRect.size.width-32.5-15, 35+18+32.5+32.5+60, 32.5,18.5)];
    //[self addSubview:editBtn4];
    
    [editBtn1 setBackgroundImage:[UIImage imageNamed:@"addText.png"] forState:UIControlStateNormal];
    [editBtn2 setBackgroundImage:[UIImage imageNamed:@"crop.png"] forState:UIControlStateNormal];
    [editBtn3 setBackgroundImage:[UIImage imageNamed:@"addLocation.png"] forState:UIControlStateNormal];
    [editBtn4 setBackgroundImage:[UIImage imageNamed:@"addAnimatedText.png"] forState:UIControlStateNormal];
    
    editBtn1.alpha=0;
    editBtn2.alpha=0;
    editBtn3.alpha=0;
    editBtn4.alpha=0;
    
    
    [editBtn1 addTarget:self action:@selector(editBtnClicked1:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn3 addTarget:self action:@selector(editBtnClicked2:) forControlEvents:UIControlEventTouchUpInside];
   // [editBtn3 addTarget:self action:@selector(editBtnClicked3:) forControlEvents:UIControlEventTouchUpInside];
    
    self.clipsToBounds=YES;
}


-(void)editBtnClicked1:(id)sender
{
    
}

-(void)editBtnClicked2:(id)sender
{
    
    if(locationSticker==nil)
    {
        locationSticker=[[LocationFilterView alloc] initWithFrame:self.bounds];
        [filterSwitcherView addSubview:locationSticker];
        [locationSticker setTarget:self onLocationFail:@selector(locationFailed:)];
        [locationSticker setUp];
    }
    else
    {
        [self locationFailed:@""];
    }
}

-(void)locationFailed:(NSString *)message
{
    
    [locationSticker removeFromSuperview];
    locationSticker=nil;
    
    
    if(![message isEqualToString:@""])
    {
        [Constant okAlert:@"Location is disabled." withSubTitle:message onView:self andStatus:1];
        
    }
    
}

-(void)editBtnClicked3:(id)sender
{
    
}

-(void)downloadImageToDevice:(id)sender
{
    UIImage *image = [filterSwitcherView renderedUIImage];
    
    UIView *tempyCont = [[UIView alloc]initWithFrame:self.bounds];
    UIImageView * tempy = [[UIImageView alloc]initWithFrame:self.bounds];
    [tempy setImage:image];
    [tempy setContentMode:UIViewContentModeScaleAspectFill];
    
    [tempy addSubview:locationSticker];
    
    [tempyCont addSubview:tempy];
    
    image = [self imageFromView:tempyCont];
    
    [image saveToCameraRollWithCompletion:^(NSError * _Nullable error) {
        if (error==nil) {
            
            [FTIndicator showSuccessWithMessage:@"Saved to Gallery"];
            
            [filterSwitcherView addSubview:locationSticker];
            
        } else {
            
            [FTIndicator showErrorWithMessage:@"Failed to Save"];
        }
    }];
}


-(NSData*)getImageData
{
    UIImage *image = [filterSwitcherView renderedUIImage];
    
    UIView *tempyCont = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UIImageView * tempy = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [tempy setImage:image];
    [tempy setContentMode:UIViewContentModeScaleAspectFill];
    
    [tempy addSubview:locationSticker];
    
    [tempyCont addSubview:tempy];
    
    image = [self imageFromView:tempyCont];
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.49f;
    int maxFileSize = (int)(1024);
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    

    return imageData;
}

- (UIImage *) imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

-(NSString *)applicationDocumentsDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    
    return documentsPath;
}

-(NSString *)FM_saveImageAtDocumentDirectory:(UIImage *)image
{
    
    NSString *savedImagePath = [[self applicationDocumentsDirectoryPath] stringByAppendingPathComponent:@"savedImage.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    BOOL flag=[imageData writeToFile:savedImagePath atomically:YES];
    
    return savedImagePath;
    
}


-(void)closeFullMode:(id)sender
{
    
    
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        fullModeBtnDone.center=CGPointMake(10+25/2-200, 20+65/2-10);
        
        self.frame=smallRect;
        
        closeBtn.alpha=1;
        
        [mainView setFrame:CGRectMake(0, 0, smallRect.size.width, smallRect.size.height)];
        //[filterSwitcherView setNeedsLayout];
        
        editBtn1.alpha=0;
        editBtn2.alpha=0;
        editBtn3.alpha=0;
        editBtn4.alpha=0;
        
        downloadBtn.alpha=0;
        nextBtn.alpha=0;
        
        
    } completion:^(BOOL finished) {
        
        tapToFullBtn.hidden=false;
        closeBtn.hidden=false;
        [self.superview sendSubviewToBack:self];
        
        [target performSelector:showThumbScreenFunc withObject:nil afterDelay:0.001];

    }];
}
-(void)openFullMode:(id)sender
{
    float duration=0.2;
    
    if(sender==nil)
    {
        duration=0;
    }
    
    [self.superview bringSubviewToFront: self];
    smallRect=self.frame;
    
    tapToFullBtn.hidden=true;
    closeBtn.alpha=0;
    
    [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        fullModeBtnDone.center=CGPointMake(10+25/2, 20+65/2-10);
        
        closeBtn.alpha=0;
        
        [mainView setFrame:fullRect];
        //[filterSwitcherView setNeedsLayout];
        
        editBtn1.alpha=1;
        editBtn2.alpha=1;
        editBtn3.alpha=1;
        editBtn4.alpha=1;
        nextBtn.alpha=1;
        downloadBtn.alpha=1;
        
        self.frame=fullRect;
        
    } completion:^(BOOL finished) {

        closeBtn.hidden=true;
        [target performSelector:showFullScreenFunc withObject:nil afterDelay:0.001];
        
    }];
    
    
}

-(void)setTarget:(id)delegate showFullScreenCallBack:(SEL)func1 andShowThumbCallBack:(SEL)func2
{
    
    target=delegate;
    showFullScreenFunc=func1;
    showThumbScreenFunc=func2;
    
}

-(void)cleanUp
{
    self.hidden=true;
    filterSwitcherView = nil;
    
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(void)QuickOpen
{
    
}


@end
