//
//  ProfileWindowFeedControl.h
//  MeanWiseUX
//
//  Created by Hardik on 09/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewComponent.h"
#import "ExplorePostsBar.h"
#import "ProfileWindowFeedFilterControl.h"


@interface ProfileWindowFeedControl : UIView
{
    
    ExplorePostsBar *recentPostsControl;
    ExplorePostsBar *currentHolder;

    
    //Detail Post
    DetailViewComponent *detailPostView;

    ProfileWindowFeedFilterControl *filterControl;
    
    id target;
    SEL onPostReceivedCallBack;
    
    BOOL isUserCanDeletePost;
}
-(void)setTarget:(id)targetReceived andOnPostReceive:(SEL)func;

-(void)setUp:(NSString *)userId;


@end
