//
//  AppDelegate.m
//  MeanWiseUX
//
//  Created by Hardik on 15/08/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "AppDelegate.h"
#import "FTIndicator.h"
#import "ViewController.h"
#import "ResolutionVersion.h"
#import "AnalyticsMXManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
-(NSUserDefaults *)userDefault
{
    return [NSUserDefaults standardUserDefaults];
}

-(void)clearcache
{
   // NSArray *array=[[NSArray alloc] init];
    NSUserDefaults *default1=[self userDefault];
   // [default1 setObject:array forKey:@"DATA_IMAGECACHE"];
    [default1 removeObjectForKey:@"DATA_IMAGECACHE"];
    [default1 synchronize];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self listOfFonts];
    
    
    // TODO: Move this to where you establish a user session

    [AnalyticsMXManager PushAnalyticsStartup];
    
    
    BOOL iphone5=RX_isiPhone5Res;

    BOOL iphoen52=[ResolutionVersion IfResIPhone5];
   // [self clearcache];
    
    
    
    
    self.MeanWise_VideoQueue = [[NSOperationQueue alloc]init];
    self.MeanWise_VideoQueue.maxConcurrentOperationCount = 1;

    self.MeanWise_ImageQueue=[[NSOperationQueue alloc] init];
    self.MeanWise_ImageQueue.maxConcurrentOperationCount=10;
    
    [FTIndicator setIndicatorStyle:UIBlurEffectStyleDark];
    
    [VideoCacheManager setUp];
   // [VideoCacheManager clearCache];
   
    
   

   /* NSUInteger cacheSizeMemory = 10*1024*1024; // 500 MB
    NSUInteger cacheSizeDisk = 10*1024*1024; // 500 MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    sleep(1); // Critically important line, sadly, but it's worth it!

    */

    [UserSession setUserSessionIfExist];
    
    self.navController=(UINavigationController *)self.window.rootViewController;


    [self clearAllTheNotifications];

    vuti=[[VersionUtility alloc] init];
    [vuti setUpWithTarget:self onCallBack:nil];
    
    [vuti requestForCall];
    
    // Override point for customization after application launch.
    return YES;
}
-(void)clearAllTheNotifications
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    

}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    


    NSString * deviceTokenString = [[[[deviceToken description]
                                      stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                     stringByReplacingOccurrencesOfString: @">" withString: @""]
                                    stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    
    

    if([UserSession sessionProfileObj]!=nil)
    {
    
    APIManager *manager=[[APIManager alloc] init];
    [manager registerDeviceForPushNotification:deviceTokenString delegate:self andSelector:@selector(registerDevice:)];
    
    NSLog(@"DEVICE TOKEN IS : %@", deviceTokenString);
    }
    
    
}
-(void)registerDevice:(APIResponseObj *)responseObj
{
    if(responseObj.statusCode!=200)
    {
        NSLog(@"REGISTRATION FOR PUSH: FAILED");
        
    }
    else
    {
        NSLog(@"REGISTRATION FOR PUSH: SUCCESS");
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {

    UIApplicationState state = [application applicationState];
    // user tapped notification while app was in background
    if (state == UIApplicationStateInactive || state == UIApplicationStateBackground)
    {
        
        //        UINavigationController *vc=(UINavigationController *)[Constant topMostController];
        //        ViewController *t=(ViewController *)vc.topViewController;
        //        [t checkTheNotificationsManually];
        //
        // [FTIndicator showInfoWithMessage:[NSString stringWithFormat:@"Background : %@",userInfo]];
        
        // go to screen relevant to Notification content
    }
    else
    {
        //  [FTIndicator showInfoWithMessage:[NSString stringWithFormat:@"Foreground : %@",userInfo]];
        
        //  [FTIndicator showToastMessage:alert];
        
        //        [FTIndicator showNotificationWithTitle:@"1 Notification!" message:@""];
        [self clearAllTheNotifications];
        
        // App is in UIApplicationStateActive (running in foreground)
        // perhaps show an UIAlertView
    }

}



-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    
    [self parseDeepLinking:url Options:options];
    
    return true;
}
-(void)parseDeepLinking:(NSURL *)url Options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    
    
    if(RX_isiPhone4Res)
    {
        return;
    }
    
   // [FTIndicator showSuccessWithMessage:url.absoluteString];
    
    NSString *string=url.absoluteString;
    
    if([string hasPrefix:@"meanwise://post/"] && [UserSession getAccessToken]!=nil)
    {
     
        [self showDeepLinkURL:string];
        
    }
    else
    {
     
        [self performSelector:@selector(showDeepLinkURL:) withObject:string afterDelay:0.5];
    }
    
}
-(void)showDeepLinkURL:(NSString *)string
{
    if([UserSession getAccessToken]!=nil)
    {
    [self.deepLinkViewer cleanUp];
    self.deepLinkViewer=nil;
    
    NSString *postId=[string substringFromIndex:16];
    
    self.deepLinkViewer=[[DeepLinkViewer alloc] init];
    [self.deepLinkViewer setUpWithPostId:postId];
        [self.deepLinkViewer setDelegate:self onCleanUp:@selector(onDeepLinkControlDismiss:)];
    }
    else
    {
         [FTIndicator showErrorWithMessage:@"Please must be logged in to view this post."];
    }
    
}
-(void)onDeepLinkControlDismiss:(id)sender
{
    
    [self.deepLinkViewer removeFromSuperview];
    self.deepLinkViewer=nil;

}
-(void)listOfFonts
{
    
    NSArray *fontFamilies = [UIFont familyNames];
    
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }

}
/*-(void)setUpLayer
{
    
    NSURL *appID = [NSURL URLWithString:@"layer:///apps/staging/8c139304-6072-11e5-9019-7a6b010037c7"];
    self.layerClient = [LYRClient clientWithAppID:appID];
    [self.layerClient connectWithCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"Failed to connect to Layer: %@", error);
        } else {
            // For the purposes of this Quick Start project, let's authenticate as a user named 'Device'.  Alternatively, you can authenticate as a user named 'Simulator' if you're running on a Simulator.
            NSString *userIDString = @"Device";
            // Once connected, authenticate user.
            // Check Authenticate step for authenticateLayerWithUserID source
            [self authenticateLayerWithUserID:userIDString completion:^(BOOL success, NSError *error) {
                if (!success) {
                    NSLog(@"Failed Authenticating Layer Client with error:%@", error);
                }
            }];
        }
    }];
    
    
    
}
- (void)authenticateLayerWithUserID:(NSString *)userID completion:(void (^)(BOOL success, NSError * error))completion
{
    // Check to see if the layerClient is already authenticated.
    if (self.layerClient.authenticatedUser) {
        // If the layerClient is authenticated with the requested userID, complete the authentication process.
        if ([self.layerClient.authenticatedUser.userID isEqualToString:userID]){
            NSLog(@"Layer Authenticated as User %@", self.layerClient.authenticatedUser.userID);
            if (completion) completion(YES, nil);
            return;
        } else {
            //If the authenticated userID is different, then deauthenticate the current client and re-authenticate with the new userID.
            [self.layerClient deauthenticateWithCompletion:^(BOOL success, NSError *error) {
                if (!error){
                    [self authenticationTokenWithUserId:userID completion:^(BOOL success, NSError *error) {
                        if (completion){
                            completion(success, error);
                        }
                    }];
                } else {
                    if (completion){
                        completion(NO, error);
                    }
                }
            }];
        }
    } else {
        // If the layerClient isn't already authenticated, then authenticate.
        [self authenticationTokenWithUserId:userID completion:^(BOOL success, NSError *error) {
            if (completion){
                completion(success, error);
            }
        }];
    }
}

- (void)authenticationTokenWithUserId:(NSString *)userID completion:(void (^)(BOOL success, NSError* error))completion{
 
    [self.layerClient requestAuthenticationNonceWithCompletion:^(NSString *nonce, NSError *error) {
        if (!nonce) {
            if (completion) {
                completion(NO, error);
            }
            return;
        }
        
 
         * 2. Acquire identity Token from Layer Identity Service
 
        [self requestIdentityTokenForUserID:userID appID:[self.layerClient.appID absoluteString] nonce:nonce completion:^(NSString *identityToken, NSError *error) {
            if (!identityToken) {
                if (completion) {
                    completion(NO, error);
                }
                return;
            }
            
            
             * 3. Submit identity token to Layer for validation
 
            [self.layerClient authenticateWithIdentityToken:identityToken completion:^(LYRIdentity *authenticatedUser, NSError *error) {
                if (authenticatedUser) {
                    if (completion) {
                        completion(YES, nil);
                    }
                    NSLog(@"Layer Authenticated as User: %@", authenticatedUser.userID);
                } else {
                    completion(NO, error);
                }
            }];
        }];
    }];
}
- (void)requestIdentityTokenForUserID:(NSString *)userID appID:(NSString *)appID nonce:(NSString *)nonce completion:(void(^)(NSString *identityToken, NSError *error))completion
{
    NSParameterAssert(userID);
    NSParameterAssert(appID);
    NSParameterAssert(nonce);
    NSParameterAssert(completion);
    
    NSURL *identityTokenURL = [NSURL URLWithString:@"https://layer-identity-provider.herokuapp.com/identity_tokens"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:identityTokenURL];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDictionary *parameters = @{ @"app_id": appID, @"user_id": userID, @"nonce": nonce };
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    request.HTTPBody = requestBody;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        // Deserialize the response
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if(![responseObject valueForKey:@"error"])
        {
            NSString *identityToken = responseObject[@"identity_token"];
            completion(identityToken, nil);
        }
        else
        {
            NSString *domain = @"layer-identity-provider.herokuapp.com";
            NSInteger code = [responseObject[@"status"] integerValue];
            NSDictionary *userInfo =
            @{
              NSLocalizedDescriptionKey: @"Layer Identity Provider Returned an Error.",
              NSLocalizedRecoverySuggestionErrorKey: @"There may be a problem with your APPID."
              };
            
            NSError *error = [[NSError alloc] initWithDomain:domain code:code userInfo:userInfo];
            completion(nil, error);
        }
        
    }] resume];
}*/

- (void)applicationWillResignActive:(UIApplication *)application {
    

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self clearAllTheNotifications];
    



   [[NSNotificationCenter defaultCenter]
     postNotificationName:@"REFRESH_HOME"
     object:self];
    
    
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"REFRESH_EXPLORE_INTERESTS"
     object:self];
    
//    
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [vuti requestForCall];
    
       // [[Crashlytics sharedInstance] crash];


    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
