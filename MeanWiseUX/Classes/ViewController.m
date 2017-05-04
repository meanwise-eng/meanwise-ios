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
#import "EditSkillsComponent.h"

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

    
    
    
    
    //Final
    [self AppStart];

    
    
  /*  [UserSession setUserSessionIfExist];
    ExploreComponent *compo=[[ExploreComponent alloc] initWithFrame:self.view.bounds];
    [compo setUp];
    [self.view addSubview:compo];
    */
    
   /* [UserSession setUserSessionIfExist];
    
    EditSkillsComponent *Compo=[[EditSkillsComponent alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [Compo setUp];
    Compo.blackOverLayView.image=[Constant takeScreenshot];
    Compo.blackOverLayView.alpha=1;
    //  [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
    
    [self.view addSubview:Compo];
    
    [UIView animateWithDuration:0.001 animations:^{
        Compo.frame=self.view.bounds;
        Compo.backgroundColor=[UIColor whiteColor];
    }];*/
    
    
  /*  [UserSession setUserSessionIfExist];
    NewPostComponent *cont=[[NewPostComponent alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:cont];
    [cont setUpWithCellRect:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0)];
*/
    
    
    //TestCases
   /*[UserSession setUserSessionIfExist];
    SearchComponent *compo=[[SearchComponent alloc] initWithFrame:self.view.bounds];
    [compo setUp];
    [self.view addSubview:compo];
    */
 

    

  
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
    
    
    NSData *media=[dict valueForKey:@"media"];
    NSString *dataType=[dict valueForKey:@"type"];
    NSString *text=[dict valueForKey:@"text"];
    NSString *interest=[dict valueForKey:@"interest"];
    NSString *topic_names=[dict valueForKey:@"topic_names"];
    NSString *tags=[dict valueForKey:@"tags"];
    //NSString *story=[dict valueForKey:@"story"];
    

    
    NSDictionary *dict1;
    if([topic_names isEqualToString:@"none"])
    {
        
        if([tags isEqualToString:@"[]"]){
            dict1=@{
                @"text":text,
                @"interest":interest
                };
        }
        else{
            dict1=@{
                    @"text":text,
                    @"interest":interest,
                    @"tags":tags
                    };
        }
    }
    else
    {
        if([tags isEqualToString:@"[]"]){
            dict1=@{
                @"text":text,
                @"interest":interest,
                @"topic_names":topic_names
                };
        }
        else{
            dict1=@{
                    @"text":text,
                    @"interest":interest,
                    @"topic_names":topic_names,
                    @"tags":tags
                    };
        }
    }
    
    
   // NSLog(@"POST VALUES ARE text: %@, interest: %@, topics: %@, tags: %@, Media: %@", text, interest, topic_names, tags, mediaPath);
    
    
    if([dataType isEqualToString:@"none"])
    {
        APIManager *manager=[[APIManager alloc] init];
        [manager sendRequestForNewPost:dict1 delegate:self andSelector:@selector(addNewPostResponse:)];
        
    }
    else
    {
        APIManager *manager=[[APIManager alloc] init];
        
        BOOL isVideo;
        if([dataType isEqualToString:@"image"])
        {
            isVideo=false;
        }
        else
        {
            isVideo=true;
        }
        
        [manager sendRequestForNewPostWithMedia:dict1 WithMediaData:media andTypeisVideo:isVideo delegate:self andSelector:@selector(addNewPostResponse:)];
        
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
        c=[[FirstLaunchScreen alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:c];
        [c setTarget:self withFunction:@selector(loggedInSuccessfully:)];
        [c setUp];
        
    }
    else
    {
           HomeScreen *cm=[[HomeScreen alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
           [cm setUp];
           [cm setSessionMain:self.sessionMain];
           [cm setTarget:self setNewPost:@selector(newPostSubmit:)];
           [self.view addSubview:cm];

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
    [cm setSessionMain:self.sessionMain];
    [cm setTarget:self setNewPost:@selector(newPostSubmit:)];
    [self.view addSubview:cm];


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
    if(self.sessionMain!=nil)
    {
    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestForNotificationsWithdelegate:self andSelector:@selector(UserNotificationAPIReceived:)];
    }
    
    [self performSelector:@selector(UserNotificationAPI) withObject:nil afterDelay:60.0f];
}
-(void)UserNotificationAPIReceived:(APIResponseObj *)responseObj
{
   // NSLog(@"%@",responseObj.response);
    
    
    if([responseObj.response isKindOfClass:[NSArray class]])
    {
        NSArray *array=(NSArray *)responseObj.response;
        APIObjectsParser *parser=[[APIObjectsParser alloc] init];
        [DataSession sharedInstance].notificationsResults=[NSMutableArray arrayWithArray:[parser parseObjects_NOTIFICATIONS:array]];
       
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"NewNotificationDataReceived"
         object:self];
        
        
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
        
     //   [FTIndicator showNotificationWithTitle:@"Notifications" message:[NSString stringWithFormat:@"%d",(int)[DataSession sharedInstance].notificationsResults.count]];
        
        
        /*NotificationScreen *screen=[[NotificationScreen alloc] initWithFrame:self.frame];
        [self addSubview:screen];
        [screen setUp:result];*/
        
        
    }
    
    
    
    
    
    
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
