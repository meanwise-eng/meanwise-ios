//
//  PhotoGallery.m
//  MeanWiseUX
//
//  Created by Hardik on 03/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "PhotoGallery.h"
#import <malloc/malloc.h>
#import "PhotoAlbumCCell.h"
#import "FTIndicator.h"
#import "MXToolTipView.h"
#import "UICollectionViewDelegateJSPintLayout.h"



@implementation PhotoGallery

#define kCollectionCellBorderTop 0
#define kCollectionCellBorderBottom 0
#define kCollectionCellBorderLeft 0
#define kCollectionCellBorderRight 0

-(void)setUpBasics
{
    overlayBlack=[[UIView alloc] initWithFrame:self.bounds];
    overlayBlack.backgroundColor=[UIColor clearColor];
    [self addSubview:overlayBlack];
    
    
    
    masterView=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:masterView];
    masterView.backgroundColor=[UIColor blackColor];
    
    masterScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [masterView addSubview:masterScrollView];
    [masterScrollView setContentSize:CGSizeMake(self.frame.size.width*2, 0)];
    masterScrollView.pagingEnabled=true;
    masterScrollView.showsHorizontalScrollIndicator=false;
    masterScrollView.showsVerticalScrollIndicator=false;
    masterScrollView.delegate=self;
    
    
    
    cancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(5,30, 40, 40)];
    [masterView addSubview:cancelBtn];

    
    switchBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-55,30, 40, 40)];
    [masterView addSubview:switchBtn];
    
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"photoCancelBtn.png"] forState:UIControlStateNormal];
    [switchBtn setBackgroundImage:[UIImage imageNamed:@"cameraSwitchBtn.png"] forState:UIControlStateNormal];

    
    switchBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:14];
    cancelBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:14];
    
    
    [switchBtn addTarget:self action:@selector(switchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    switchBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    cancelBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    
    
    titleLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    titleLBL.font=[UIFont fontWithName:k_fontSemiBold size:15];
    [masterView addSubview:titleLBL];
    titleLBL.center=CGPointMake(self.frame.size.width/2, 20+25);
    titleLBL.textColor=[UIColor whiteColor];
    titleLBL.textAlignment=NSTextAlignmentCenter;
    titleLBL.text=@"Photo Gallery";
    


    
}



-(void)setUp:(int)section
{
    self.backgroundColor=[UIColor clearColor];
    shortFrame=self.frame;

    [self setUpBasics];
    
    [self setUpGallerySection];
    
    
    
    [self setUpCameraSection];
    
    
    
    
    masterView.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        masterView.frame=self.bounds;
        overlayBlack.backgroundColor=[UIColor blackColor];
    }];

  
    
    masterScrollView.contentOffset=CGPointMake(self.frame.size.width*section, 0);
    if(section==0)
    { [self updateTitle:@"Photos"];}
    else
    {[self updateTitle:@"Capture"];}
    
    
    //masterScrollView.contentOffset=CGPointMake(self.frame.size.width, 0);
    [self scrollViewDidScroll:masterScrollView];

    
    
    
   // [self loadPhotos];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView==masterScrollView)
    {
        if(scrollView.contentOffset.x<50)
        {


            [cancelBtn setBackgroundImage:[UIImage imageNamed:@"photoCancelBtn.png"] forState:UIControlStateNormal];

            [switchBtn setBackgroundImage:[UIImage imageNamed:@"cameraSwitchBtn.png"] forState:UIControlStateNormal];

            [self updateTitle:@"Photos"];


        }
        else
        {
            
            [cancelBtn setBackgroundImage:[UIImage imageNamed:@"photoCancelBtn.png"] forState:UIControlStateNormal];


            [switchBtn setBackgroundImage:[UIImage imageNamed:@"photoSwitchBtn.png"] forState:UIControlStateNormal];

            [self updateTitle:@""];

        }
    }
    
}

#pragma mark - Camera Control Helpers
-(void)setUpCameraSection
{
    
    
    imageViewCameraBack=[[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    [masterScrollView addSubview:imageViewCameraBack];
    imageViewCameraBack.clipsToBounds=YES;
    imageViewCameraBack.contentMode=UIViewContentModeScaleAspectFill;
    imageViewCameraBack.hidden=false;
    imageViewCameraBack.backgroundColor=[UIColor blackColor];
    
    cameraPosition=LLCameraPositionRear;
    
    cameraCaptureView=[[LLSimpleCamera alloc] initWithQuality:@"AVCaptureSessionPresetHigh" position:cameraPosition videoEnabled:YES];
    cameraCaptureView.videoEnabled=true;
    cameraCaptureView.view.frame=imageViewCameraBack.frame;
    [masterScrollView addSubview:cameraCaptureView.view];
    [cameraCaptureView updateFlashMode:LLCameraFlashOff];
    [cameraCaptureView start];
    cameraCaptureView.fixOrientationAfterCapture=YES;
    
    float widthMargin=self.frame.size.width;
    
    cameraBtnMax=[[UICameraBtn alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [masterScrollView addSubview:cameraBtnMax];
    [cameraBtnMax setTarget:self andPhotoCapture:@selector(capturePhoto:)];
    [cameraBtnMax setTarget:self andVideoStart:@selector(videoStart:) andVideoClose:@selector(videoEnd:)];
    [cameraBtnMax setUp];
    cameraBtnMax.center=CGPointMake(widthMargin+imageViewCameraBack.bounds.size.width/2,imageViewCameraBack.bounds.size.height-60);

    
    handsFreeBtn=[[HandsFreeBtn alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [masterScrollView addSubview:handsFreeBtn];
    [handsFreeBtn setUpWithTime:25.0f];
    [handsFreeBtn setTarget:self OnVideoStopCallBack:@selector(handsfreeBtnClicked:)];
    handsFreeBtn.hidden=true;
    handsFreeBtn.center=CGPointMake(widthMargin+imageViewCameraBack.bounds.size.width/2,imageViewCameraBack.bounds.size.height-70);

    

    
    

    
    
   
    
    
    switchCamBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [switchCamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [switchCamBtn setBackgroundImage:[UIImage imageNamed:@"cameraFlip.png"] forState:UIControlStateNormal];
    [switchCamBtn setShowsTouchWhenHighlighted:YES];
    switchCamBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:13];
    switchCamBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    switchCamBtn.layer.cornerRadius=25;
    [switchCamBtn addTarget:self action:@selector(switchCamBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [masterScrollView addSubview:switchCamBtn];
    
    
    flashLightBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [flashLightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [flashLightBtn setBackgroundImage:[UIImage imageNamed:@"FlashOff.png"] forState:UIControlStateNormal];
    [flashLightBtn setShowsTouchWhenHighlighted:YES];
    flashLightBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:12];
    flashLightBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    flashLightBtn.layer.cornerRadius=25;
    [flashLightBtn addTarget:self action:@selector(flashLightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [masterScrollView addSubview:flashLightBtn];
    
    
    timerBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [timerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [timerBtn setBackgroundImage:[UIImage imageNamed:@"timerIcon.png"] forState:UIControlStateNormal];
    [timerBtn setShowsTouchWhenHighlighted:YES];
    timerBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:12];
    timerBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    timerBtn.layer.cornerRadius=25;
    [timerBtn addTarget:self action:@selector(timerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [masterScrollView addSubview:timerBtn];
    
    
    
    
    switchCamBtn.center=CGPointMake(widthMargin+imageViewCameraBack.bounds.size.width-100,imageViewCameraBack.bounds.size.height-60);
    
    flashLightBtn.center=CGPointMake(widthMargin+100,imageViewCameraBack.bounds.size.height-60);
    timerBtn.center=CGPointMake(widthMargin+35,imageViewCameraBack.bounds.size.height-60);

    timerControl=nil;
    timePicker=nil;
    
    
//    MXToolTipView *tipView=[[MXToolTipView alloc] initWithFrame:self.bounds];
//    [self addSubview:tipView];
//    tipView.backgroundColor=[UIColor clearColor];
//    [tipView setUp];
//    [tipView setPointDownAt:CGPointMake(self.bounds.size.width/2, self.frame.size.height-60-50)];

    
}

-(void)timerBtnClicked:(id)sender
{
    
    timePicker=[[HCDropDown alloc] initWithFrame:masterView.frame];
    [timePicker setUp:[[NSArray alloc] initWithObjects:@"5",@"10",@"15",@"25", nil] target:self callBack:@selector(timerTimeSelected:)];
    [masterView addSubview:timePicker];
    [timePicker setPopUpPoint:CGPointMake(35, masterView.bounds.size.height-60-25)];

}
-(void)timerTimeSelected:(NSNumber *)number
{
    NSLog(@"selected = %d",[number intValue]);
    
    if([number intValue]!=-1)
    {
        NSLog(@"selected = %d",[number intValue]);

        int index=[number intValue];
        
        int time=5;
        if(index==1) time=10;
        if(index==2) time=15;
        if(index==3) time=25;

        
        masterScrollView.scrollEnabled=false;
        timerBtn.hidden=true;
        cameraBtnMax.hidden=true;
        cancelBtn.hidden=true;
        switchBtn.hidden=true;
        
        handsFreeBtn.hidden=false;
        [handsFreeBtn continueAnimation];
        
        timerControl=[[TimerCountDownControl alloc] initWithFrame:masterView.bounds];
        [timerControl setUpWithTime:time];
        [timerControl setTarget:self callBack:@selector(timerFinished:)];
        [masterView addSubview:timerControl];
        timerControl.userInteractionEnabled=false;

    }
    else
    {
        
    }
    [timePicker removeFromSuperview];
    timePicker=nil;

    
        
}
-(void)timerFinished:(id)sender
{
    [timerControl removeFromSuperview];
    timerControl=nil;
    NSLog(@"Start");

    [self handsfreeBtnClicked:nil];
    
}
-(void)capturePhoto:(id)sender
{
    [cameraCaptureView capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if(!error) {
            [camera stop];
            
            
            image=[self fixOrientationOfImage:image];
            
           // NSData *data=UIImagePNGRepresentation(image);
         //   [FTIndicator showToastMessage:[NSString stringWithFormat:@"Image %d kb",(int)data.length/1024]];

            
            isSourceCamera=true;
            NSString *path=[Constant FM_saveImageAtDocumentDirectory:image];
            [self sendImage:path];
            
            
        }
    }];
    NSLog(@"YO:photo capture");
}
-(void)handsfreeBtnClicked:(id)sender
{
    
    if(switchCamBtn.hidden==false)
    {
        cameraBtnMax.hidden=true;
        switchCamBtn.hidden=true;
        flashLightBtn.hidden=true;
        
        masterScrollView.scrollEnabled=false;
        timerBtn.hidden=true;
        cameraBtnMax.hidden=true;
        cancelBtn.hidden=true;
        switchBtn.hidden=true;
        
        [self startRecordingVideo];
        [handsFreeBtn startAnimation];


    }
    else
    {
        
        cameraBtnMax.hidden=false;
        switchCamBtn.hidden=false;
        flashLightBtn.hidden=false;
          timerBtn.hidden=false;
        masterScrollView.scrollEnabled=true;
        
        cancelBtn.hidden=false;
        switchBtn.hidden=false;

        [cameraCaptureView stopRecording];
        
    }
    

}

-(void)videoStart:(id)sender
{
    switchCamBtn.hidden=true;
    flashLightBtn.hidden=true;
    masterScrollView.scrollEnabled=false;
    handsFreeBtn.hidden=true;
    timerBtn.hidden=true;
    
    cancelBtn.hidden=true;
    switchBtn.hidden=true;

    [self startRecordingVideo];

    NSLog(@"YO:video start capture");
    
}
-(void)videoEnd:(id)sender
{
    switchCamBtn.hidden=false;
    flashLightBtn.hidden=false;
        masterScrollView.scrollEnabled=true;
    [cameraCaptureView stopRecording];
    handsFreeBtn.hidden=true;
timerBtn.hidden=false;
    cancelBtn.hidden=false;
    switchBtn.hidden=false;
    NSLog(@"YO:video end capture");
    
}

-(void)startRecordingVideo
{
   

    AudioServicesPlaySystemSoundWithCompletion(1117, ^{
        AudioServicesDisposeSystemSoundID(1117);
        
        
        
        
        NSURL *outputURL = [[[Constant applicationDocumentsDirectory]
                             URLByAppendingPathComponent:@"test3"] URLByAppendingPathExtension:@"mov"];
        
        
        [cameraCaptureView startRecordingWithOutputUrl:outputURL didRecord:^(LLSimpleCamera *camera, NSURL *outputFileUrl, NSError *error) {
            
            [camera stop];
            
            
            if(error==nil)
            {
                isSourceCamera=true;
                [self fixTheOrientationOfVideo:outputURL];
                
                
            }
            else
            {
                if (([error code] == AVErrorMaximumDurationReached)) {
                    
                    isSourceCamera=true;
                    
                    [self fixTheOrientationOfVideo:outputURL];
                    
                    
                    
                }
                else
                {
                    
                    [Constant okAlert:@"Error" withSubTitle:error.localizedDescription onView:self andStatus:1];
                }
                
                
                
            }
            
            
        }];
        

    });

    
}

-(void)videoRecordedSuccessfully:(NSURL *)outputURL
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AudioServicesPlaySystemSound(1118);

        NSString *path=[Constant FM_saveVideoAtDocumentDirectory:outputURL];
        [self sendImage:path];
        
    });


}




-(void)switchCamBtnClicked:(id)sender
{
    

    [cameraCaptureView stop];
    [cameraCaptureView.view removeFromSuperview];
    cameraCaptureView=nil;
    

    if(cameraPosition==LLCameraPositionRear)
    {
    cameraPosition=LLCameraPositionFront;
    }
    else
    {
        cameraPosition=LLCameraPositionRear;
    }
    
    cameraCaptureView=[[LLSimpleCamera alloc] initWithQuality:@"AVCaptureSessionPresetHigh" position:cameraPosition videoEnabled:YES];
    cameraCaptureView.videoEnabled=true;
    cameraCaptureView.view.frame=imageViewCameraBack.frame;
    [masterScrollView addSubview:cameraCaptureView.view];
    [cameraCaptureView updateFlashMode:LLCameraFlashOff];
    [cameraCaptureView start];

    [masterScrollView sendSubviewToBack:cameraCaptureView.view];
    [masterScrollView sendSubviewToBack:imageViewCameraBack];

   // [cameraCaptureView togglePosition];
    
}

-(void)flashLightBtnClicked:(id)sender
{
    if(cameraCaptureView.flash==LLCameraFlashOff)
    {
        
        [cameraCaptureView updateFlashMode:LLCameraFlashOn];
        [flashLightBtn setBackgroundImage:[UIImage imageNamed:@"FlashOn.png"] forState:UIControlStateNormal];


    }
    else
    {
        
        [cameraCaptureView updateFlashMode:LLCameraFlashOff];
        [flashLightBtn setBackgroundImage:[UIImage imageNamed:@"FlashOff.png"] forState:UIControlStateNormal];

    }
    
    
}

#pragma mark - Flow
-(void)cancelBtnClicked:(id)sender
{
    
    [delegate performSelector:cancelFunc withObject:nil afterDelay:0.01];
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        // control.frame=CGRectMake(0, 160+85+200, self.frame.size.width, 50);
        masterView.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        overlayBlack.backgroundColor=[UIColor clearColor];
        control.alpha=0;
        
        
    } completion:^(BOOL finished) {
        
        
        [self removeFromSuperview];
        
    }];
    
}
-(void)switchBtnClicked:(id)sender
{
    int offset=0;
    if(masterScrollView.contentOffset.x<50)
    {
        offset=masterScrollView.frame.size.width;
    }
    
    
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        
        masterScrollView.contentOffset=CGPointMake(offset, 0);
        
        
    } completion:^(BOOL finished) {
        
       // [self removeFromSuperview];
        
    }];

    
    /*[delegate performSelector:mediaSelectedFunc withObject:nil afterDelay:0.01];
    
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        // control.frame=CGRectMake(0, 160+85+200, self.frame.size.width, 50);
        masterView.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        overlayBlack.backgroundColor=[UIColor clearColor];
        control.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];*/
}

-(void)photoBtnClicked:(id)sender
{
    
    
    [UIView animateWithDuration:0.5 animations:^{
        masterScrollView.contentOffset=CGPointMake(0, 0);
        
        
    } completion:^(BOOL finished) {
        [self updateTitle:@"Photos"];
    }];
    
    /*if(mediaTypeGlobal!=PHAssetMediaTypeImage)
     {
     mediaTypeGlobal=PHAssetMediaTypeImage;
     
     arrayData=[self getListOfPhotos:mediaTypeGlobal];
     [photoGallery reloadData];
     }*/
    
}
-(void)videoBtnClicked:(id)sender
{
    
    
    [UIView animateWithDuration:0.5 animations:^{
        masterScrollView.contentOffset=CGPointMake(self.frame.size.width, 0);
        
        
    } completion:^(BOOL finished) {
        [self updateTitle:@"Capture"];
    }];
    
    
    //
    /*if(mediaTypeGlobal!=PHAssetMediaTypeVideo)
     {
     mediaTypeGlobal=PHAssetMediaTypeVideo;
     
     arrayData=[self getListOfPhotos:mediaTypeGlobal];
     [photoGallery reloadData];
     }*/
    
}

-(void)setTarget:(id)target andSel1:(SEL)func1 andSel2:(SEL)func2
{
    delegate=target;
    cancelFunc=func1;
    mediaSelectedFunc=func2;
    
}

-(void)sendImage:(NSString *)imagePath
{
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:imagePath,@"path",[NSNumber numberWithBool:isSourceCamera],@"isSourceCamera",nil];
    
    
    [delegate performSelector:mediaSelectedFunc withObject:dict afterDelay:0.01];
    
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        //control.frame=CGRectMake(0, 160+85+200, self.frame.size.width, 50);
        masterView.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        overlayBlack.backgroundColor=[UIColor clearColor];
        control.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}



#pragma mark - CollectionView Detail

-(void)setUpGallerySection
{
    
    currentSegmentIndex=0;
    
    segmentControl=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"All",@"Favorites", nil]];
    [masterScrollView addSubview:segmentControl];
    segmentControl.frame=CGRectMake(5, 80, self.frame.size.width-10, 30);
    segmentControl.tintColor=[UIColor whiteColor];
    segmentControl.selectedSegmentIndex=0;
    [segmentControl addTarget:self action:@selector(mediaAlbumChange:) forControlEvents:UIControlEventValueChanged];



    [self setUpGalleryUI];
  

    [self getAllPhotosDetailsAsync];
    
}
-(void)setUpGalleryUI
{
    
    CGRect collectionViewFrame = CGRectMake(0,75+40, self.frame.size.width, self.frame.size.height-75-40);
    numColumns=3;
    GalleryCollectionViewLayout *customLayout=[[GalleryCollectionViewLayout alloc] init];
    customLayout.interitemSpacing=1;
    customLayout.lineSpacing=1;
    columunWidth=(collectionViewFrame.size.width-(customLayout.lineSpacing*(numColumns-1)))/numColumns;
    photoGallery = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:customLayout];
    
    [photoGallery registerClass:[PhotoAlbumCCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [masterScrollView addSubview:photoGallery];
    photoGallery.backgroundColor=[UIColor clearColor];
    
}
-(void)mediaAlbumChange:(UISegmentedControl *)sender
{

  
    photoGallery.delegate=nil;
    photoGallery.dataSource=nil;
    [photoGallery removeFromSuperview];
    photoGallery=nil;
    
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Add code here to do background processing
        //
        //
        
        dispatch_async( dispatch_get_main_queue(), ^{
            
            if(sender.selectedSegmentIndex==0)
            {
                currentSegmentIndex=0;
                arrayData=[NSArray arrayWithArray:allImagesList];
                
            }
            else
            {
                currentSegmentIndex=1;
                arrayData=[NSArray arrayWithArray:favoritesImages];
            }
            
            [self setUpGalleryUI];
            photoGallery.dataSource=self;
            photoGallery.delegate=self;

//            [photoGallery reloadData];
            
        });
    });
    

  

}
-(void)getAllPhotosDetailsAsync
{
    NSUserDefaults *nud=[NSUserDefaults standardUserDefaults];
    float y=[[nud valueForKey:@"GALLERY_SCROLLY"] floatValue];
    currentSegmentIndex=[[nud valueForKey:@"CURRENT_SEGMENT"] intValue];
    segmentControl.selectedSegmentIndex=currentSegmentIndex;

    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Add code here to do background processing
        //
        //

        dispatch_async( dispatch_get_main_queue(), ^{
            
        [self getListOfPhotos:PHAssetMediaTypeImage];
            
            if(currentSegmentIndex==0)
            {
            arrayData=allImagesList;
            }
            else
            {
                arrayData=favoritesImages;
            }
            photoGallery.delegate = self;
            photoGallery.dataSource = self;

            [photoGallery reloadData];
            
            photoGallery.contentOffset=CGPointMake(0, y);
            

        });
    });

    
}
//-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    
//    cell.alpha=0;
//    
//    [UIView animateWithDuration:0.2
//                     animations:^{
//                         
//                         cell.alpha=1;
//                         
//                     }
//                     completion:^(BOOL finished) {
//                         
//                     }];
//    
//}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUserDefaults *nud=[NSUserDefaults standardUserDefaults];
    [nud setValue:[NSNumber numberWithFloat:photoGallery.contentOffset.y] forKey:@"GALLERY_SCROLLY"];
    [nud setValue:[NSNumber numberWithInt:currentSegmentIndex] forKey:@"CURRENT_SEGMENT"];

    [nud synchronize];

    PHAsset *asset=[arrayData objectAtIndex:indexPath.row];
    
    PHImageManager *manager = [PHImageManager defaultManager];
    //  NSMutableArray *images = [NSMutableArray arrayWithCapacity:[assets count]];
    

    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    // this one is key
    requestOptions.synchronous = false;
    requestOptions.networkAccessAllowed=YES;
    

    if(asset.mediaType==PHAssetMediaTypeVideo)
    {
        [FTIndicator showProgressWithmessage:@"Preparing.." userInteractionEnable:false];
    [manager requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset *avAsset, AVAudioMix *audioMix, NSDictionary *info) {
        
        
        if(([avAsset isKindOfClass:[AVComposition class]] && ((AVComposition *)avAsset).tracks.count == 2)){
            
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = paths.firstObject;
            NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeSlowMoVideo-%d.mov",arc4random() % 1000]];
            NSURL *url = [NSURL fileURLWithPath:myPathDocs];
            
            //Begin slow mo video export
            AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
            exporter.outputURL = url;
            exporter.outputFileType = AVFileTypeQuickTimeMovie;
            exporter.shouldOptimizeForNetworkUse = YES;
            
            [exporter exportAsynchronouslyWithCompletionHandler:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (exporter.status == AVAssetExportSessionStatusCompleted) {
                        
                        NSURL *URL = exporter.outputURL;
                        
                        [FTIndicator dismissProgress];

                        [self fixTheOrientationOfVideo:URL];

                        
                        // NSData *videoData = [NSData dataWithContentsOfURL:URL];
                        //
                        //// Upload
                        //[self uploadSelectedVideo:video data:videoData];
                    }
                });
            }];

        }
        else
        {
        NSURL *url = (NSURL *)[[(AVURLAsset *)avAsset URL] fileReferenceURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        NSString *path=[Constant FM_saveVideoAtDocumentDirectory:url];
            
            isSourceCamera=false;
            [FTIndicator dismissProgress];

            [self fixTheOrientationOfVideo:[NSURL fileURLWithPath:path]];
        });
        }
        

        
    }];
    }
    else if (asset.mediaType==PHAssetMediaTypeImage)
    {
    
        CGSize exportSize;

        float width=asset.pixelWidth;
        float height=asset.pixelHeight;
        
        if(width>height)
        {
         
            exportSize=CGSizeMake(1200, 1200*height/width);
            
        }
        else
        {
            exportSize=CGSizeMake(800*width/height, 800);

        }
        
        
    [manager requestImageForAsset:asset
                       targetSize:exportSize
                      contentMode:PHImageContentModeAspectFill
                          options:requestOptions
                    resultHandler:^void(UIImage *image, NSDictionary *info) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            isSourceCamera=false;

                          //  NSData *data=UIImagePNGRepresentation(image);
                           // [FTIndicator showToastMessage:[NSString stringWithFormat:@"Image %d kb",(int)data.length/1024]];
                            

                            
                            NSString *path=[Constant FM_saveImageAtDocumentDirectory:image];
                            if(![path isEqualToString:@""])
                            {
                            [self sendImage:path];
                            }
                            else
                            {
                                [FTIndicator showToastMessage:@"Oops Error!"];
                            }
                            
                        });
                        
                    }];
    }

    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoAlbumCCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];

    cell.photoView.image=nil;
    [cell setAsset:[arrayData objectAtIndex:indexPath.row]];
    cell.layer.borderWidth=1;
    cell.layer.borderColor=[UIColor colorWithWhite:0 alpha:1.0f].CGColor;
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    int numberOfPhotos=(int)arrayData.count;
    /*if(numberOfPhotos>50)
    {
        numberOfPhotos=50;
    }*/
    return numberOfPhotos;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    PHAsset *asset=[arrayData objectAtIndex:indexPath.row];

    //h-w
    //x-?
   // float w=asset.pixelWidth/asset.pixelHeight;
    
 //   return CGSizeMake(100, 100*asset.pixelHeight/asset.pixelWidth);
  //  return CGSizeMake(100*asset.pixelWidth/asset.pixelHeight, 100);

    if(arrayData.count==0)
    {
     return CGSizeMake((self.frame.size.width-5)/4, (self.frame.size.width-5)/4);
    }
    else
    {
        return CGSizeZero;
    }
  
    
    
   // return CGSizeMake(0, 0);

}
- (CGFloat)columnWidthForCollectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
{
    return columunWidth;
}
- (NSUInteger)maximumNumberOfColumnsForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
{
    
    return numColumns;
}
- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath*)indexPath
{
    
        PHAsset *asset=[arrayData objectAtIndex:indexPath.row];

    
    
    CGSize rctSizeOriginal=CGSizeMake(asset.pixelWidth/5,asset.pixelHeight/5);
    
    
    double scale = (columunWidth  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / rctSizeOriginal.width;
    
    CGSize rctSizeFinal = CGSizeMake(rctSizeOriginal.width * scale,rctSizeOriginal.height * scale);
    
    //  imageView.frame = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop,rctSizeFinal.width,rctSizeFinal.height);
    
    CGFloat height = rctSizeFinal.height + 0;
    
    
    
    
    return height;
}
- (BOOL)collectionView:(UICollectionView*)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return YES;
}




-(void)getListOfPhotos:(PHAssetMediaType)mediaType
{
    PHFetchOptions *allPhotosOptions = [PHFetchOptions new];
    
    
    NSSortDescriptor *sortDesc1 = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO];
    
    NSSortDescriptor *sortDesc2 = [NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO];
    
    allPhotosOptions.sortDescriptors = @[sortDesc1, sortDesc2];
    
    //    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    // allPhotosOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",mediaType];
   
    allPhotosOptions.predicate = [NSPredicate predicateWithFormat:@"!((mediaSubtype & %d) == %d) AND !((mediaSubtype & %d) == %d)", PHAssetMediaSubtypeVideoHighFrameRate,PHAssetMediaSubtypeVideoHighFrameRate,PHAssetMediaSubtypeVideoTimelapse,PHAssetMediaSubtypeVideoTimelapse];

   // allPhotosOptions.predicate = [NSPredicate predicateWithFormat:@"!((mediaSubtype & %d) == %d) AND !((mediaSubtype & %d) == %d)", PHAssetMediaSubtypeVideoTimelapse,PHAssetMediaSubtypeVideoTimelapse,PHAssetMediaSubtypeVideoTimelapse,PHAssetMediaSubtypeVideoTimelapse];

    
    //  PHFetchResult *allPhotosResult = [PHAsset fetchAssetsWithMediaType:mediaType options:allPhotosOptions];
    PHFetchResult *allPhotosResult = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
    NSMutableArray *assets=[[NSMutableArray alloc] init];
    NSMutableArray *assetFavorites=[[NSMutableArray alloc] init];
    
    [allPhotosResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        
        

       if(asset.sourceType!=PHAssetSourceTypeCloudShared) //TRY
       {
           if(asset.isFavorite)
           {
               [assetFavorites addObject:asset];
           }
           
           [assets addObject:asset];
           NSLog(@"asset %@", asset);
           
       }
        
        
        
    }];
    
    
    
    favoritesImages=assetFavorites;
    allImagesList=assets;
    
    
    
    
}

#pragma mark - Helper

-(UIInterfaceOrientation)getTheOrientation:(AVAssetTrack *)videoTrack
{
    CGSize size = [videoTrack naturalSize];
    CGAffineTransform txf = [videoTrack preferredTransform];
    
    if (size.width == txf.tx && size.height == txf.ty)
        return UIInterfaceOrientationLandscapeRight;
    else if (txf.tx == 0 && txf.ty == 0)
        return UIInterfaceOrientationLandscapeLeft;
    else if (txf.tx == 0 && txf.ty == size.width)
        return UIInterfaceOrientationPortraitUpsideDown;
    else
        return UIInterfaceOrientationPortrait;
    
    
}
-(void)fixTheOrientationOfVideo:(NSURL *)outputFileUrl
{
    
   // NSData *data=[NSData dataWithContentsOfFile:outputFileUrl.path];
    
  //  [FTIndicator showToastMessage:[NSString stringWithFormat:@"Image %d kb",(int)data.length/1024]];

    
    if(outputFileUrl!=nil)
    {
    [self videoRecordedSuccessfully:outputFileUrl];

    return;
    }
    
    NSURL *newVideoURL;
    NSError *error = nil;
    AVURLAsset *videoAssetURL = [[AVURLAsset alloc] initWithURL:outputFileUrl options:nil];
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    
    
    
    AVAssetTrack *videoTrack = [[videoAssetURL tracksWithMediaType:AVMediaTypeVideo] firstObject];
    AVAssetTrack *audioTrack = [[videoAssetURL tracksWithMediaType:AVMediaTypeAudio] firstObject];
    
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetURL.duration) ofTrack:videoTrack atTime:kCMTimeZero error:&error];
    [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetURL.duration) ofTrack:audioTrack atTime:kCMTimeZero error:&error];
    
//    CGAffineTransform transformToApply = videoTrack.preferredTransform;
    //  [layerInstruction setTransform:transformToApply atTime:kCMTimeZero];

    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
    
    [layerInstruction setOpacity:0.0 atTime:videoAssetURL.duration];

    //max fix orientation
    
    CGSize mainSize=videoTrack.naturalSize;
    if(mainSize.width>mainSize.height)
    {
        mainSize=CGSizeMake(mainSize.height, mainSize.width);
    }
//
    UIImageOrientation FirstAssetOrientation_  = UIImageOrientationUp;
    
    BOOL  isFirstAssetPortrait_  = NO;
    
    CGAffineTransform firstTransform = videoTrack.preferredTransform;
    
    if(firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0)
    {
        FirstAssetOrientation_= UIImageOrientationRight; isFirstAssetPortrait_ = YES;
    }
    if(firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0)
    {
        FirstAssetOrientation_ =  UIImageOrientationLeft; isFirstAssetPortrait_ = YES;
    }
    if(firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0)
    {
        FirstAssetOrientation_ =  UIImageOrientationUp;
    }
    if(firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0)
    {
        FirstAssetOrientation_ = UIImageOrientationDown;
    }
    
    
    CGFloat FirstAssetScaleToFitRatio = mainSize.width/videoTrack.naturalSize.width;
    
    if(isFirstAssetPortrait_)
    {
        FirstAssetScaleToFitRatio = mainSize.width/videoTrack.naturalSize.height;
        
        CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
        
        [layerInstruction setTransform:CGAffineTransformConcat(videoTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
    }
    else
    {
        CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
        
        [layerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(videoTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, mainSize.width/2)) atTime:kCMTimeZero];
    }
    
    //max
    
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake( kCMTimeZero, videoAssetURL.duration);
    instruction.layerInstructions = @[layerInstruction];
    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.instructions = @[instruction];
    videoComposition.frameDuration = CMTimeMake(1, 30); //select the frames per second
    videoComposition.renderScale = 1.0;
    
    
    
    videoComposition.renderSize = mainSize; //select you video size
    
   // [Constant okAlert:@"alert" withSubTitle:[NSString stringWithFormat:@"%@",NSStringFromCGSize(videoTrack.naturalSize)] onView:self andStatus:1];
    

    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetPassthrough];
    
    
    NSURL *outputURL1 = [[[Constant applicationDocumentsDirectory]
                          URLByAppendingPathComponent:@"test4"] URLByAppendingPathExtension:@"mov"];
    
    
    [[NSFileManager defaultManager] removeItemAtURL:outputURL1 error:nil];
    
    
    exportSession.outputURL =outputURL1;
    
    newVideoURL=exportSession.outputURL;
    
    exportSession.outputFileType = AVFileTypeMPEG4; //very important select you video format (AVFileTypeQuickTimeMovie, AVFileTypeMPEG4, etc...)
    exportSession.videoComposition = videoComposition;
    exportSession.shouldOptimizeForNetworkUse = NO;
    exportSession.timeRange = CMTimeRangeMake(kCMTimeZero, videoAssetURL.duration);
    
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.blurBackground = YES;
    
    [alert showAlertInView:self
                 withTitle:@"Processing.."
              withSubtitle:nil
           withCustomImage:nil
       withDoneButtonTitle:nil
                andButtons:nil];
    [alert makeAlertTypeProgress];
    
    alert.hideAllButtons = YES;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert dismissAlertView];
            
            
            switch ([exportSession status])
            {
                    
                    
                case AVAssetExportSessionStatusCompleted: {
                    
                    
                    

                    NSLog(@"Triming Completed");
                    [self videoRecordedSuccessfully:newVideoURL];
                    
                    //generate video thumbnail
                    
                    break;
                }
                default: {
                    break;
                }
            }
        });
        
    }];
}
- (UIImage *)fixOrientationOfImage:(UIImage *)image {
    
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

-(void)updateTitle:(NSString *)title
{
    titleLBL.text=title;
}
-(void)PhotosPermission
{
    
    /*
     PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
     
     if (status == PHAuthorizationStatusAuthorized) {
     
     arrayData=[self getListOfPhotos:PHAssetMediaTypeImage];
     [photoGallery reloadData];
     
     // Access has been granted.
     }
     
     else if (status == PHAuthorizationStatusDenied) {
     
     // Access has been denied.
     }
     
     
     else if (status == PHAuthorizationStatusNotDetermined) {
     
     }
     
     else if (status == PHAuthorizationStatusRestricted) {
     // Restricted access - normally won't happen.
     }
     
     
     // Access has not been determined.
     [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
     
     if (status == PHAuthorizationStatusAuthorized) {
     
     
     
     // Access has been granted.
     }
     
     else {
     
     // Access has been denied.
     }
     }];*/
    
}


-(void)getThumb:(NSString *)path
{
    UIImage *image=[self generateThumbImage:path];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
}
-(UIImage *)generateThumbImage : (NSString *)filepath
{
    NSURL *url = [NSURL fileURLWithPath:filepath];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = [asset duration];
    time.value = 0;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}

@end

#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -  PhotosBtnController

@implementation PhotosBtnController
-(void)setUp
{
    photoBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    [self addSubview:photoBtn];
    
    [photoBtn addTarget:self action:@selector(photoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIImageView *imgView1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    [photoBtn addSubview:imgView1];
    
    imgView1.center=CGPointMake(self.frame.size.width/2,25);
    
    
    imgView1.contentMode=UIViewContentModeScaleAspectFit;
    
    imgView1.image=[UIImage imageNamed:@"TakePicIcon.png"];
    
    
}
-(void)setTarget:(id)target andSel1:(SEL)func1 andSel2:(SEL)func2
{
    delegate=target;
    photoSelection=func1;
    
    
}
-(void)photoBtnClicked:(id)sender
{
    [delegate performSelector:photoSelection withObject:nil afterDelay:0.01];
}


@end






