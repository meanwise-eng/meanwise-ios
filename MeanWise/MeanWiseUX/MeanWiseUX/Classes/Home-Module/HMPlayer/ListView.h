//
//  ListView.h
//  MeanWiseUX
//
//  Created by Hardik on 31/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMVideoPlayer.h"
#import "AppDelegate.h"

@interface ListView : UIView <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *listView;
    UIRefreshControl *refreshControl;
    NSArray *videoURLarray;
}
-(void)setUp;

@end
