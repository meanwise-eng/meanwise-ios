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
#import "MaxPlayer.h"
#import "UserSession.h"
#import "SignUpWizardAppearanceComponent.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;

    statusBarHide=false;
    

   [self AppStart];
  
    /*SignUpWizardAppearanceComponent *c=[[SignUpWizardAppearanceComponent alloc] initWithFrame:self.view.frame];
    [self.view addSubview:c];
    [c setUp];
    */
    

    
/*    [UserSession setUserSessionIfExist];

      APITesterView *tester=[[APITesterView alloc] initWithFrame:self.view.bounds];
     [tester setUp];
     [self.view addSubview:tester];

*/
    
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

-(void)newPostSubmit:(NSDictionary *)dict;
{
    
    
    NSString *mediaPath=[dict valueForKey:@"media"];
    NSString *text=[dict valueForKey:@"text"];
    NSString *interest=[dict valueForKey:@"interest"];
    
    if([mediaPath isEqualToString:@""])
    {
        APIManager *manager=[[APIManager alloc] init];
        
        
        NSDictionary *dict1=@{
                              @"text":text,
                              @"interest":interest,
                              };
        
        [manager sendRequestForNewPost:dict1 delegate:self andSelector:@selector(addNewPostResponse:)];
        
        
        
    }
    else
    {
        APIManager *manager=[[APIManager alloc] init];
        
        NSDictionary *dict1=@{
                              @"text":text,
                              @"interest":interest,
                              };
        
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
    
    [postUploader hideProgress];
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
        c=[[FirstLaunchScreen alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:c];
        [c setTarget:self withFunction:@selector(loggedInSuccessfully:)];
        [c setUp];
        
    }
    else
    {
           HomeScreen *cm=[[HomeScreen alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
         [cm setUp];
         [self.view addSubview:cm];

        
    }
    
    
    
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
    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestForEditProfile:dict delegate:self andSelector:@selector(coverPhotoUpdated:)];
    
    [postUploader showProgress];

}
-(void)coverPhotoUpdated:(APIResponseObj *)responseObj
{
    [postUploader hideProgress];

    if(responseObj.statusCode==200)
    {
        [UserSession setSessionProfileObj:responseObj.response andAccessToken:[UserSession getAccessToken]];

    }
}
-(void)MasterlogoutBtnClicked:(id)sender
{
    [UserSession clearUserSession];
    
    [[self.view subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    c=[[FirstLaunchScreen alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:c];
    [c setTarget:self withFunction:@selector(loggedInSuccessfully:)];
    [c setUp];
    
}
-(void)loggedInSuccessfully:(id)sender
{

    [Constant setStatusBarColorWhite:false];

    HomeScreen *cm=[[HomeScreen alloc] initWithFrame:self.view.bounds];
    [cm setUp];
    [self.view addSubview:cm];


    cm.alpha=0;
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        
        
        cm.alpha=1;
        c.alpha=0;
        
        
    } completion:^(BOOL finished) {
       
        [c removeFromSuperview];

    }];
    
    
    
    

}


#pragma mark - other

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


@end
