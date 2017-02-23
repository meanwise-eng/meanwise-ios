//
//  FeedCell.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import <AVKit/AVKit.h>
#import "VideoCacheManager.h"
#import "LoaderMin.h"

@interface FeedCell : UICollectionViewCell
{
    BOOL keepPlaying;
    NSString *videoURLString;
    int mediaType;
    UIView *hiddenView;
}
-(void)setUpMediaType:(int)mediaType andColorNumber:(int)Cnumber;

-(void)removeURL;
-(void)setURL:(NSString *)url;
-(void)setKeepPlaying:(BOOL)flag;
- (UIImage *)screenshotOfVideo;
-(void)setHiddenCustom:(BOOL)flag;



@property (nonatomic, strong) UIImageView *shadowImage;

@property (nonatomic, strong) UILabel *statusLBL;
@property (nonatomic, strong) UIImageView *postIMGVIEW;

@property (nonatomic, strong) UIImageView *profileIMGVIEW;

@property (nonatomic, strong) UILabel *nameLBL;
@property (nonatomic, strong) UILabel *profLBL;


@property (nonatomic, strong) UILabel *tagName;
@property (nonatomic, strong) UILabel *timeLBL;


@property (nonatomic, strong) UILabel *likeCountLBL;
@property (nonatomic, strong) UILabel *commentCountLBL;

@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) AVPlayerViewController *playerViewController;
@property (nonatomic, strong) LoaderMin *videoLoader;


-(void)setFrameX:(CGRect)frame;

@end
