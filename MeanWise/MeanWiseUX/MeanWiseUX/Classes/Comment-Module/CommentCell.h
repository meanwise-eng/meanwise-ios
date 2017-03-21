//
//  CommentCell.h
//  MeanWiseUX
//
//  Created by Hardik on 12/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "UIImageHM.h"


@interface CommentCell : UICollectionViewCell
{
    
    id target;
    SEL commentDeleteFunc;
    
}
@property (nonatomic, strong) NSString *commentId;

@property (nonatomic, strong) UIView *separatorView;

@property (nonatomic, strong) UIImageHM *profileIMGVIEW;
@property (nonatomic, strong) UILabel *timeLBL;

@property (nonatomic, strong) UILabel *nameLBL;
@property (nonatomic, strong) UILabel *personNameLBL;
@property (nonatomic, strong) UIButton *customDeleteBtn;

-(void)setNameLBLText:(NSString *)string;
-(void)setProfileImageURLString:(NSString *)stringPath;
-(void)setTarget:(id)targetReceived andOnDelete:(SEL)deleteFunc;

@end