//
//  NewPostVC.h
//  MeanWiseUX
//
//  Created by Mohamed Aas on 4/16/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelSearchView.h"
#import "UITextView+Placeholder.h"
#import "Constant.h"
#import "UserSession.h"
#import "APIObjects_ProfileObj.h"
#import "UIImageHM.h"
#import "CameraView.h"
#import "NewPostImagePreview.h"
#import "NewPostVideoPreview.h"


@interface NewPostVC : UIViewController<UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    UIImageHM *profileIMGVIEW;
    UIButton *postBtn;
    UITextView *statusView;
    UILabel *characterCountLBL;
    UILabel *replyToLBL;
    
    ChannelSearchView *channelSelectionView;
    UICollectionView *feedList;
    
    NSMutableArray *hashTagArray;
    NSMutableArray *topicArray;
    
    NSMutableArray *dataRecords;
    
    APIManager* manager;
    
    NSData *postMedia;
    NSString *postMediaType;
    
    NSTimer *autoTimer;
    
    BOOL isProgressing;
    
    NSString *statusTextVal;
    NSString *storyId;
    int channelIDVal;
    
    CameraView* cameraView;
    
    NewPostImagePreview *imagePreview;
    NewPostVideoPreview *videoPreview;
    
    id target;
    id mainTarget;
    
    SEL newPostFunc;
    SEL closeCallBackfunc;
}

@property (nonatomic, strong) APIObjects_ProfileObj *sessionMain;

- (instancetype)initWithSession:(APIObjects_ProfileObj*)session;
-(void)setTarget:(id)targetReceived onCloseEvent:(SEL)func1;
-(void)setTarget:(id)delegate setNewPost:(SEL)func1;

@end
