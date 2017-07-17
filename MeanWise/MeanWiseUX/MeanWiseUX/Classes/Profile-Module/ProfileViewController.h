//
//  ViewController.h
//  MeanWiseUX
//
//  Created by Hardik on 15/08/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Constant.h"

//ModelView
//CoverView
//BioView
//VideoView
//PortfolioView
//PortfolioItemView
//BioItemView





@interface ModelView : UIView
- (UIViewController *)viewController;
@end


@interface CoverView : ModelView
{
    UILabel *bioTitle,*connectionCount,*connectionLabel,*profileViewCount,*profileLabel;
    UIButton *closeBtn;
    UIButton *downBtn;
    UIButton *addBtn;
    UIImageView *imageView;
    
}
-(void)setUpUIComponents;
-(void)IntroAnimationStateStart;
-(void)IntroAnimationStateEnd;
-(void)IntroAnimation;      
-(void)updateScollerWithDelta:(CGFloat)delta;

@end

@interface BioView : ModelView
{
    UIImageView *imageView;

    UIScrollView *scrollView;
    UIButton *closeBtn,*downBtn;
    
    NSMutableArray *dataArray;
    
}
-(void)setUpUIComponents;
-(void)IntroAnimationStateStart;
-(void)IntroAnimationStateEnd;
-(void)IntroAnimation;
-(void)updateScollerWithDelta:(CGFloat)delta;

@end



@interface VideoView : ModelView
{
    AVPlayerViewController *controller;
    AVPlayer *player;
    UIButton *playBtn;
    UIButton *closeBtn,*downBtn;
}
-(void)setUpUIComponents;
-(void)IntroAnimation;
-(void)IntroAnimationStateStart;
-(void)IntroAnimationStateEnd;
-(void)updateScollerWithDelta:(CGFloat)delta;

@end

@interface PortfolioView : ModelView <UIScrollViewDelegate>
{
    UIButton *prevBtn,*closeBtn,*nextBtn,*likeBtn,*commentBtn,*shareBtn;
    UILabel *likeCount,*commentCount,*tagLabel,*timeLabel,*photoLabel;
    UIView *lineView;
    
    NSMutableArray *pagesArray;
    
    UIScrollView *scrollView;
    
    
}
-(void)setUpUIComponents;
-(void)IntroAnimation;
-(void)IntroAnimationStateStart;
-(void)IntroAnimationStateEnd;
-(void)updateScollerWithDelta:(CGFloat)delta;

@end

@interface PortfolioItemView : ModelView
{
    UIImageView *imageView;
}
-(void)setUpPortfolioItemViewWithPageNo:(int)number andMax:(int)max;
-(void)updateScollerWithDelta:(CGFloat)delta;

@end

@interface BioItemView : ModelView
{
    UIView *fullScreenPreview;
    NSDictionary *dataDict;
}
-(void)setUpUIComponents;
-(void)setUpData:(NSDictionary *)dictionary;

@end


@interface ProfileViewController : UIViewController <UIScrollViewDelegate>
{
    
    UIScrollView *scrollView;
    
    CoverView *coverView;
    BioView *bioView;
    VideoView *videoView;
    PortfolioView *portfolioView;
    int countSec;
    BOOL isInIntroMode;
    
    UIView *introBlockView;
    
}
-(void)scrollToBioView;
-(void)scrollToVideoView;
-(void)scrollToPortfolioView;

@end





