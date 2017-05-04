//
//  PhotoAlbumCCell.h
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import <Photos/Photos.h>


@interface PhotoAlbumCCell : UICollectionViewCell
{
    PHAsset *asset;
}
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *duration;

-(void)setAsset:(PHAsset *)assetReceived;

@end
