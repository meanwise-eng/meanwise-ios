//
//  ChatLineCell.h
//  MeanWiseUX
//
//  Created by Hardik on 12/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@interface ChatLineCell : UICollectionViewCell
{
    
    int senderValue;
}
@property (nonatomic, strong) UIView *shadowView;

@property (nonatomic, strong) UIImageView *profileIMGVIEW;

@property (nonatomic, strong) UILabel *nameLBL;
@property (nonatomic, strong) UILabel *timeLBL;


-(void)setNameLBLText:(NSString *)string;
-(void)setSenderValue:(int)Number;

@end
