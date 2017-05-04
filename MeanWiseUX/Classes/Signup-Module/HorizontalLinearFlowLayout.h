//
//  HorizontalLinearFlowLayout.h
//  MeanWiseUX
//
//  Created by Mohamed Aas on 3/19/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizontalLinearFlowLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) BOOL noOffset;
@property (assign, nonatomic) CGFloat scalingOffset; //default is 200; for offsets >= scalingOffset scale factor is minimumScaleFactor
@property (assign, nonatomic) CGFloat minimumScaleFactor; //default is 0.7
@property (assign, nonatomic) BOOL scaleItems; //default is YES

+ (HorizontalLinearFlowLayout *)layoutConfiguredWithCollectionView:(UICollectionView *)collectionView
                                                            itemSize:(CGSize)itemSize
                                                  minimumLineSpacing:(CGFloat)minimumLineSpacing;
@end
