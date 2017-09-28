//
//  spLayout.h
//  MeanWiseRedesignHelper
//
//  Created by Hardik on 04/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMMagLayout : UICollectionViewLayout
{


    CGSize sizeMaxSize;
    NSMutableArray *allRect;
    
}
-(id)initWithSize:(CGSize)size;
@property (nonatomic, strong) NSMutableDictionary *cellLayouts;
@property (nonatomic, assign) CGSize              unitSize;

@end
