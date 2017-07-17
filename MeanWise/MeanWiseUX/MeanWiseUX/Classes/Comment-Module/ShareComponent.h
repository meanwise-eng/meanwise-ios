//
//  ShareComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 26/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "APIObjects_FeedObj.h"

@interface ShareComponent : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
{
    
    UIView *blackOverLay;
        UIView *containerView;
    
    UIButton *cancelBtn;
    
    UICollectionView *peopleList;

    UILabel *shareTitle;
    
    UIView *seperator1;
    UIView *seperator2;
    UIView *seperator3;
    
    NSMutableArray *socialBtnArray;

    id delegate;
    SEL closeBtnClicked;
    
    UIActivityViewController *activityViewControntroller;

    APIObjects_FeedObj *mainData;
    NSString *postIdReceived;
}
-(void)setUp;
-(void)setTarget:(id)target andCloseBtnClicked:(SEL)func1;
-(void)setMainData:(APIObjects_FeedObj *)feed;
-(void)setPostId:(NSString *)postId;

@end

/*

 ShareComponent *sharecompo;

 [sharecompo removeFromSuperview];
 sharecompo=nil;
 
 
 sharecompo=[[ShareComponent alloc] initWithFrame:self.bounds];
 [sharecompo setUp];
 [self.contentView addSubview:sharecompo];
 
*/