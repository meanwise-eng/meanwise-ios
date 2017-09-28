//
//  ProfileWindowFeedFilterControl.h
//  MeanWiseUX
//
//  Created by Hardik on 09/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterItemCell : UICollectionViewCell
{
    
}
@property (nonatomic, strong) UILabel *titleLBL;

@end

@interface ProfileWindowFeedFilterControl : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *filterCV;

    NSMutableArray *filterData;
    
    id target;
    SEL onfilterSelectEvent;

}

-(void)setFilterData:(NSMutableArray *)array;
-(void)setTarget:(id)targetReceived onfilterSelect:(SEL)func;
-(void)setUp;

@end
