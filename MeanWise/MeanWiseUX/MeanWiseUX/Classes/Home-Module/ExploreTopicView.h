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

    NSArray *arrayTopics;
    
    int selectedChannel;
}
-(void)setUp:(int)height;
-(void)setChannelId:(int)channelId;
@end
