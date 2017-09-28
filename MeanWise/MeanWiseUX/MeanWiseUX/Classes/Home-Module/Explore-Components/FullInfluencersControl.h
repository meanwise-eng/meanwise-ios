//
//  FullInfluencersControl.h
//  MeanWiseUX
//
//  Created by Hardik on 11/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIImageHM.h"

@interface FullInfluencersControl : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
{
    
    NSMutableArray *dataArray;
    UICollectionView *userLists;

    
    int typeOfSearch;
    NSDictionary *searchDict;
    
    UIImageView *baseShadow;
    UIButton *closeBtn;
    
    id target;
    SEL closeBtnClicked;
    
}
-(void)setUp;
-(void)setSearchDict:(NSDictionary *)dict;
-(void)setSearchType:(int)searchType;
-(void)setTarget:(id)tReceived onClose:(SEL)func;

@end

@interface FullInfluencerCell : UICollectionViewCell
{
    
}
@property (nonatomic, strong) UILabel *firstNameLBL;
@property (nonatomic, strong) UILabel *profLBL;
@property (nonatomic, strong) UIImageHM *userImageView;
@property (nonatomic, strong) UIButton *friendshipBtn;

@end




//TODO
/*
 
 1. OnClick event for profile and post
 2. New Influcencers cell inline
 3. Friendship add event
 */
