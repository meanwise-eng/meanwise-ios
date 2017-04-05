//
//  ExploreSearchComponent.h
//  ExactResearch
//
//  Created by Hardik on 23/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "APIManager.h"

@interface ExploreSearchComponent : UIView <UICollectionViewDataSource,UICollectionViewDelegate>
{
    int selectedSegmentIndex;
    UIView *segmentView;
    
    UIButton *segmentPostsBtn;
    UIButton *segmentTopicsBtn;
    UIButton *segmentHashtagsBtn;
    

    UIView *tableViewBgView;
    UICollectionView *listofItems;
    NSString *searchTerm;
    
    id target;
    SEL onSearchItemSelectedFunc;
    
    NSArray *suggestionArray;
    
    UIActivityIndicatorView *activityView;
    
}
-(void)setUp;
-(void)setSearchTerm:(NSString *)string;
-(void)setTarget:(id)targetReceived OnSearchItemSelectedFunc:(SEL)func;
@end
