//
//  PostMiniCell.h
//  MeanWiseUX
//
//  Created by Hardik on 04/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageHM.h"

@interface PostMiniCell : UICollectionViewCell
{
    
}
@property (nonatomic, strong) UIImageHM *postImageV;
@property (nonatomic, strong) UILabel *statusText;

-(void)setUpPostImageURL:(NSString *)urlStr andText:(NSString *)string;


@end
