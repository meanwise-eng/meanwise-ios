//
//  ExploreSearchComponent.h
//  ExactResearch
//
//  Created by Hardik on 23/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@interface ExploreSearchComponent : UIView <UICollectionViewDataSource,UICollectionViewDelegate>
{
    int selectedSegmentIndex;
    UIView *segmentView;
    
    UIButton *segmentPostsBtn;
    UIButton *segmentTopicsBtn;
    UIButton *segmentHashtagsBtn;
    

    UIView *tableViewBgView;
    UICollectionView *listofItems;
}
-(void)setUp;
@end
