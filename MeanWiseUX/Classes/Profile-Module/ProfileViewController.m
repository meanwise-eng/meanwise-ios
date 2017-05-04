//
//  ViewController.m
//  MeanWiseUX
//
//  Created by Hardik on 15/08/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "ProfileViewController.h"
#import "CGGeometryExtended.h"



@interface ProfileViewController ()

@end

@implementation ProfileViewController

#pragma mark - Main Controller
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    [self setNeedsStatusBarAppearanceUpdate];
    
    scrollView=[[UIScrollView alloc] initWithFrame:CGXRectMake(0, 0, CGX_ScreenMaxWidth(), CGX_ScreenMaxHeight())];
    [self.view addSubview:scrollView];
    
    
    
    scrollView.contentSize=CGXSizeMake(CGX_ScreenMaxWidth(), CGX_ScreenMaxHeight()*4);
    scrollView.backgroundColor=[UIColor blackColor];
    
    scrollView.showsHorizontalScrollIndicator=false;
    scrollView.showsVerticalScrollIndicator=false;
    
    
    coverView=[[CoverView alloc] initWithFrame:CGXRectMake(0, CGX_ScreenMaxHeight()*0, CGX_ScreenMaxWidth(), CGX_ScreenMaxHeight())];
    [scrollView addSubview:coverView];
    [coverView setUpUIComponents];
    
    
    
    bioView=[[BioView alloc] initWithFrame:CGXRectMake(0, CGX_ScreenMaxHeight(), CGX_ScreenMaxWidth(), CGX_ScreenMaxHeight())];
    [scrollView addSubview:bioView];
    [bioView setUpUIComponents];
    
    
    videoView=[[VideoView alloc] initWithFrame:CGXRectMake(0, CGX_ScreenMaxHeight()*2, CGX_ScreenMaxWidth(), CGX_ScreenMaxHeight())];
    [scrollView addSubview:videoView];
    [videoView setUpUIComponents];
    
    portfolioView=[[PortfolioView alloc] initWithFrame:CGXRectMake(0, CGX_ScreenMaxHeight()*3, CGX_ScreenMaxWidth(), CGX_ScreenMaxHeight())];
    [scrollView addSubview:portfolioView];
    [portfolioView setUpUIComponents];
    
    
    self.view.userInteractionEnabled=true;
    
    scrollView.pagingEnabled=true;
    scrollView.minimumZoomScale=1;
    scrollView.maximumZoomScale=1;
    scrollView.delegate=self;
    
    scrollView.alwaysBounceHorizontal=false;
    scrollView.alwaysBounceVertical=false;
    
    [coverView IntroAnimationStateStart];
    [bioView IntroAnimationStateStart];
    [videoView IntroAnimationStateStart];
    [portfolioView IntroAnimationStateStart];
    
    
    introBlockView=[[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:introBlockView];
    
    
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(IntroStop)];
    [introBlockView addGestureRecognizer:tapGestureRecognizer];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    isInIntroMode=true;
    countSec=0;
    
    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(autoPlayLoop:) userInfo:nil repeats:YES];
    
    [coverView IntroAnimation];
    
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView1
{
    CGFloat pageWidth = scrollView1.frame.size.height;
    CGFloat scrollY=scrollView1.contentOffset.y;
    CGFloat screenHeight=CGX_DeviceMaxHeight();
    CGFloat deltaY=scrollY/screenHeight;
    
    //portfolioView.transform=CGAffineTransformMakeScale(4-ePara, 4-ePara);
   // coverView.transform=CGAffineTransformMakeRotation(-ePara);

    [coverView updateScollerWithDelta:deltaY];
    [videoView updateScollerWithDelta:deltaY];
    [portfolioView updateScollerWithDelta:deltaY];
    [bioView updateScollerWithDelta:deltaY];
    
    NSLog(@"%f",deltaY);
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1
{
        CGFloat pageWidth = scrollView1.frame.size.height;
    
    
       int page = floor((scrollView1.contentOffset.y - CGX_ScreenMaxHeight()/ 2) / pageWidth) + 1;
    
    CGFloat scrollY=scrollView1.contentOffset.y;
    CGFloat screenHeight=CGX_DeviceMaxHeight();
    
    

    CGFloat ePara=scrollY/screenHeight;
    
    NSLog(@"%f",ePara);

    
    //
    //    if(page==1)
    //    {
    //        [view2 IntroAnimation];
    //
    //    }
    //    else if(page==2)
    //    {
    //        [view4 IntroAnimation];
    //
    //    }
    //    else if (page==3)
    //    {
    //        [view5 IntroAnimation];
    //
    //    }
    //    NSLog(@"%d",page);
}

#pragma mark scrollView delegate
-(void)scrollToBioView
{
    
    
    [scrollView scrollRectToVisible:CGXRectMake(0, CGX_ScreenMaxHeight(), CGX_ScreenMaxWidth(), CGX_ScreenMaxHeight()) animated:YES];
    
}
-(void)scrollToVideoView
{
    [scrollView scrollRectToVisible:CGXRectMake(0, CGX_ScreenMaxHeight()*2, CGX_ScreenMaxWidth(), CGX_ScreenMaxHeight()) animated:YES];
    
}
-(void)scrollToPortfolioView
{
    [scrollView scrollRectToVisible:CGXRectMake(0, CGX_ScreenMaxHeight()*3, CGX_ScreenMaxWidth(), CGX_ScreenMaxHeight()) animated:YES];
    
}
-(void)dismissThisController
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}
-(void)IntroStop
{
    if(isInIntroMode==true)
    {
        // [self IntroStop];
        
        [introBlockView setHidden:YES];
        
        isInIntroMode=false;
        [coverView IntroAnimationStateEnd];
        [bioView IntroAnimationStateEnd];
        [videoView IntroAnimationStateEnd];
        [portfolioView IntroAnimationStateEnd];
        
    }
    
}
-(void)autoPlayLoop:(id)sender
{
    if(isInIntroMode==true)
    {
        countSec++;
        
        if(countSec==2)
        {
            
            
            [UIView animateWithDuration:1.0 delay:4 options:UIViewAnimationOptionCurveLinear animations:^{
                
                [scrollView scrollRectToVisible:CGXRectMake(0, CGX_ScreenMaxHeight(), CGX_ScreenMaxWidth(), CGX_ScreenMaxHeight()) animated:false];
                
            } completion:^(BOOL finished) {
                
                [bioView IntroAnimation];
                
            }];
            
            
        }
        if(countSec==8)
        {
            
            [UIView animateWithDuration:1.0 delay:4 options:UIViewAnimationOptionCurveLinear animations:^{
                
                [scrollView scrollRectToVisible:CGXRectMake(0, CGX_ScreenMaxHeight()*2, CGX_ScreenMaxWidth(), CGX_ScreenMaxHeight()) animated:false];
                
            } completion:^(BOOL finished) {
                
                [videoView IntroAnimation];
                
            }];
            
        }
        if(countSec==13)
        {
            
            [UIView animateWithDuration:1.0 delay:4 options:UIViewAnimationOptionCurveLinear animations:^{
                
                [scrollView scrollRectToVisible:CGXRectMake(0, CGX_ScreenMaxHeight()*3, CGX_ScreenMaxWidth(), CGX_ScreenMaxHeight()) animated:false];
                
            } completion:^(BOOL finished) {
                
                [videoView IntroAnimationStateEnd];
                
                [portfolioView IntroAnimation];
                
                [self IntroStop];
            }];
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

#pragma mark - Model View
@implementation ModelView

- (UIViewController *)viewController {
    UIResponder *responder = self;
    while (![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
        if (nil == responder) {
            break;
        }
    }
    return (UIViewController *)responder;
}


@end

#pragma mark - Cover View

@implementation CoverView

-(void)setUpUIComponents
{
    
    self.clipsToBounds=YES;
    imageView=[[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:imageView];
    imageView.image=[UIImage imageNamed:@"CoverPhoto.jpg"];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    
    UIImageView *shadow1=[[UIImageView alloc] initWithFrame:CGXRectMake(0, CGX_ScreenMaxHeight()/2,CGX_ScreenMaxWidth(),CGX_ScreenMaxHeight()/2)];
    [self addSubview:shadow1];
    shadow1.image=[UIImage imageNamed:@"BlackShadow.png"];
    shadow1.contentMode=UIViewContentModeScaleToFill;
    shadow1.alpha=0.8;
    
    bioTitle=[[UILabel alloc] initWithFrame:CGXRectMake(40, CGX_ScreenMaxHeight()/2-50, CGX_ScreenMaxWidth()-80, 180)];
    [self addSubview:bioTitle];
    bioTitle.textColor=[UIColor whiteColor];
    bioTitle.textAlignment=NSTextAlignmentLeft;
    bioTitle.text=@"Hey,\nI'm Sally";
    bioTitle.numberOfLines=2;
    bioTitle.adjustsFontSizeToFitWidth=YES;
    bioTitle.font=[UIFont fontWithName:k_fontBold size:90];
    
    connectionCount=[[UILabel alloc] initWithFrame:CGXRectMake(0, 0, 100, 20)];
    connectionCount.textColor=[UIColor whiteColor];
    connectionCount.textAlignment=NSTextAlignmentCenter;
    connectionCount.text=@"50K";
    [self addSubview:connectionCount];
    connectionCount.font=[UIFont fontWithName:k_fontBold size:14];
    
    connectionLabel=[[UILabel alloc] initWithFrame:CGXRectMake(0, 0, 100, 20)];
    connectionLabel.textColor=[UIColor whiteColor];
    connectionLabel.textAlignment=NSTextAlignmentCenter;
    connectionLabel.text=@"connections";
    [self addSubview:connectionLabel];
    connectionLabel.font=[UIFont fontWithName:k_fontSemiBold size:12];
    
    profileViewCount=[[UILabel alloc] initWithFrame:CGXRectMake(0, 0, 100, 20)];
    profileViewCount.textColor=[UIColor whiteColor];
    profileViewCount.textAlignment=NSTextAlignmentCenter;
    profileViewCount.text=@"750K";
    [self addSubview:profileViewCount];
    profileViewCount.font=[UIFont fontWithName:k_fontBold size:14];
    
    profileLabel=[[UILabel alloc] initWithFrame:CGXRectMake(0, 0, 100, 20)];
    profileLabel.textColor=[UIColor whiteColor];
    profileLabel.textAlignment=NSTextAlignmentCenter;
    profileLabel.text=@"profile views";
    [self addSubview:profileLabel];
    profileLabel.font=[UIFont fontWithName:k_fontSemiBold size:12];
    
    closeBtn=[[UIButton alloc] initWithFrame:CGXRectMake(0, 0, 45, 45)];
    [self addSubview:closeBtn];
    closeBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, CGX_ScreenMaxHeight()-50);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
    closeBtn.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.1];
    closeBtn.layer.cornerRadius=45/2*CGX_scaleFactor();
    closeBtn.clipsToBounds=YES;
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    downBtn=[[UIButton alloc] initWithFrame:CGXRectMake(0, 0, 45, 45)];
    [self addSubview:downBtn];
    downBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-25, CGX_ScreenMaxHeight()-35);
    
    [downBtn setBackgroundImage:[UIImage imageNamed:@"Arrow_down.png"] forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(downBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    addBtn=[[UIButton alloc] initWithFrame:CGXRectMake(CGX_ScreenMaxWidth()-25, 25, 45, 45)];
    [self addSubview:addBtn];
    addBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-40, 58);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"addBtn.png"] forState:UIControlStateNormal];
    
    
    // bioTitle.backgroundColor=[UIColor blueColor];
    // profileLabel.backgroundColor=[UIColor yellowColor];
    // connectionLabel.backgroundColor=[UIColor yellowColor];
    // connectionCount.backgroundColor=[UIColor purpleColor];
    // profileViewCount.backgroundColor=[UIColor purpleColor];
    // closeBtn.backgroundColor=[UIColor blueColor];
    // downBtn.backgroundColor=[UIColor blueColor];
    
    
}
-(void)IntroAnimationStateStart
{
    bioTitle.alpha=0;
    connectionCount.alpha=0;
    connectionLabel.alpha=0;
    profileViewCount.alpha=0;
    profileLabel.alpha=0;
    
    downBtn.alpha=0;
    closeBtn.alpha=0;
    addBtn.alpha=0;
    
    bioTitle.frame=CGXRectMake(22, CGX_ScreenMaxHeight()/2+200, (CGX_ScreenMaxWidth()-44)*0.65, 115);
    
    downBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-25, CGX_ScreenMaxHeight()-35+200);
    closeBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, CGX_ScreenMaxHeight()-35+200);
    
    connectionCount.center=CGXPointMake(CGX_ScreenMaxWidth()/2-85, CGX_ScreenMaxHeight()-95);
    connectionLabel.center=CGXPointMake(CGX_ScreenMaxWidth()/2-85, CGX_ScreenMaxHeight()-80);
    profileViewCount.center=CGXPointMake(CGX_ScreenMaxWidth()/2+85, CGX_ScreenMaxHeight()-95);
    profileLabel.center=CGXPointMake(CGX_ScreenMaxWidth()/2+85, CGX_ScreenMaxHeight()-80);
    
    addBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-40, 58-200);
    
    
}
-(void)IntroAnimationStateEnd
{
    
    
    bioTitle.frame=CGXRectMake(22, CGX_ScreenMaxHeight()/2-0, (CGX_ScreenMaxWidth()-44)*0.65, 115);
    connectionCount.center=CGXPointMake(CGX_ScreenMaxWidth()/2-85, CGX_ScreenMaxHeight()-95);
    connectionLabel.center=CGXPointMake(CGX_ScreenMaxWidth()/2-85, CGX_ScreenMaxHeight()-80);
    profileViewCount.center=CGXPointMake(CGX_ScreenMaxWidth()/2+85, CGX_ScreenMaxHeight()-95);
    profileLabel.center=CGXPointMake(CGX_ScreenMaxWidth()/2+85, CGX_ScreenMaxHeight()-80);
    
    addBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-40, 58);
    
    
    
    downBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-25, CGX_ScreenMaxHeight()-35);
    closeBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, CGX_ScreenMaxHeight()-35);
    
    downBtn.alpha=1;
    closeBtn.alpha=1;
    bioTitle.alpha=1;
    addBtn.alpha=1;
    
    connectionCount.alpha=1;
    connectionLabel.alpha=1;
    profileViewCount.alpha=1;
    profileLabel.alpha=1;
    
    
}
-(void)IntroAnimation
{
    
    
    [UIView animateWithDuration:1.0 animations:^{
        
        bioTitle.frame=CGXRectMake(22, CGX_ScreenMaxHeight()/2-0, (CGX_ScreenMaxWidth()-44)*0.65, 115);
        bioTitle.alpha=1;
        
    }];
    
    
    [UIView animateWithDuration:1.0f delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        connectionCount.center=CGXPointMake(CGX_ScreenMaxWidth()/2-85, CGX_ScreenMaxHeight()-95);
        connectionLabel.center=CGXPointMake(CGX_ScreenMaxWidth()/2-85, CGX_ScreenMaxHeight()-80);
        profileViewCount.center=CGXPointMake(CGX_ScreenMaxWidth()/2+85, CGX_ScreenMaxHeight()-95);
        profileLabel.center=CGXPointMake(CGX_ScreenMaxWidth()/2+85, CGX_ScreenMaxHeight()-80);
        
        connectionCount.alpha=1;
        connectionLabel.alpha=1;
        profileViewCount.alpha=1;
        profileLabel.alpha=1;
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    [UIView animateWithDuration:1.0f delay:1.5 options:UIViewAnimationOptionCurveLinear animations:^{
        
        downBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-25, CGX_ScreenMaxHeight()-35);
        closeBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, CGX_ScreenMaxHeight()-35);
        
        downBtn.alpha=1;
        closeBtn.alpha=1;
        
        addBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-40, 58);
        addBtn.alpha=1;
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    
    
    
    
    
    
}
-(void)updateScollerWithDelta:(CGFloat)delta;
{

  //  imageView.transform=CGAffineTransformMakeScale(1+delta, 1+delta);
    
    CGAffineTransform t=CGAffineTransformMakeScale(1.1f, 1.1f);
    CGAffineTransform n=CGAffineTransformMakeTranslation(0, 300*delta);
    
    imageView.transform=CGAffineTransformConcat(t, n);
    
    
    
}
-(void)downBtnClicked:(id)sender
{
    ProfileViewController *vc=(ProfileViewController *)[self viewController];
    [vc scrollToBioView];
    
}
-(void)closeBtnClicked:(id)sender
{
    
    ProfileViewController *vc=(ProfileViewController *)[self viewController];
    [vc dismissViewControllerAnimated:YES completion:nil];
    
}

@end

#pragma mark - Bio View

@implementation BioView


-(void)setUpUIComponents
{
    
    imageView=[[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:imageView];
    imageView.image=[UIImage imageNamed:@"Portfolio3.jpeg"];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    imageView.alpha=0.1;

    
    self.clipsToBounds=YES;
    
    dataArray=[[NSMutableArray alloc] init];
    
    NSDictionary *dict1=@{@"title":@"Explaining All Of U.S. Energy Use With A Genius Chart And Cheeseburgers",@"desc":@"Saul Griffith really, really likes to quantify things about energy and carbon. You can watch the MacArthur genius award winner and entrepreneur soberly dissect his formerly unsustainable lifestyle in more detail than you ever thought possible here and here.",@"tags":@"#tesla #Electric Car #Energy #charts"};
    
    NSDictionary *dict2=@{@"title":@"Saul Griffith really, really likes to quantify things about energy and carbon.",@"desc":@"Before 9:00 a.m. on a Tuesday morning in August, APEX Gymnastics in Leesburg, Virginia, is already filled with dozens of budding gymnasts. The three-year-olds, dressed in leotards still too big for them and with ponytails that won’t stay up, bounce on the trampoline, while the intermediate-level girls laugh amongst themselves as they put chalk on their hands and prepare to tackle the daunting uneven bars or four-inch balance beams.",@"tags":@"#sports #women #tesla #general"};
    
    NSDictionary *dict3=@{@"title":@"When one girl has to drop, I feel a lot of anguish,” she said. “I also feel a lot for the parents.",@"desc":@"Welch, who coached the “immensely talented” Sara at APEX, said seeing girls leave is particularly heartbreaking because gymnastics is more than just a sport — it’s a social outlet and a second family for many of them. Plus, it was tough to see one of the few non-white families at the gym forced to walk away because of time and money.",@"tags":@"#sports #olympics #race #features #video"};
    
    [dataArray addObject:dict1];
    [dataArray addObject:dict2];
    [dataArray addObject:dict3];
    
    
    
    self.backgroundColor=[UIColor colorWithRed:229/255.0f green:58/255.0f blue:63/255.0f alpha:1.0f];
  //  self.backgroundColor=[UIColor blackColor];
    scrollView=[[UIScrollView alloc] initWithFrame:CGXRectMake(0, 0, CGX_ScreenMaxWidth(), CGX_ScreenMaxHeight())];
    [self addSubview:scrollView];
    scrollView.contentSize=CGXSizeMake(CGX_ScreenMaxWidth()*3, CGX_ScreenMaxHeight());
    scrollView.showsHorizontalScrollIndicator=false;
    scrollView.showsVerticalScrollIndicator=false;
    scrollView.pagingEnabled=YES;
    
    for(int i=0;i<[dataArray count];i++)
    {
        BioItemView *view=[[BioItemView alloc] initWithFrame:CGXRectMake(CGX_ScreenMaxWidth()*i, 0, CGX_ScreenMaxWidth(), CGX_ScreenMaxHeight())];
        [scrollView addSubview:view];
        [view setUpData:[dataArray objectAtIndex:i]];
        [view setUpUIComponents];
    }
    
    
    closeBtn=[[UIButton alloc] initWithFrame:CGXRectMake(0, 0, 45, 45)];
    [self addSubview:closeBtn];
    closeBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, CGX_ScreenMaxHeight()-35);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
    closeBtn.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.1];
    closeBtn.layer.cornerRadius=45/2*CGX_scaleFactor();
    closeBtn.clipsToBounds=YES;
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    downBtn=[[UIButton alloc] initWithFrame:CGXRectMake(0, 0, 50, 50)];
    [self addSubview:downBtn];
    downBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-25, CGX_ScreenMaxHeight()-35);
    [downBtn setBackgroundImage:[UIImage imageNamed:@"Arrow_down.png"] forState:UIControlStateNormal];
    
    [downBtn addTarget:self action:@selector(downBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)closeBtnClicked:(id)sender
{
    ProfileViewController *vc=(ProfileViewController *)[self viewController];
    [vc dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)downBtnClicked:(id)sender
{
    ProfileViewController *vc=(ProfileViewController *)[self viewController];
    [vc scrollToVideoView];
    
}
-(void)updateScollerWithDelta:(CGFloat)delta;
{
  
    CGAffineTransform t=CGAffineTransformMakeScale(1.1f, 1.1f);
    CGAffineTransform n=CGAffineTransformMakeTranslation(0, 300*(-1+delta));
    imageView.transform=CGAffineTransformConcat(t, n);
   
}
-(void)IntroAnimationStateStart
{
    scrollView.alpha=0;
    
    downBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-25, CGX_ScreenMaxHeight()-35+200);
    closeBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, CGX_ScreenMaxHeight()-35+200);
    
    downBtn.alpha=0;
    closeBtn.alpha=0;
}
-(void)IntroAnimationStateEnd
{
    scrollView.alpha=1;
    
    downBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-25, CGX_ScreenMaxHeight()-35);
    closeBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, CGX_ScreenMaxHeight()-35);
    
    downBtn.alpha=1;
    closeBtn.alpha=1;
    
}
-(void)IntroAnimation
{
    [UIView animateWithDuration:0.0 animations:^{
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.0f animations:^{
            
            [self IntroAnimationStateEnd];
            
        }];
        
        
    }];
    
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        downBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-25, CGX_ScreenMaxHeight()-35);
        closeBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, CGX_ScreenMaxHeight()-35);
        
        downBtn.alpha=1;
        closeBtn.alpha=1;
        
        
    } completion:^(BOOL finished) {
        
    }];
    
}
@end


#pragma mark - Video View

@implementation VideoView

-(void)IntroAnimationStateStart
{
    
    downBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-25, CGX_ScreenMaxHeight()-35+200);
    closeBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, CGX_ScreenMaxHeight()-35+200);
    
    downBtn.alpha=0;
    closeBtn.alpha=0;
    
    
}
-(void)IntroAnimationStateEnd
{
    downBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-25, CGX_ScreenMaxHeight()-35);
    closeBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, CGX_ScreenMaxHeight()-35);
    
    downBtn.alpha=1;
    closeBtn.alpha=1;
    
    [player pause];
}
-(void)updateScollerWithDelta:(CGFloat)delta;
{
   /* if(delta>2)
    {
        NSLog(@"%f---->",3-delta);
    controller.view.transform=CGAffineTransformMakeScale(-1+delta, -1+delta);
        
    }
    else
    {
        controller.view.transform=CGAffineTransformMakeScale(3-(delta), 3-(delta));

    }*/
    
    CGAffineTransform t=CGAffineTransformMakeScale(1.5f, 1.5f);
    CGAffineTransform n=CGAffineTransformMakeTranslation(0, 300*(-2+delta));
    controller.view.transform=CGAffineTransformConcat(t, n);
//
//    
//    if(delta>2)
//    {
//    CGAffineTransform t=CGAffineTransformMakeScale(1.2f, 1.2f);
//    CGAffineTransform n=CGAffineTransformMakeTranslation(0, -300*(-1+delta));
//    controller.view.transform=CGAffineTransformConcat(t, n);
//    }
//    else
//    {
//        CGAffineTransform t=CGAffineTransformMakeScale(1.2f, 1.2f);
//        CGAffineTransform n=CGAffineTransformMakeTranslation(0, -300*(3-delta));
//        controller.view.transform=CGAffineTransformConcat(t, n);
//    }
}
-(void)IntroAnimation
{
    [player play];
    
    [UIView animateWithDuration:1.0 animations:^{
        
    } completion:^(BOOL finished) {
        
        
        
    }];
    
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        downBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-25, CGX_ScreenMaxHeight()-35);
        closeBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, CGX_ScreenMaxHeight()-35);
        
        downBtn.alpha=1;
        closeBtn.alpha=1;
        
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}
-(void)setUpUIComponents
{
    //self.backgroundColor=[UIColor colorWithRed:229/255.0f green:58/255.0f blue:63/255.0f alpha:1.0f];
    
    self.clipsToBounds=YES;
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"mag_app_reducedvid" withExtension:@"mp4"];
    
    // create an AVPlayer
    player = [AVPlayer playerWithURL:videoURL];
    
    // create a player view controller
    controller = [[AVPlayerViewController alloc]init];
    controller.player = player;
    [player prepareForInterfaceBuilder];
    [player addObserver:self forKeyPath:@"rate" options:0 context:nil];
    
    // show the view controller
    //[self addChildViewController:controller];
    [self addSubview:controller.view];
    controller.view.frame=self.bounds;
    controller.showsPlaybackControls=false;
    controller.videoGravity=AVLayerVideoGravityResizeAspectFill;
    
    
    
    UIImageView *shadow1=[[UIImageView alloc] initWithFrame:CGXRectMake(0, CGX_ScreenMaxHeight()/2,CGX_ScreenMaxWidth(),CGX_ScreenMaxHeight()/2)];
    [self addSubview:shadow1];
    shadow1.image=[UIImage imageNamed:@"BlackShadow.png"];
    shadow1.contentMode=UIViewContentModeScaleToFill;
    shadow1.alpha=0.8;
    
    
    
    
    
    
    playBtn=[[UIButton alloc] initWithFrame:CGXRectMake(0, 0, 80, 80)];
    [self addSubview:playBtn];
    playBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, CGX_ScreenMaxHeight()/2);
    [playBtn setBackgroundImage:[UIImage imageNamed:@"playBtn.png"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    closeBtn=[[UIButton alloc] initWithFrame:CGXRectMake(0, 0, 45, 45)];
    [self addSubview:closeBtn];
    closeBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, CGX_ScreenMaxHeight()-35);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
    closeBtn.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.1];
    closeBtn.layer.cornerRadius=45/2*CGX_scaleFactor();
    closeBtn.clipsToBounds=YES;
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    downBtn=[[UIButton alloc] initWithFrame:CGXRectMake(0, 0, 50, 50)];
    [self addSubview:downBtn];
    downBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-25, CGX_ScreenMaxHeight()-35);
    [downBtn setBackgroundImage:[UIImage imageNamed:@"Arrow_down.png"] forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(downBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)removeFromSuperview
{
    [player removeObserver:self forKeyPath:@"rate"];
    [super removeFromSuperview];
    
}
-(void)downBtnClicked:(id)sender
{
    ProfileViewController *vc=(ProfileViewController *)[self viewController];
    [vc scrollToPortfolioView];
    
}

-(void)closeBtnClicked:(id)sender
{
    ProfileViewController *vc=(ProfileViewController *)[self viewController];
    [vc dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"rate"])
    {
        if ([player rate]) {
            playBtn.hidden=true;
            
        }
        else {
            playBtn.hidden=false;
        }
    }
}

-(void)playBtnClicked:(id)sender
{
    playBtn.hidden=true;
    [player seekToTime:kCMTimeZero];
    [player play];
    
}

@end

#pragma mark - Portfolio View

@implementation PortfolioView


-(void)setUpUIComponents
{
    
    pagesArray=[[NSMutableArray alloc] init];
    
    
    scrollView=[[UIScrollView alloc] initWithFrame:CGXRectMake(0, 0, CGX_ScreenMaxWidth(), CGX_ScreenMaxHeight())];
    [self addSubview:scrollView];
    
    
    
    scrollView.contentSize=CGXSizeMake(CGX_ScreenMaxWidth()*3, CGX_ScreenMaxHeight());
    scrollView.backgroundColor=[UIColor blackColor];
    
    scrollView.showsHorizontalScrollIndicator=false;
    scrollView.showsVerticalScrollIndicator=false;
    
    

    self.clipsToBounds=YES;
    
    
    scrollView.pagingEnabled=YES;
    
    for(int i=0;i<3;i++)
    {
        PortfolioItemView *view=[[PortfolioItemView alloc] initWithFrame:CGXRectMake(CGX_ScreenMaxWidth()*i, 0, CGX_ScreenMaxWidth(), CGX_ScreenMaxHeight())];
        [scrollView addSubview:view];
        [view setUpPortfolioItemViewWithPageNo:i andMax:3];
        
        [pagesArray addObject:view];
    }
    
    
    
    
    
    prevBtn=[[UIButton alloc] initWithFrame:CGXRectMake(0, 0, 45, 45)];
    [self addSubview:prevBtn];
    [prevBtn setBackgroundImage:[UIImage imageNamed:@"Arrow_left.png"] forState:UIControlStateNormal];
    
    
    
    closeBtn=[[UIButton alloc] initWithFrame:CGXRectMake(0, 0, 45, 45)];
    [self addSubview:closeBtn];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
    closeBtn.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.1];
    closeBtn.layer.cornerRadius=45/2*CGX_scaleFactor();
    closeBtn.clipsToBounds=YES;
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    nextBtn=[[UIButton alloc] initWithFrame:CGXRectMake(0, 0, 45, 45)];
    [self addSubview:nextBtn];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"Arrow_right.png"] forState:UIControlStateNormal];
    
    
    
    
    
    
    
    lineView=[[UIView alloc] initWithFrame:CGXRectMake(12, CGX_ScreenMaxHeight()-69, CGX_ScreenMaxWidth()-24, 1)];
    [self addSubview:lineView];
    lineView.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.2];
    
    
    
    
    
    likeBtn=[[UIButton alloc] initWithFrame:CGXRectMake(12, CGX_ScreenMaxHeight()-112, 40, 40)];
    [self addSubview:likeBtn];
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
    
    
    
    
    
    commentBtn=[[UIButton alloc] initWithFrame:CGXRectMake(CGX_ScreenMaxWidth()/2-40/2, CGX_ScreenMaxHeight()-112, 40, 40)];
    [self addSubview:commentBtn];
    [commentBtn setBackgroundImage:[UIImage imageNamed:@"comments.png"] forState:UIControlStateNormal];
    
    shareBtn=[[UIButton alloc] initWithFrame:CGXRectMake(CGX_ScreenMaxWidth()-12-40, CGX_ScreenMaxHeight()-112, 40, 40)];
    [self addSubview:shareBtn];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    
    
    
    
    
    likeCount=[[UILabel alloc] initWithFrame:CGXRectMake(12, CGX_ScreenMaxHeight()-132, 40, 30)];
    likeCount.text=@"12";
    likeCount.textColor=[UIColor whiteColor];
    [self addSubview:likeCount];
    likeCount.textAlignment=NSTextAlignmentCenter;
    likeCount.font=[UIFont fontWithName:k_fontSemiBold size:14];
    
    commentCount=[[UILabel alloc] initWithFrame:CGXRectMake(CGX_ScreenMaxWidth()/2-20, CGX_ScreenMaxHeight()-132, 40, 30)];
    commentCount.text=@"5";
    commentCount.textColor=[UIColor whiteColor];
    [self addSubview:commentCount];
    commentCount.textAlignment=NSTextAlignmentCenter;
    commentCount.font=[UIFont fontWithName:k_fontSemiBold size:14];
    
    
    
    
    lineView.frame=CGXRectMake(12, CGX_ScreenMaxHeight()-69, CGX_ScreenMaxWidth()-24, 1);
    likeBtn.frame=CGXRectMake(12, CGX_ScreenMaxHeight()-112, 40, 40);
    commentBtn.frame=CGXRectMake(CGX_ScreenMaxWidth()/2-40/2, CGX_ScreenMaxHeight()-112, 40, 40);
    shareBtn.frame=CGXRectMake(CGX_ScreenMaxWidth()-12-40, CGX_ScreenMaxHeight()-112, 40, 40);
    commentCount.frame=CGXRectMake(CGX_ScreenMaxWidth()/2-20, CGX_ScreenMaxHeight()-132, 40, 30);
    likeCount.frame=CGXRectMake(12, CGX_ScreenMaxHeight()-132, 40, 30);
    
    
    
    
    tagLabel=[[UILabel alloc] initWithFrame:CGXRectMake(22, CGX_ScreenMaxHeight()-160, CGX_ScreenMaxWidth()-60, 20)];
    tagLabel.text=@"Wild Life";
    tagLabel.textColor=[UIColor whiteColor];
    [self addSubview:tagLabel];
    tagLabel.font=[UIFont fontWithName:k_fontSemiBold size:14];
    
    timeLabel=[[UILabel alloc] initWithFrame:CGXRectMake(CGX_ScreenMaxWidth()-100, CGX_ScreenMaxHeight()-160, 100-22, 20)];
    timeLabel.text=@"3 hrs";
    timeLabel.textColor=[UIColor whiteColor];
    [self addSubview:timeLabel];
    timeLabel.textAlignment=NSTextAlignmentRight;
    timeLabel.font=[UIFont fontWithName:k_fontLight size:14];
    
    
    
    
    photoLabel=[[UILabel alloc] initWithFrame:CGXRectMake(22, CGX_ScreenMaxHeight()-220, CGX_ScreenMaxWidth()-44, 50)];
    photoLabel.text=@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    photoLabel.textColor=[UIColor whiteColor];
    photoLabel.numberOfLines=2;
    [self addSubview:photoLabel];
    photoLabel.font=[UIFont fontWithName:k_fontLight size:15];
    
    
    scrollView.delegate=self;
    /*
     UIButton *prevBtn,*closeBtn,*nextBtn,*likeBtn,*commentBtn,*shareBtn;
     UILabel *likeCount,*commentCount,*tagLabel,*timeLabel,*photoLabel;
     UIView *lineView;
     */
    prevBtn.hidden=true;
    
    [self scrollViewDidEndDecelerating:scrollView];
    
    [nextBtn addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [prevBtn addTarget:self action:@selector(prevBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)updateScollerWithDelta:(CGFloat)delta;
{
    for(int i=0;i<[pagesArray count];i++)
    {
        
        PortfolioItemView *item=(PortfolioItemView *)[pagesArray objectAtIndex:i];
        [item updateScollerWithDelta:delta];
        
    }
    
}
-(void)IntroAnimationStateStart
{
    prevBtn.alpha=0;
    closeBtn.alpha=0;
    nextBtn.alpha=0;
    likeBtn.alpha=0;
    commentBtn.alpha=0;
    shareBtn.alpha=0;
    likeCount.alpha=0;
    commentCount.alpha=0;
    tagLabel.alpha=0;
    timeLabel.alpha=0;
    photoLabel.alpha=0;
    lineView.alpha=0;
    
    prevBtn.center=CGXPointMake(50, CGX_ScreenMaxHeight()-50+200);
    nextBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2*2-50, CGX_ScreenMaxHeight()-50+200);
    closeBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, CGX_ScreenMaxHeight()-35+200);
    
    lineView.frame=CGXRectMake(12, CGX_ScreenMaxHeight()-69+200, CGX_ScreenMaxWidth()-24, 1);
    likeBtn.frame=CGXRectMake(12, CGX_ScreenMaxHeight()-112+200, 40, 40);
    commentBtn.frame=CGXRectMake(CGX_ScreenMaxWidth()/2-40/2, CGX_ScreenMaxHeight()-112+200, 40, 40);
    shareBtn.frame=CGXRectMake(CGX_ScreenMaxWidth()-12-40, CGX_ScreenMaxHeight()-112+200, 40, 40);
    commentCount.frame=CGXRectMake(CGX_ScreenMaxWidth()/2-20, CGX_ScreenMaxHeight()-132+200, 40, 30);
    likeCount.frame=CGXRectMake(12, CGX_ScreenMaxHeight()-132+200, 40, 30);
    
}
-(void)IntroAnimationStateEnd
{
    prevBtn.center=CGXPointMake(25, CGX_ScreenMaxHeight()-35);
    nextBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-25, CGX_ScreenMaxHeight()-35);
    closeBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, CGX_ScreenMaxHeight()-35);
    
    lineView.frame=CGXRectMake(12, CGX_ScreenMaxHeight()-69, CGX_ScreenMaxWidth()-24, 1);
    likeBtn.frame=CGXRectMake(12, CGX_ScreenMaxHeight()-112, 40, 40);
    commentBtn.frame=CGXRectMake(CGX_ScreenMaxWidth()/2-40/2, CGX_ScreenMaxHeight()-112, 40, 40);
    shareBtn.frame=CGXRectMake(CGX_ScreenMaxWidth()-12-40, CGX_ScreenMaxHeight()-112, 40, 40);
    commentCount.frame=CGXRectMake(CGX_ScreenMaxWidth()/2-20, CGX_ScreenMaxHeight()-132, 40, 30);
    likeCount.frame=CGXRectMake(12, CGX_ScreenMaxHeight()-132, 40, 30);
    
    
    prevBtn.alpha=1;
    closeBtn.alpha=1;
    nextBtn.alpha=1;
    likeBtn.alpha=1;
    commentBtn.alpha=1;
    shareBtn.alpha=1;
    likeCount.alpha=1;
    commentCount.alpha=1;
    tagLabel.alpha=1;
    timeLabel.alpha=1;
    photoLabel.alpha=1;
    lineView.alpha=1;
}
-(void)IntroAnimation
{
    
    //    prevBtn.center=CGXPointMake(50, CGX_ScreenMaxHeight()-50+200);
    //    nextBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2*2-50, CGX_ScreenMaxHeight()-50+200);
    //    closeBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, CGX_ScreenMaxHeight()-50+200);
    //
    //
    //    prevBtn.alpha=0;
    //    closeBtn.alpha=0;
    //    nextBtn.alpha=0;
    //    likeBtn.alpha=0;
    //    commentBtn.alpha=0;
    //    shareBtn.alpha=0;
    //    likeCount.alpha=0;
    //    commentCount.alpha=0;
    //    tagLabel.alpha=0;
    //    timeLabel.alpha=0;
    //    photoLabel.alpha=0;
    //    lineView.alpha=0;
    
    
    
    [UIView animateKeyframesWithDuration:0.5 delay:0.4 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        
        photoLabel.alpha=1;
        timeLabel.alpha=1;
        tagLabel.alpha=1;
        
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    [UIView animateKeyframesWithDuration:0.5 delay:0.8 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        
        lineView.frame=CGXRectMake(12, CGX_ScreenMaxHeight()-69, CGX_ScreenMaxWidth()-24, 1);
        likeBtn.frame=CGXRectMake(12, CGX_ScreenMaxHeight()-112, 40, 40);
        commentBtn.frame=CGXRectMake(CGX_ScreenMaxWidth()/2-40/2, CGX_ScreenMaxHeight()-112, 40, 40);
        shareBtn.frame=CGXRectMake(CGX_ScreenMaxWidth()-12-40, CGX_ScreenMaxHeight()-112, 40, 40);
        commentCount.frame=CGXRectMake(CGX_ScreenMaxWidth()/2-20, CGX_ScreenMaxHeight()-132, 40, 30);
        likeCount.frame=CGXRectMake(12, CGX_ScreenMaxHeight()-132, 40, 30);
        
        likeBtn.alpha=1;
        commentBtn.alpha=1;
        shareBtn.alpha=1;
        likeCount.alpha=1;
        commentCount.alpha=1;
        lineView.alpha=1;
        
        
        prevBtn.center=CGXPointMake(25, CGX_ScreenMaxHeight()-35);
        nextBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-25, CGX_ScreenMaxHeight()-35);
        closeBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, CGX_ScreenMaxHeight()-35);
        
        prevBtn.alpha=1;
        closeBtn.alpha=1;
        nextBtn.alpha=1;
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    
}

-(void)closeBtnClicked:(id)sender
{
    ProfileViewController *vc=(ProfileViewController *)[self viewController];
    [vc dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)nextBtnClicked:(id)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - CGX_ScreenMaxWidth()/ 2) / pageWidth) + 1;
    
    page=page+1;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        scrollView.contentOffset=CGXPointMake(pageWidth*page, 0);
        
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:scrollView];
    }];
    
}
-(void)prevBtnClicked:(id)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - CGX_ScreenMaxWidth()/ 2) / pageWidth) + 1;
    
    page=page-1;
    
    [UIView animateWithDuration:0.5 animations:^{
        scrollView.contentOffset=CGXPointMake(pageWidth*page, 0);
        
    } completion:^(BOOL finished) {
        
        [self scrollViewDidEndDecelerating:scrollView];
    }];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - CGX_ScreenMaxWidth()/ 2) / pageWidth) + 1;
    
    if(page==0)
    {
        prevBtn.hidden=true;
        nextBtn.hidden=false;
    }
    else if(page==[pagesArray count]-1)
    {
        prevBtn.hidden=false;
        nextBtn.hidden=true;
    }
    else
    {
        prevBtn.hidden=false;
        nextBtn.hidden=false;
    }
    
    
    
    
    likeCount.text=[NSString stringWithFormat:@"%d",page*5+page*3+5];
    commentCount.text=[NSString stringWithFormat:@"%d",page*2+3];
    tagLabel.text=[NSString stringWithFormat:@"Wildlife"];
    timeLabel.text=[NSString stringWithFormat:@"%d hrs",page*2+page*3+1];
    
    
    photoLabel.text=[[self randomStringWithLength:page] capitalizedString];
    
    
    
}
-(NSString *) randomStringWithLength: (int) len
{
    
    NSArray *array=[NSArray arrayWithObjects:@"Lorem ipsum dolor sit amet, sed elitr lobortis repudiare eu, fugit admodum has eu.",@"Id mundi suscipit ullamcorper vix, ferri solet ut nam. Ad his congue tempor referrentur.",@"Elit accusam per an, tation option sea cu. Cu tempor elaboraret eos, option propriae qui et.", nil];
    
    return [array objectAtIndex:len];
}



@end
#pragma mark - Portfolio Item

@implementation PortfolioItemView


-(void)updateScollerWithDelta:(CGFloat)delta;
{
    
    CGAffineTransform t=CGAffineTransformMakeScale(1.2f, 1.2f);
    CGAffineTransform n=CGAffineTransformMakeTranslation(0, 300*(-3+delta));
    imageView.transform=CGAffineTransformConcat(t, n);
    
    //imageView.transform=CGAffineTransformMakeScale(4-delta, 4-delta);
}
-(void)setUpPortfolioItemViewWithPageNo:(int)number andMax:(int)max
{
    imageView=[[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:imageView];
    imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"Portfolio%d.jpeg",number+1]];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds=YES;
    
    self.clipsToBounds=YES;
    UIImageView *shadow1=[[UIImageView alloc] initWithFrame:CGXRectMake(0, CGX_ScreenMaxHeight()/2,CGX_ScreenMaxWidth(),CGX_ScreenMaxHeight()/2)];
    [self addSubview:shadow1];
    shadow1.image=[UIImage imageNamed:@"BlackShadow.png"];
    shadow1.contentMode=UIViewContentModeScaleToFill;
    shadow1.alpha=0.8;
    
    
    
    
    
    
    /* prevBtn.backgroundColor=[UIColor blackColor];
     closeBtn.backgroundColor=[UIColor blackColor];
     nextBtn.backgroundColor=[UIColor blackColor];
     shareBtn.backgroundColor=[UIColor blackColor];
     commentBtn.backgroundColor=[UIColor blackColor];
     likeBtn.backgroundColor=[UIColor blackColor];
     
     likeCount.backgroundColor=[UIColor blackColor];
     commentCount.backgroundColor=[UIColor blackColor];
     tagLabel.backgroundColor=[UIColor blackColor];
     timeLabel.backgroundColor=[UIColor blackColor];
     photoLabel.backgroundColor=[UIColor blackColor];
     */
    
    
    
    
    
}

@end

#pragma mark - BioItem View

@implementation BioItemView

-(void)setUpData:(NSDictionary *)dictionary
{
    dataDict=dictionary;
    
}
-(void)setUpUIComponents
{
    UILabel *screenTitle=[[UILabel alloc] initWithFrame:CGXRectMake(20, 70, 200, 30)];
    [self addSubview:screenTitle];
    screenTitle.textColor=[UIColor whiteColor];
    screenTitle.textAlignment=NSTextAlignmentLeft;
    screenTitle.text=@"MY STORY";
    screenTitle.font=[UIFont fontWithName:k_fontExtraBold size:15];
    
    
    UILabel *storyTitle=[[UILabel alloc] initWithFrame:CGXRectMake(20, 105, CGX_ScreenMaxWidth()-40, CGX_ScreenMaxHeight()-285)];
    [self addSubview:storyTitle];
    storyTitle.textColor=[UIColor whiteColor];
    storyTitle.textAlignment=NSTextAlignmentLeft;
    //  storyTitle.text=@"I Am an Architect. We are not fully defined by just our occupations.";
    storyTitle.numberOfLines=0;
    //  storyTitle.font=[UIFont fontWithName:k_fontExtraBold size:30];
    
    
    
    
    NSMutableAttributedString *mutableStr=[[NSMutableAttributedString alloc] init];
    
    UIFont *font1 = [UIFont fontWithName:k_fontExtraBold size:25.0f];
    NSDictionary *attrsDictionary1 = [NSDictionary dictionaryWithObject:font1
                                                                 forKey:NSFontAttributeName];
    
    UIFont *font2 = [UIFont fontWithName:k_fontRegular size:15.0f];
    NSDictionary *attrsDictionary2 = [NSDictionary dictionaryWithObject:font2
                                                                 forKey:NSFontAttributeName];
    
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:[dataDict valueForKey:@"title"] attributes:attrsDictionary1];
    
    
    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n%@",[dataDict valueForKey:@"desc"]] attributes:attrsDictionary2];
    
    [mutableStr appendAttributedString:attrString1];
    [mutableStr appendAttributedString:attrString2];
    storyTitle.attributedText=mutableStr;
    
    
    
    UIButton *readMoreBtn=[[UIButton alloc] initWithFrame:CGXRectMake(CGX_ScreenMaxWidth()-140, CGX_ScreenMaxHeight()-180, 100, 20)];
    [self addSubview:readMoreBtn];
    [readMoreBtn setTitle:@"Read More" forState:UIControlStateNormal];
    readMoreBtn.titleLabel.font=[UIFont fontWithName:k_fontRegular size:15.0f];
    readMoreBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    
    [readMoreBtn addTarget:self action:@selector(callFull:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    UILabel *tagContent=[[UILabel alloc] initWithFrame:CGXRectMake(20, CGX_ScreenMaxHeight()-140, CGX_ScreenMaxWidth()-40, 60)];
    [self addSubview:tagContent];
    tagContent.textColor=[UIColor whiteColor];
    tagContent.textAlignment=NSTextAlignmentJustified;
    tagContent.text=[[dataDict valueForKey:@"tags"] lowercaseString];
    tagContent.numberOfLines=2;
    tagContent.font=[UIFont fontWithName:k_fontSemiBold size:14];
    
    
    
    
}

-(void)callFull:(id)sender
{
    /* fullScreenPreview=[[UIView alloc] initWithFrame:self.bounds];
     [self addSubview:fullScreenPreview];
     fullScreenPreview.backgroundColor=[UIColor colorWithRed:229/255.0f green:58/255.0f blue:63/255.0f alpha:1.0f];
     
     
     UITextView *storyTitle=[[UITextView alloc] initWithFrame:CGXRectMake(20, 30, CGX_ScreenMaxWidth()-40, CGX_ScreenMaxHeight()-60-30-40)];
     [fullScreenPreview addSubview:storyTitle];
     storyTitle.backgroundColor=[UIColor clearColor];
     storyTitle.textColor=[UIColor whiteColor];
     storyTitle.textAlignment=NSTextAlignmentLeft;
     storyTitle.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0f, 0.0f, -5.0f);
     
     storyTitle.editable=false;
     
     
     NSMutableAttributedString *mutableStr=[[NSMutableAttributedString alloc] init];
     
     UIFont *font1 = [UIFont fontWithName:k_fontExtraBold size:25.0f];
     NSDictionary *attrsDictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:font1,NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,nil];
     //[NSDictionary dictionaryWithObject:font1
     //                         forKey:NSFontAttributeName];
     
     UIFont *font2 = [UIFont fontWithName:k_fontRegular size:15.0f];
     NSDictionary *attrsDictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:font2,NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,nil];
     
     NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:@"I Am an Architect. We are not fully defined by just our occupations." attributes:attrsDictionary1];
     
     
     NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:@"\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." attributes:attrsDictionary2];
     
     [mutableStr appendAttributedString:attrString1];
     [mutableStr appendAttributedString:attrString2];
     storyTitle.attributedText=mutableStr;
     
     
     
     
     
     
     
     UILabel *tagContent=[[UILabel alloc] initWithFrame:CGXRectMake(20, CGX_ScreenMaxHeight()-60, CGX_ScreenMaxWidth()-40, 60)];
     [fullScreenPreview addSubview:tagContent];
     tagContent.textColor=[UIColor whiteColor];
     tagContent.textAlignment=NSTextAlignmentJustified;
     tagContent.text=@"#work  #idea  #thoughts  #tags  #publicRelation  #media  #content  #speaking  #communication";
     tagContent.numberOfLines=2;
     tagContent.font=[UIFont fontWithName:k_fontSemiBold size:14];
     
     
     
     
     
     UIButton *closeBtn=[[UIButton alloc] initWithFrame:CGXRectMake(0, 0, 50, 50)];
     [fullScreenPreview addSubview:closeBtn];
     closeBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-50, 50);
     [closeBtn setBackgroundImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
     closeBtn.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.1];
     closeBtn.layer.cornerRadius=25;
     closeBtn.clipsToBounds=YES;
     
     [closeBtn addTarget:self action:@selector(fullScreenStop) forControlEvents:UIControlEventTouchUpInside];
     
     */
    
}
-(void)fullScreenStop
{
    [fullScreenPreview removeFromSuperview];
}


@end


