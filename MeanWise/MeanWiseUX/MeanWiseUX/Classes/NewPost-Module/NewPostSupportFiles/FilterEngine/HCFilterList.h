//
//  HCFilterList.h
//  Exacto
//
//  Created by Hardik on 19/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCFilterList : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *filterList;
    NSMutableArray *masterArray;
    
    id target;
    SEL filterSelectFunc;
    

}
-(void)setUp:(NSMutableArray *)masterFilter;
-(void)setTarget:(id)targetReceived OnFilterSelect:(SEL)func;

@end

@interface HCFilterCell : UICollectionViewCell
{
    int senderValue;
}
@property (nonatomic, strong) UILabel *nameLBL;

@end
