//
//  EditSCTagListControl.h
//  MeanWiseUX
//
//  Created by Hardik on 29/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionViewLeftAlignedLayout.h"

@interface EditSCTagListControl : UIView <UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *userTagList;
    
    UICollectionView *tagListCV;
}
-(void)setUp:(NSMutableArray *)array;
-(void)addNewTag:(NSString *)string;
-(NSArray *)getCurrentTagList;
@end


@interface EditSCTagLabelCell : UICollectionViewCell
{
    UILabel *tagLabel;
    NSString *tagName;
    
    UIButton *removeTagBtn;
    
    id target;
    SEL onRemoveTagBtnClick;
}
-(void)setUp:(NSString *)str target:(id)targetReceived OnDelete:(SEL)func;

@end
