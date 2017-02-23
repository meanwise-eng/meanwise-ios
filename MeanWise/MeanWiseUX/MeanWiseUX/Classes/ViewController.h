//
//  ViewController.h
//  MeanWiseUX
//
//  Created by Hardik on 15/08/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "HomeComponent.h"
#import "APIPoster.h"
#import "WalkthroughControl.h"
#import "APIObjects_ProfileObj.h"

#import "FirstLaunchScreen.h"
#import "ConnectionBar.h"
#import "PostUploadLoader.h"

@interface ViewController : UIViewController
{
    FirstLaunchScreen *c;
    
    
    BOOL statusBarHide;
    ConnectionBar *connection;
    PostUploadLoader *postUploader;
    
}
@property (nonatomic, strong) APIObjects_ProfileObj *sessionMain;


-(void)MasterlogoutBtnClicked:(id)sender;
-(void)setStatusBarHide:(BOOL)flag;
-(void)newPostSubmit:(NSDictionary *)dict;


-(void)updateProfilePicture:(NSString *)path;
-(void)updateCoverPicture:(NSString *)path;
-(void)updateProfileWithDict:(NSDictionary *)dict;

@end



/*

 http://vombat.tumblr.com/post/86294492874/caching-audio-streamed-using-avplayer
 
*/