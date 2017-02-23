//
//  ProfileComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 28/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomGestureView.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <QuartzCore/QuartzCore.h>

#import "Constant.h"


@interface Profile_ModelView : UIView
- (UIViewController *)viewController;
@end


@interface Profile_CoverView : Profile_ModelView
{
    UILabel *bioTitle,*connectionCount,*connectionLabel,*profileViewCount,*profileLabel;
    UIButton *closeBtn;
    UIButton *downBtn;
    UIButton *addBtn;
    UIImageView *imageView;
    
    id delegate;
    SEL closeProfileFunc;
    

    
}
-(void)setTarget:(id)target andCloseProfile:(SEL)func;

-(void)setCoverPhoto:(NSString *)string andTitle:(NSString *)title;

-(void)setUpUIComponents;
-(void)IntroAnimationStateStart;
-(void)IntroAnimationStateEnd;
-(void)IntroAnimation;
-(void)updateScollerWithDelta:(CGFloat)delta;

@end

@interface Profile_BioView : Profile_ModelView
{
    UIImageView *imageView;
    
    UIScrollView *scrollView;
    UIButton *closeBtn,*downBtn;
    
    NSMutableArray *dataArray;
    
    id delegate;
    SEL closeProfileFunc;

    
}
-(void)setTarget:(id)target andCloseProfile:(SEL)func;

-(void)setUpUIComponents;
-(void)IntroAnimationStateStart;
-(void)IntroAnimationStateEnd;
-(void)IntroAnimation;
-(void)updateScollerWithDelta:(CGFloat)delta;

@end



@interface Profile_VideoView : Profile_ModelView
{
    AVPlayerViewController *controller;
    AVPlayer *player;
    UIButton *playBtn;
    UIButton *closeBtn,*downBtn;
    
    
    id delegate;
    SEL closeProfileFunc;

}
-(void)setTarget:(id)target andCloseProfile:(SEL)func;

-(void)setUpUIComponents;
-(void)IntroAnimation;
-(void)IntroAnimationStateStart;
-(void)IntroAnimationStateEnd;
-(void)updateScollerWithDelta:(CGFloat)delta;

@end

@interface Profile_PortfolioView : Profile_ModelView <UIScrollViewDelegate>
{
    UIButton *prevBtn,*closeBtn,*nextBtn,*likeBtn,*commentBtn,*shareBtn;
    UILabel *likeCount,*commentCount,*tagLabel,*timeLabel,*photoLabel;
    UIView *lineView;
    
    NSMutableArray *pagesArray;
    
    UIScrollView *scrollView;
    
    id delegate;
    SEL closeProfileFunc;

    
}
-(void)setTarget:(id)target andCloseProfile:(SEL)func;

-(void)setUpUIComponents;
-(void)IntroAnimation;
-(void)IntroAnimationStateStart;
-(void)IntroAnimationStateEnd;
-(void)updateScollerWithDelta:(CGFloat)delta;

@end

@interface Profile_PortfolioItemView : Profile_ModelView
{
    UIImageView *imageView;
    

    
}

-(void)setUpPortfolioItemViewWithPageNo:(int)number andMax:(int)max;
-(void)updateScollerWithDelta:(CGFloat)delta;

@end

@interface Profile_BioItemView : Profile_ModelView
{
    UIView *fullScreenPreview;
    NSDictionary *dataDict;
}
-(void)setUpUIComponents;
-(void)setUpData:(NSDictionary *)dictionary;

@end


@interface ProfileComponent : ZoomGestureView  <UIScrollViewDelegate>
{
    UIImageView *postIMGVIEW;
   
    
    UIScrollView *scrollView;
    Profile_CoverView *coverView;
    Profile_BioView *bioView;
    Profile_VideoView *videoView;
    Profile_PortfolioView *portfolioView;
    int countSec;
    BOOL isInIntroMode;
    UIView *introBlockView;
    
    id delegate;
    SEL closeSelector;
    
    
}


-(void)setUpWithCellRect:(CGRect)rect;
-(void)setImage:(NSString *)string andNumber:(NSIndexPath *)indexPath;
-(void)setTarget:(id)target andFunc1:(SEL)func1;


-(void)scrollToBioView;
-(void)scrollToVideoView;
-(void)scrollToPortfolioView;

-(void)dismissThisController;

@end
