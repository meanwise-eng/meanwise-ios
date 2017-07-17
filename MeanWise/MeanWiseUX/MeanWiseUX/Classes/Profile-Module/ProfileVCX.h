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


@interface ModelView : UIView
- (UIViewController *)viewController;
@end


@interface CoverView : ModelView
{
    UILabel *bioTitle,*connectionCount,*connectionLabel,*profileViewCount,*profileLabel;
    UIButton *closeBtn;
    UIButton *downBtn;
    UIButton *addBtn;
    
}
-(void)setUpUIComponents;       //setUpUIComponents
-(void)IntroAnimationStateStart;  //IntroAnimationStateStart
-(void)IntroAnimationStateEnd;    //IntroAnimationStateEnd
-(void)IntroAnimation;       //IntroAnimation


@end

@interface BioView : ModelView
{
    UIScrollView *scrollView;
    UIButton *closeBtn,*downBtn;
    
    NSMutableArray *dataArray;

}
-(void)setUpUIComponents;
-(void)IntroAnimationStateStart; ////IntroAnimationStateStart
-(void)IntroAnimationStateEnd;
-(void)IntroAnimation;

@end



@interface VideoView : ModelView
{
    AVPlayer *player;
    UIButton *playBtn;
    UIButton *closeBtn,*downBtn;
}
-(void)setUpUIComponents;
-(void)IntroAnimation;
-(void)IntroAnimationStateStart;
-(void)IntroAnimationStateEnd;
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
@end

@interface PortfolioItemView : ModelView
-(void)setUpPortfolioItemViewWithPageNo:(int)number andMax:(int)max;

@end

@interface BioItemView : ModelView
{
    UIView *fullScreenPreview;
    NSDictionary *dataDict;
}
-(void)setUpUIComponents;
-(void)setUpData:(NSDictionary *)dictionary;

@end


@interface ProfileVC : UIViewController <UIScrollViewDelegate>
{
    
    UIScrollView *scrollView;
    
    CoverView *view1;
    BioView *view2;
    VideoView *view4;
    PortfolioView *view5;
    int countSec;
    BOOL isInIntroMode;
    
    UIView *introBlockView;
    
}
-(void)scrollToBioView;
-(void)scrollToVideoView;
-(void)scrollToPortfolioView;

@end





