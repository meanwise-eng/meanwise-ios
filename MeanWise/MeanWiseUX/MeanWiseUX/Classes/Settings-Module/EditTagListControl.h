//
//  EditTagListControl.h
//  MeanWiseUX
//
//  Created by Hardik on 29/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTagListControl : UIView <UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *userTagList;
    
    UICollectionView *tagListCV;
}
-(void)setUp:(NSMutableArray *)array;
-(void)addNewTag:(NSDictionary *)dict;
-(NSArray *)getCurrentTagList;
@end


@interface EditTagLabelCell : UICollectionViewCell
{
    UILabel *tagLabel;
    NSDictionary *tagInfo;
    
    UIButton *removeTagBtn;
    
    id target;
    SEL onRemoveTagBtnClick;
}
-(void)setUp:(NSDictionary *)dict target:(id)targetReceived OnDelete:(SEL)func;

@end

@interface UICollectionViewLeftAlignedLayout : UICollectionViewFlowLayout

@end

/**
 *  Just a convenience protocol to keep things consistent.
 *  Someone could find it confusing for a delegate object to conform to UICollectionViewDelegateFlowLayout
 *  while using UICollectionViewLeftAlignedLayout.
 */
@protocol UICollectionViewDelegateLeftAlignedLayout <UICollectionViewDelegateFlowLayout>

@end