//
//  ExploreChannelsBar.h
//  MeanWiseUX
//
//  Created by Hardik on 05/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExploreChannelsBar : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *channelList;

    UICollectionView *ChannelList;

    id target;
    SEL onChannelSelect;
}
-(void)setUp;
-(void)setTarget:(id)target onChannelSelectCall:(SEL)func;


@end
