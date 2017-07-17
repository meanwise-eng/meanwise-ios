//
//  AppDelegate.h
//  MeanWiseUX
//
//  Created by Hardik on 15/08/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCacheManager.h"
#import "DeepLinkViewer.h"
#import "VersionUtility.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{

    VersionUtility *vuti;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSOperationQueue *MeanWise_VideoQueue;
@property (nonatomic, strong) NSOperationQueue *MeanWise_ImageQueue;
@property (nonatomic, strong) DeepLinkViewer *deepLinkViewer;


@property (nonatomic,strong) UINavigationController *navController;


@end



/*
 
 //https://github.com/layerhq/releases-ios
 //https://support.layer.com/hc/en-us/articles/204256740-Can-I-use-LayerKit-without-Cocoapods-
 


List of the apis
Ask about the flow to Hilal

-If user does not search anything
-Search typing in the bottom?
 
-Live Commenting on Post? - livecomments2,livecomments.png

 
-share screen shows the list of users? how they will be choosed?
 

 
 
 
-User can add connection and create network?
-Explore and search - flow
 -Missig Flow : Edit channel, Edit profile, logout, Friend/FollowerList
 -Missing Screen : Edit Profile, Friend/FollowersList

 
 
 
 
*/
