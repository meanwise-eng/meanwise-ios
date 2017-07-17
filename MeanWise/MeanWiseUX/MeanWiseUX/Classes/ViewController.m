//
//  ViewController.m
//  MeanWiseUX
//
//  Created by Hardik on 15/08/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "ViewController.h"
#import "HomeScreen.h"
#import "APITesterView.h"
#import "ConnectionBar.h"
#import "UserSession.h"
#import "SignUpWizardAppearanceComponent.h"
#import "APIObjectsParser.h"
#import "EditInterestsComponent.h"
#import "SearchComponent.h"
#import "NewPostComponent.h"
#import "MXToolTipView.h"
#import "ShareComponent.h"
#import "SDAVAssetExportSession.h"

#import "EditSCComponent.h"
#import "EditPCComponent.h"
#import "SignUpWizardSkillsComponent.h"

#import "GUIScaleManager.h"




@interface ViewController ()

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    /*self.view.backgroundColor=[UIColor grayColor];
    NotificationBadgeView *notificationBar;
    notificationBar=[[NotificationBadgeView alloc] init];
    [notificationBar setDelegate:self andFunc1:@selector(showStatusBar) andFunc2:@selector(hideStatusBar)];
    [notificationBar setUp:[NSNumber numberWithInt:5]];
 */
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    statusBarHide=false;

    mainKeyView=[[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mainKeyView];
    mainKeyView.clipsToBounds=YES;
    mainKeyView.backgroundColor=[UIColor whiteColor];



    [GUIScaleManager setTransform:mainKeyView];
    mainKeyView.frame=CGRectMake(0, 0, mainKeyView.frame.size.width, mainKeyView.frame.size.height);
    
    if(RX_isiPhone4Res)
    {
        mainKeyView.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    }
    
    self.view.backgroundColor=[UIColor blackColor];
    
 
    
    //Final
    
  
    
    [self AppStart];
    
//    [UserSession setUserSessionIfExist];
//    MyAccountComponent *myAccountCompo=[[MyAccountComponent alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//    [myAccountCompo setUp];
//    myAccountCompo.blackOverLayView.image=[Constant takeScreenshot];
//    myAccountCompo.blackOverLayView.alpha=1;
//    
//    
//    [self.view addSubview:myAccountCompo];
//    
//    myAccountCompo.frame=self.view.bounds;
//
//    
    /*
    SignUpWizardSkillsComponent *skillController=[[SignUpWizardSkillsComponent alloc] initWithFrame:self.view.frame];
    [self.view addSubview:skillController];
    [skillController setUp];
    */

    
  /* [UserSession setUserSessionIfExist];
    ExploreComponent *compo=[[ExploreComponent alloc] initWithFrame:self.view.bounds];
    [compo setUp];
    [self.view addSubview:compo];
   */
    
    
//    [UserSession setUserSessionIfExist];
//    
//    EditPCComponent *Compo=[[EditPCComponent alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//    
//    [Compo setUp];
//    Compo.blackOverLayView.image=[Constant takeScreenshot];
//    Compo.blackOverLayView.alpha=1;
//    //  [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
//    
//    [self.view addSubview:Compo];
//    
//    [UIView animateWithDuration:0.001 animations:^{
//        Compo.frame=self.view.bounds;
//        Compo.backgroundColor=[UIColor whiteColor];
//    }];
//    
    

//    [UserSession setUserSessionIfExist];
//    NewPostComponent *cont=[[NewPostComponent alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:cont];
//    [cont setUpWithCellRect:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0)];
//
//  
    
    //TestCases
   /*[UserSession setUserSessionIfExist];
    SearchComponent *compo=[[SearchComponent alloc] initWithFrame:self.view.bounds];
    [compo setUp];
    [self.view addSubview:compo];
    */
 
    
    //    ShareComponent *compo=[[ShareComponent alloc] initWithFrame:self.view.frame];
    //    [compo setUp];
    //    [self.view addSubview:compo];
    
    
    

  
    /*SignUpWizardAppearanceComponent *c=[[SignUpWizardAppearanceComponent alloc] initWithFrame:self.view.frame];
    [self.view addSubview:c];
    [c setUp];
    */
    
    /*[UserSession setUserSessionIfExist];
    
    EditInterestsComponent *Compo=[[EditInterestsComponent alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [Compo setUp];
    Compo.blackOverLayView.image=[Constant takeScreenshot];
    Compo.blackOverLayView.alpha=1;
  //  [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
    
    [self.view addSubview:Compo];
    
    [UIView animateWithDuration:0.001 animations:^{
        Compo.frame=self.view.bounds;
        Compo.backgroundColor=[UIColor whiteColor];
    }];*/
    

   
    

  /* [UserSession setUserSessionIfExist];
      APITesterView *tester=[[APITesterView alloc] initWithFrame:self.view.bounds];
     [tester setUp];
     [self.view addSubview:tester];*/


//    [UserSession setUserSessionIfExist];
//    ExploreComponent *compo=[[ExploreComponent alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:compo];
//    [compo setUp];

}

-(void)testViews
{
    APIPoster *tester=[[APIPoster alloc] init];
    [tester callStaticAPIs];
    
    //    SignUpWizardAppearanceComponent *ck=[[SignUpWizardAppearanceComponent alloc] initWithFrame:self.view.bounds];
    //    [self.view addSubview:ck];
    //    //[c setTarget:self withFunction:@selector(loggedInSuccessfully:)];
    //    [ck setUp];

    
    
    NSLog(@"%@",[tester getInterestData]);
   
    
    connection=[[ConnectionBar alloc] init];
    [connection setUp];
    
    
    postUploader=[[PostUploadLoader alloc] init];
    [postUploader setUp];
    [postUploader setDelegate:self andFunc1:@selector(showStatusBar) andFunc2:@selector(hideStatusBar)];
   
    
    
    /*   APITesterView *tester=[[APITesterView alloc] initWithFrame:self.view.bounds];
     [tester setUp];
     [self.view addSubview:tester];
     */
    
    /*
     
     MaxPlayer *view=[[MaxPlayer alloc] initWithFrame:self.view.bounds];
     [self.view addSubview:view];
     [view setUp];
     [view setUpWithURLString:@"http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/media/post_videos/4958.mp4"];
     
     [view playStart];
     
     self.view.backgroundColor=[UIColor grayColor];
     */
    
}



#pragma mark - statusbar

-(void)showStatusBar
{
    statusBarHide=false;
    [self setNeedsStatusBarAppearanceUpdate];

}
-(void)hideStatusBar
{
    statusBarHide=true;
    [self setNeedsStatusBarAppearanceUpdate];

    
}
-(void)setStatusBarHide:(BOOL)flag
{
    statusBarHide=flag;
    [self setNeedsStatusBarAppearanceUpdate];

}

- (BOOL)prefersStatusBarHidden {
    return statusBarHide;
}

#pragma mark - New Post session

-(void)renderVideoAndPost:(NSDictionary *)dict witPath:(NSString *)path overlayImage:(UIImage *)image
{
 
    [self exportVideoWithOverLay:dict witPath:path overlayImage:image];
    
}

-(void)exportVideoWithOverLay1:(NSDictionary *)dict witPath:(NSString *)actualMediaPath overlayImage:(UIImage *)overLayImage
{
    
    
    
    CGSize requiredVideoSize=RX_mainScreenBounds.size;
    
    
    requiredVideoSize=CGSizeMake(requiredVideoSize.width*2, requiredVideoSize.height*2);
    
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:actualMediaPath] options:nil];
    
    
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *clipVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *clipAudioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    //If you need audio as well add the Asset Track for audio here
    
    
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:clipVideoTrack atTime:kCMTimeZero error:nil];
    [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:clipAudioTrack atTime:kCMTimeZero error:nil];
    
    [compositionVideoTrack setPreferredTransform:[[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] preferredTransform]];
    
    
    CGSize videoSize=clipVideoTrack.naturalSize;
    
    
    
    
    
    
    CALayer *parentLayer = [CALayer layer];
    
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    
    
    CALayer *titleLayer = [CALayer layer];
    titleLayer.contents = (id)overLayImage.CGImage;
    //titleLayer.frame = CGRectMake(15, 15, 600/8, 600/8);
    titleLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:titleLayer];
    
    
    
    
    
    AVMutableVideoComposition *videoComposition=[AVMutableVideoComposition videoComposition] ;
    videoComposition.frameDuration=CMTimeMake(1, 30);
    videoComposition.renderSize=videoSize;
    videoComposition.animationTool=[AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mixComposition duration]);
    
    
    AVAssetTrack *videoTrack = [[mixComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    
    // [layerInstruction setOpacity:0.0 atTime:videoAsset.duration];
    
    
    
    
    
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/utput_%@.mov",@"555"];
    
    [[NSFileManager defaultManager] removeItemAtPath:destinationPath error:nil];

    
    
    
    
    
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:KK_VideoQualityRatio];
    exportSession.videoComposition=videoComposition;
    
    exportSession.outputURL = [NSURL fileURLWithPath:destinationPath];
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        switch (exportSession.status)
        {
            case AVAssetExportSessionStatusCompleted:
            {
                NSLog(@"Export OK %@",destinationPath);
                
                
                NSDictionary *dict2=@{
                                     @"text":[dict valueForKey:@"text"],
                                     @"interest":[dict valueForKey:@"interest"],
                                     @"media":destinationPath,
                                     @"topic_names":[dict valueForKey:@"topic_names"],
                                     @"tags":[dict valueForKey:@"tags"]
                                     };
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self newPostSubmit:dict2];
                    
                    
                });

            }
            
                
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportSession.error);
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export Cancelled");
                break;
                
            default: break;
        }
    }];
    
}

-(void)exportVideoWithOverLay:(NSDictionary *)dict witPath:(NSString *)actualMediaPath overlayImage:(UIImage *)overLayImage
{
    
    
    
    CGSize requiredVideoSize=RX_mainScreenBounds.size;
    
    
    requiredVideoSize=CGSizeMake(requiredVideoSize.width*2, requiredVideoSize.height*2);
    
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:actualMediaPath] options:nil];
    
    
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *clipVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:clipVideoTrack atTime:kCMTimeZero error:nil];

    
    if([videoAsset tracksWithMediaType:AVMediaTypeAudio].count>0)
    {
        AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        AVAssetTrack *clipAudioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:clipAudioTrack atTime:kCMTimeZero error:nil];
    }


    
    
    [compositionVideoTrack setPreferredTransform:[[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] preferredTransform]];
    
    
    
    CGSize videoSize=clipVideoTrack.naturalSize;
    
    
    
    
    
    
    CALayer *parentLayer = [CALayer layer];
    
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    
    
    CALayer *titleLayer = [CALayer layer];
    titleLayer.contents = (id)overLayImage.CGImage;
    //titleLayer.frame = CGRectMake(15, 15, 600/8, 600/8);
    titleLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:titleLayer];
    
    
    
    
    
    AVMutableVideoComposition *videoComposition=[AVMutableVideoComposition videoComposition] ;
    videoComposition.frameDuration=CMTimeMake(1, 30);
    videoComposition.renderSize=videoSize;
    videoComposition.animationTool=[AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mixComposition duration]);
    
    
    AVAssetTrack *videoTrack = [[mixComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    
    // [layerInstruction setOpacity:0.0 atTime:videoAsset.duration];
    
    
    
    
    
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/utput_%@.mov",@"555"];
    
    [[NSFileManager defaultManager] removeItemAtPath:destinationPath error:nil];

    
    AVAssetTrack *track = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    CGSize dimensions = CGSizeApplyAffineTransform(track.naturalSize, track.preferredTransform);

    
    
    
    SDAVAssetExportSession *encoder = [SDAVAssetExportSession.alloc initWithAsset:mixComposition];
    encoder.outputFileType = AVFileTypeQuickTimeMovie;
    encoder.outputURL = [NSURL fileURLWithPath:destinationPath];
    encoder.videoComposition=videoComposition;
    
    encoder.videoSettings = @
    {
    AVVideoCodecKey: AVVideoCodecH264,
    AVVideoWidthKey: [NSNumber numberWithFloat:dimensions.width],
    AVVideoHeightKey: [NSNumber numberWithFloat:dimensions.height],
    AVVideoCompressionPropertiesKey: @
        {
        AVVideoAverageBitRateKey: @1100000,
        AVVideoProfileLevelKey: AVVideoProfileLevelH264High40,
        },
    };
    encoder.audioSettings = @
    {
    AVFormatIDKey: @(kAudioFormatMPEG4AAC),
    AVNumberOfChannelsKey: @2,
    AVSampleRateKey: @(44100/2),
    AVEncoderBitRateKey: @(128000/2),
    };

    
    
    [encoder exportAsynchronouslyWithCompletionHandler:^
     {
         if (encoder.status == AVAssetExportSessionStatusCompleted)
         {
             
             NSDictionary *dict2=@{
                                   @"text":[dict valueForKey:@"text"],
                                   @"interest":[dict valueForKey:@"interest"],
                                   @"media":destinationPath,
                                   @"topic_names":[dict valueForKey:@"topic_names"],
                                   @"tags":[dict valueForKey:@"tags"]
                                   };
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self newPostSubmit:dict2];
                 
                 
             });
//             
//             dispatch_async(dispatch_get_main_queue(), ^{
//                 
//                 NSData *data=[NSData dataWithContentsOfFile:destinationPath];
//                 [FTIndicator showToastMessage:[NSString stringWithFormat:@"Compressed %d kb",(int)data.length/1024]];
//             });
             
             
             NSLog(@"Export OK %@",destinationPath);
             
             NSLog(@"Video export succeeded");
         }
         else if (encoder.status == AVAssetExportSessionStatusCancelled)
         {
             NSLog(@"Video export cancelled");
         }
         else
         {
             NSLog(@"Video export failed with error: %@ (%ld)", encoder.error.localizedDescription, encoder.error.code);
         }
     }];
    
    
}


-(void)newPostSubmit:(NSDictionary *)dict;
{
//    NSDictionary *dict=@{
//                         @"text":statusString,
//                         @"interest":[NSString stringWithFormat:@"%d",channelId],
//                         @"media":mediaPath,
//                         @"topic_names":topicValue,
//                         @"tags":hashTagArray
//                         };
//    
    
    NSString *mediaPath=[dict valueForKey:@"media"];
    NSString *text=[dict valueForKey:@"text"];
    NSString *interest=[dict valueForKey:@"interest"];
    NSString *topic_names=[dict valueForKey:@"topic_names"];
    NSString *tags=[dict valueForKey:@"tags"];
    
    
    NSDictionary *dict1;
    if([topic_names isEqualToString:@""] && [tags isEqualToString:@"[]"])
    {
        dict1=@{
                @"text":text,
                @"interest":interest,
                };
    }
    if([topic_names isEqualToString:@""] && ![tags isEqualToString:@"[]"])
    {
        dict1=@{
                @"text":text,
                @"interest":interest,
                @"tags":tags
                };
    }
    else if(![topic_names isEqualToString:@""] && [tags isEqualToString:@"[]"])
    {
        dict1=@{
                @"text":text,
                @"interest":interest,
                @"topic_names":topic_names,
                };
    }
    else if(![topic_names isEqualToString:@""] && ![tags isEqualToString:@"[]"])
    {
        dict1=@{
                @"text":text,
                @"interest":interest,
                @"topic_names":topic_names,
                @"tags":tags
                };
    }
    
    
    
    
    if([mediaPath isEqualToString:@""])
    {
        APIManager *manager=[[APIManager alloc] init];
        [manager sendRequestForNewPost:dict1 delegate:self andSelector:@selector(addNewPostResponse:)];
        
    }
    else
    {
        APIManager *manager=[[APIManager alloc] init];
        NSString *pathExtension=[[mediaPath pathExtension] lowercaseString];
        BOOL isVideo;
        if([pathExtension isEqualToString:@"png"] || [pathExtension isEqualToString:@"jpg"])
        {
            isVideo=false;
        }
        else
        {
            isVideo=true;
        }
        [manager sendRequestForNewPostWithMedia:dict1 WithMediaURL:mediaPath andTypeisVideo:isVideo delegate:self andSelector:@selector(addNewPostResponse:)];
        
    }
    
    
    
    
    [postUploader showProgress];
    
    
    
}

-(void)addNewPostResponse:(APIResponseObj *)responseObj
{
    if(responseObj.statusCode!=200)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"REFRESH_HOME"
         object:self];
        
        [postUploader FailedProgress];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"REFRESH_HOME"
         object:self];
        
        [postUploader hideProgress];
    }
}


#pragma mark - Login Logout session

-(void)AppStart
{

    [Constant setStatusBarColorWhite:true];
    
    APIPoster *tester=[[APIPoster alloc] init];
    [tester callStaticAPIs];
    
    
    
    NSLog(@"%@",[tester getInterestData]);
    
    
    connection=[[ConnectionBar alloc] init];
    [connection setUp];
    
    
    postUploader=[[PostUploadLoader alloc] init];
    [postUploader setUp];
    [postUploader setDelegate:self andFunc1:@selector(showStatusBar) andFunc2:@selector(hideStatusBar)];
    
    
    [UserSession setUserSessionIfExist];
    
    if(self.sessionMain==nil)
    {
        c=[[FirstLaunchScreen alloc] initWithFrame:mainKeyView.bounds];
        [mainKeyView addSubview:c];
        [c setTarget:self withFunction:@selector(loggedInSuccessfully:)];
        [c setUp];
        
    }
    else
    {

           HomeScreen *cm=[[HomeScreen alloc] initWithFrame:mainKeyView.bounds];
         [cm setUp];
         [mainKeyView addSubview:cm];

    }
    
    
    [self UserNotificationAPI];
    
}

-(void)updateProfilePicture:(NSString *)path
{
    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestForUpdateProfilePhoto:path delegate:self andSelector:@selector(profilePictureUpdated:)];
    [postUploader showProgress];

}
-(void)profilePictureUpdated:(APIResponseObj *)responseObj
{
    [postUploader hideProgress];

    if(responseObj.statusCode==200)
    {
        
        [UserSession setSessionProfileObj:responseObj.response andAccessToken:[UserSession getAccessToken]];
        [[DataSession sharedInstance] userProfileUpdate:[UserSession getUserObj]];
        
    }
}
-(void)updateCoverPicture:(NSString *)path
{
    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestForUpdateCoverPhoto:path delegate:self andSelector:@selector(coverPhotoUpdated:)];
    [postUploader showProgress];

}
-(void)updateProfileWithDict:(NSDictionary *)dict;
{
    if(![dict valueForKey:@"old_password"])
    {
        APIManager *manager=[[APIManager alloc] init];
        [manager sendRequestForEditProfile:dict delegate:self andSelector:@selector(coverPhotoUpdated:)];
        [postUploader showProgress];

        
    }
   
    else
    {
       // NSString *stringPassword=[dict valueForKey:@"old_password"];
        
        APIManager *manager=[[APIManager alloc] init];
        [manager sendRequestForChangePassword:dict delegate:self andSelector:@selector(changePasswordSuccessfully:)];
        [postUploader showProgress];
        
    }

}
-(void)changePasswordSuccessfully:(APIResponseObj *)responseObj
{
    [postUploader hideProgress];
    
    if(responseObj.statusCode==200)
    {
        //[UserSession setSessionProfileObj:responseObj.response andAccessToken:[UserSession getAccessToken]];
        
    }
    else
    {
        [FTIndicator showErrorWithMessage:@"Make sure you enter correct password Or New password must contain letters and digits."];
    }
}

-(void)coverPhotoUpdated:(APIResponseObj *)responseObj
{
    [postUploader hideProgress];

    if(responseObj.statusCode==200)
    {
        [UserSession setSessionProfileObj:responseObj.response andAccessToken:[UserSession getAccessToken]];
        [[DataSession sharedInstance] userProfileUpdate:[UserSession getUserObj]];

    }
}

-(void)MasterlogoutBtnClicked:(id)sender
{

    
    [UserSession clearUserSession];
    
    [[mainKeyView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    c=[[FirstLaunchScreen alloc] initWithFrame:mainKeyView.bounds];
    [mainKeyView addSubview:c];
    [c setTarget:self withFunction:@selector(loggedInSuccessfully:)];
    [c setUp];
    
}
-(void)loggedInSuccessfully:(id)sender
{

    [Constant setStatusBarColorWhite:false];


    HomeScreen *cm=[[HomeScreen alloc] initWithFrame:mainKeyView.bounds];
    [cm setUp];
    [mainKeyView addSubview:cm];


    cm.alpha=0;
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        
        
        cm.alpha=1;
        c.alpha=0;
        
        
    } completion:^(BOOL finished) {
       
        [c removeFromSuperview];

    }];
    
    
    
    

}
#pragma mark - Notifications

-(void)UserNotificationAPI
{
    int number=[[DataSession sharedInstance].SocialshareStatus intValue];

    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(self.sessionMain!=nil && number==0 && delegate.deepLinkViewer==nil)
    {
    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestForMyNotificationsWithdelegate:self andSelector:@selector(UserNotificationAPIReceived:)];
        [self performSelector:@selector(UserNotificationAPI) withObject:nil afterDelay:90];

    }
    else
    {
        [self performSelector:@selector(UserNotificationAPI) withObject:nil afterDelay:5];

    }
    
    
}

-(void)UserNotificationAPIReceived:(APIResponseObj *)responseObj
{
   // NSLog(@"%@",responseObj.response);
    
    
    if([[responseObj.response valueForKey:@"data"] isKindOfClass:[NSArray class]])
    {
        NSArray *array=(NSArray *)[responseObj.response valueForKey:@"data"];
        APIObjectsParser *parser=[[APIObjectsParser alloc] init];
        [DataSession sharedInstance].notificationsResults=[NSMutableArray arrayWithArray:[parser parseObjects_NOTIFICATIONS:array]];
        
        
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"NewNotificationDataReceived"
         object:self];
        
        
        if(!RX_isiPhone4Res)
        {

        if([DataSession sharedInstance].notificationsResults.count>0)
        {
        int no=[DataSession sharedInstance].noOfInstantNotificationReceived.intValue;
        
            if(no>0)
            {

        
                NotificationBadgeView *notificationBar=[[NotificationBadgeView alloc] init];
                [notificationBar setDelegate:self andFunc1:@selector(showStatusBar) andFunc2:@selector(hideStatusBar)];
            

                if(no==1)
                {
                    
                    [notificationBar setUp:[[DataSession sharedInstance].notificationsResults objectAtIndex:0]];
                }
                else
                {
                    [notificationBar setUp:[NSNumber numberWithInt:no]];
                }
            }
//
        }
        }
        
     //   [FTIndicator showNotificationWithTitle:@"Notifications" message:[NSString stringWithFormat:@"%d",(int)[DataSession sharedInstance].notificationsResults.count]];
        
        
        /*NotificationScreen *screen=[[NotificationScreen alloc] initWithFrame:self.frame];
        [self addSubview:screen];
        [screen setUp:result];*/
        
        
    }
    
    
    
    
    
    
}

#pragma mark - other

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    int p=0;
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}


@end
