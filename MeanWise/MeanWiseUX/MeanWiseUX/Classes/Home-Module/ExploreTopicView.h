//
//  ExploreTopicView.h
//  ExactResearch
//
//  Created by Hardik on 20/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@interface ExploreTopicView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *topicListView;

    NSMutableArray *arrayTopics;
    
    int selectedChannel;
    NSString *searchTerm;
    
    UIActivityIndicatorView *activityView;

    id target;
    SEL onTopicSelectCallBack;
    
    int selectedTopicCellIndex;

}
-(void)setUp:(int)height;
-(void)setChannelId:(int)channelId;
-(void)setSearchTerm:(NSString *)string;
-(void)setTarget:(id)targetReceived OnTopicSelectCallBack:(SEL)func;

@end
