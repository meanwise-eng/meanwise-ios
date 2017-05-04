//
//  ViewController.m
//  MeanWiseUX
//
//  Created by Hardik on 15/08/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "ProfileVCX.h"
//#import "helperModule.h"

#define CRX  [UIScreen mainScreen].bounds.size.height/568.0f


@interface ProfileVC ()

@end

@implementation ProfileVC

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    [self setNeedsStatusBarAppearanceUpdate];

    scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:scrollView];
    

    
    scrollView.contentSize=CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height*4);
    scrollView.backgroundColor=[UIColor blackColor];
    
    scrollView.showsHorizontalScrollIndicator=false;
    scrollView.showsVerticalScrollIndicator=false;
    
    
    view1=[[CoverView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height*0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [scrollView addSubview:view1];
    [view1 setUpUIComponents];


    view2=[[BioView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    [scrollView addSubview:view2];
    [view2 setUpUIComponents];


    view4=[[VideoView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height*2, self.view.bounds.size.width, self.view.bounds.size.height)];
    [scrollView addSubview:view4];
    [view4 setUpUIComponents];
    
    view5=[[PortfolioView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height*3, self.view.bounds.size.width, self.view.bounds.size.height)];
    [scrollView addSubview:view5];
    [view5 setUpUIComponents];

    
    self.view.userInteractionEnabled=true;
    
    scrollView.pagingEnabled=true;
    scrollView.minimumZoomScale=1;
    scrollView.maximumZoomScale=1;
    scrollView.delegate=self;
    
    scrollView.alwaysBounceHorizontal=false;
    scrollView.alwaysBounceVertical=false;
    
    [view1 IntroAnimationStateStart];
    [view2 IntroAnimationStateStart];
    [view4 IntroAnimationStateStart];
    [view5 IntroAnimationStateStart];
    

    introBlockView=[[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:introBlockView];

 

    
   UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(IntroStop)];
    [introBlockView addGestureRecognizer:tapGestureRecognizer];

}
-(void)IntroStop
{
    if(isInIntroMode==true)
    {
       // [self IntroStop];

        [introBlockView setHidden:YES];
        
        isInIntroMode=false;
        [view1 IntroAnimationStateEnd];
        [view2 IntroAnimationStateEnd];
        [view4 IntroAnimationStateEnd];
        [view5 IntroAnimationStateEnd];
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    isInIntroMode=true;
    countSec=0;
   
    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(autoPlayLoop:) userInfo:nil repeats:YES];
    
    [view1 IntroAnimation];



}

-(void)autoPlayLoop:(id)sender
{
    if(isInIntroMode==true)
    {
    countSec++;
    
    if(countSec==2)
    {
        
        
        [UIView animateWithDuration:1.0 delay:4 options:UIViewAnimationOptionCurveLinear animations:^{

        [scrollView scrollRectToVisible:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height) animated:false];
            
        } completion:^(BOOL finished) {
            
            [view2 IntroAnimation];

        }];


    }
    if(countSec==8)
    {
        
        [UIView animateWithDuration:1.0 delay:4 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [scrollView scrollRectToVisible:CGRectMake(0, self.view.bounds.size.height*2, self.view.bounds.size.width, self.view.bounds.size.height) animated:false];
            
        } completion:^(BOOL finished) {
            
            [view4 IntroAnimation];
            
        }];

    }
    if(countSec==13)
    {
        
        [UIView animateWithDuration:1.0 delay:4 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [scrollView scrollRectToVisible:CGRectMake(0, self.view.bounds.size.height*3, self.view.bounds.size.width, self.view.bounds.size.height) animated:false];
            
        } completion:^(BOOL finished) {
            
            [view4 IntroAnimationStateEnd];

            [view5 IntroAnimation];
            
            [self IntroStop];
        }];
    }
    }
   
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    CGFloat pageWidth = scrollView.frame.size.height;
//    int page = floor((scrollView.contentOffset.y - self.view.bounds.size.height/ 2) / pageWidth) + 1;
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

-(void)scrollToBioView
{
   

    [scrollView scrollRectToVisible:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height) animated:YES];
    
}
-(void)scrollToVideoView
{
    [scrollView scrollRectToVisible:CGRectMake(0, self.view.bounds.size.height*2, self.view.bounds.size.width, self.view.bounds.size.height) animated:YES];

}
-(void)scrollToPortfolioView
{
    [scrollView scrollRectToVisible:CGRectMake(0, self.view.bounds.size.height*3, self.view.bounds.size.width, self.view.bounds.size.height) animated:YES];

}
-(void)dismissThisController
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
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
@implementation CoverView

-(void)setUpUIComponents
{
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:imageView];
    imageView.image=[UIImage imageNamed:@"CoverPhoto.jpg"];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    
    UIImageView *shadow1=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height/2,self.bounds.size.width,self.bounds.size.height/2)];
    [self addSubview:shadow1];
    shadow1.image=[UIImage imageNamed:@"BlackShadow.png"];
    shadow1.contentMode=UIViewContentModeScaleToFill;
    shadow1.alpha=0.8;
    
    
    bioTitle=[[UILabel alloc] initWithFrame:CGRectMake(40*CRX, self.bounds.size.height/2-50, self.bounds.size.width-80*CRX, 180*CRX)];
    [self addSubview:bioTitle];
    bioTitle.textColor=[UIColor whiteColor];
    bioTitle.textAlignment=NSTextAlignmentLeft;
    bioTitle.text=@"Hey,\nI'm Sally";
    bioTitle.numberOfLines=2;
    bioTitle.adjustsFontSizeToFitWidth=YES;
    bioTitle.font=[UIFont fontWithName:k_fontBold size:90];
    
 
 
    connectionCount=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100*CRX, 20*CRX)];
    connectionCount.textColor=[UIColor whiteColor];
    connectionCount.textAlignment=NSTextAlignmentCenter;
    connectionCount.text=@"50K";
    [self addSubview:connectionCount];
    connectionCount.font=[UIFont fontWithName:k_fontBold size:14];

    connectionLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100*CRX, 20*CRX)];
    connectionLabel.textColor=[UIColor whiteColor];
    connectionLabel.textAlignment=NSTextAlignmentCenter;
    connectionLabel.text=@"connections";
    [self addSubview:connectionLabel];
    connectionLabel.font=[UIFont fontWithName:k_fontSemiBold size:12];

    
    
    profileViewCount=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100*CRX, 20*CRX)];
    profileViewCount.textColor=[UIColor whiteColor];
    profileViewCount.textAlignment=NSTextAlignmentCenter;
    profileViewCount.text=@"750K";
    [self addSubview:profileViewCount];
    profileViewCount.font=[UIFont fontWithName:k_fontBold size:14];
    
    profileLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100*CRX, 20*CRX)];
    profileLabel.textColor=[UIColor whiteColor];
    profileLabel.textAlignment=NSTextAlignmentCenter;
    profileLabel.text=@"profile views";
    [self addSubview:profileLabel];
    profileLabel.font=[UIFont fontWithName:k_fontSemiBold size:12];
    
    closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45*CRX, 45*CRX)];
    [self addSubview:closeBtn];
    closeBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-50*CRX);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
    closeBtn.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.1];
    closeBtn.layer.cornerRadius=25*CRX;
    closeBtn.clipsToBounds=YES;
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    downBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45*CRX, 45*CRX)];
    [self addSubview:downBtn];
    downBtn.center=CGPointMake(self.bounds.size.width-25*CRX, self.bounds.size.height-35*CRX);

    [downBtn setBackgroundImage:[UIImage imageNamed:@"Arrow_down.png"] forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(downBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    addBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-25*CRX, 25*CRX, 45*CRX, 45*CRX)];
    [self addSubview:addBtn];
    addBtn.center=CGPointMake(self.bounds.size.width-40*CRX, 58*CRX);
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
    
    bioTitle.frame=CGRectMake(22*CRX, self.bounds.size.height/2+200*CRX, (self.bounds.size.width-44*CRX)*0.65, 115*CRX);

    downBtn.center=CGPointMake(self.bounds.size.width-25*CRX, self.bounds.size.height-35*CRX+200*CRX);
    closeBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-35*CRX+200*CRX);
    
    connectionCount.center=CGPointMake(self.bounds.size.width/2-85*CRX, self.bounds.size.height-95*CRX);
    connectionLabel.center=CGPointMake(self.bounds.size.width/2-85*CRX, self.bounds.size.height-80*CRX);
    profileViewCount.center=CGPointMake(self.bounds.size.width/2+85*CRX, self.bounds.size.height-95*CRX);
    profileLabel.center=CGPointMake(self.bounds.size.width/2+85*CRX, self.bounds.size.height-80*CRX);
    
    addBtn.center=CGPointMake(self.bounds.size.width-40*CRX, 58*CRX-200*CRX);

    
}
-(void)IntroAnimationStateEnd
{

    
    bioTitle.frame=CGRectMake(22*CRX, self.bounds.size.height/2-0*CRX, (self.bounds.size.width-44*CRX)*0.65, 115*CRX);
    connectionCount.center=CGPointMake(self.bounds.size.width/2-85*CRX, self.bounds.size.height-95*CRX);
    connectionLabel.center=CGPointMake(self.bounds.size.width/2-85*CRX, self.bounds.size.height-80*CRX);
    profileViewCount.center=CGPointMake(self.bounds.size.width/2+85*CRX, self.bounds.size.height-95*CRX);
    profileLabel.center=CGPointMake(self.bounds.size.width/2+85*CRX, self.bounds.size.height-80*CRX);
    
    addBtn.center=CGPointMake(self.bounds.size.width-40*CRX, 58*CRX);



    downBtn.center=CGPointMake(self.bounds.size.width-25*CRX, self.bounds.size.height-35*CRX);
    closeBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-35*CRX);
    
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
       
        
        bioTitle.frame=CGRectMake(22*CRX, self.bounds.size.height/2-0*CRX, (self.bounds.size.width-44*CRX)*0.65, 115*CRX);
        bioTitle.alpha=1;

        
    }];
    
    
    [UIView animateWithDuration:1.0f delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        connectionCount.center=CGPointMake(self.bounds.size.width/2-85*CRX, self.bounds.size.height-95*CRX);
        connectionLabel.center=CGPointMake(self.bounds.size.width/2-85*CRX, self.bounds.size.height-80*CRX);
        profileViewCount.center=CGPointMake(self.bounds.size.width/2+85*CRX, self.bounds.size.height-95*CRX);
        profileLabel.center=CGPointMake(self.bounds.size.width/2+85*CRX, self.bounds.size.height-80*CRX);
        
        connectionCount.alpha=1;
        connectionLabel.alpha=1;
        profileViewCount.alpha=1;
        profileLabel.alpha=1;
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    [UIView animateWithDuration:1.0f delay:1.5 options:UIViewAnimationOptionCurveLinear animations:^{
        
        downBtn.center=CGPointMake(self.bounds.size.width-25*CRX, self.bounds.size.height-35*CRX);
        closeBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-35*CRX);
        
        downBtn.alpha=1;
        closeBtn.alpha=1;

        addBtn.center=CGPointMake(self.bounds.size.width-40*CRX, 58*CRX);
        addBtn.alpha=1;
        
    } completion:^(BOOL finished) {
        
    }];
    
    
  
   
    
    
    

}
-(void)downBtnClicked:(id)sender
{
    ProfileVC *vc=(ProfileVC *)[self viewController];
    [vc scrollToBioView];

}
-(void)closeBtnClicked:(id)sender
{
 
    ProfileVC *vc=(ProfileVC *)[self viewController];
    [vc dismissViewControllerAnimated:YES completion:nil];

}

@end

@implementation BioView

-(void)setUpUIComponents
{
    
    dataArray=[[NSMutableArray alloc] init];
    
    NSDictionary *dict1=@{@"title":@"Explaining All Of U.S. Energy Use With A Genius Chart And Cheeseburgers",@"desc":@"Saul Griffith really, really likes to quantify things about energy and carbon. You can watch the MacArthur genius award winner and entrepreneur soberly dissect his formerly unsustainable lifestyle in more detail than you ever thought possible here and here.",@"tags":@"#tesla #Electric Car #Energy #charts"};
    
    NSDictionary *dict2=@{@"title":@"Saul Griffith really, really likes to quantify things about energy and carbon.",@"desc":@"Before 9:00 a.m. on a Tuesday morning in August, APEX Gymnastics in Leesburg, Virginia, is already filled with dozens of budding gymnasts. The three-year-olds, dressed in leotards still too big for them and with ponytails that won’t stay up, bounce on the trampoline, while the intermediate-level girls laugh amongst themselves as they put chalk on their hands and prepare to tackle the daunting uneven bars or four-inch balance beams.",@"tags":@"#sports #women #tesla #general"};
    
    NSDictionary *dict3=@{@"title":@"When one girl has to drop, I feel a lot of anguish,” she said. “I also feel a lot for the parents.",@"desc":@"Welch, who coached the “immensely talented” Sara at APEX, said seeing girls leave is particularly heartbreaking because gymnastics is more than just a sport — it’s a social outlet and a second family for many of them. Plus, it was tough to see one of the few non-white families at the gym forced to walk away because of time and money.",@"tags":@"#sports #olympics #race #features #video"};

    [dataArray addObject:dict1];
    [dataArray addObject:dict2];
    [dataArray addObject:dict3];
    
    
    
    self.backgroundColor=[UIColor colorWithRed:229/255.0f green:58/255.0f blue:63/255.0f alpha:1.0f];
    
    scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:scrollView];
    scrollView.contentSize=CGSizeMake(self.bounds.size.width*3, self.bounds.size.height);
    scrollView.showsHorizontalScrollIndicator=false;
    scrollView.showsVerticalScrollIndicator=false;
    scrollView.pagingEnabled=YES;
    
    for(int i=0;i<[dataArray count];i++)
    {
        BioItemView *view=[[BioItemView alloc] initWithFrame:CGRectMake(self.bounds.size.width*i, 0, self.bounds.size.width, self.bounds.size.height)];
        [scrollView addSubview:view];
        [view setUpData:[dataArray objectAtIndex:i]];
        [view setUpUIComponents];
    }
    
    
    closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45*CRX, 45*CRX)];
    [self addSubview:closeBtn];
    closeBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-35*CRX);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
    closeBtn.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.1];
    closeBtn.layer.cornerRadius=25;
    closeBtn.clipsToBounds=YES;
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    downBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50*CRX, 50*CRX)];
    [self addSubview:downBtn];
    downBtn.center=CGPointMake(self.bounds.size.width-25*CRX, self.bounds.size.height-35*CRX);
    [downBtn setBackgroundImage:[UIImage imageNamed:@"Arrow_down.png"] forState:UIControlStateNormal];
    
    [downBtn addTarget:self action:@selector(downBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)closeBtnClicked:(id)sender
{
    ProfileVC *vc=(ProfileVC *)[self viewController];
    [vc dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)downBtnClicked:(id)sender
{
    ProfileVC *vc=(ProfileVC *)[self viewController];
    [vc scrollToVideoView];
    
}
-(void)IntroAnimationStateStart
{
    scrollView.alpha=0;

    downBtn.center=CGPointMake(self.bounds.size.width-25*CRX, self.bounds.size.height-35*CRX+200*CRX);
    closeBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-35*CRX+200*CRX);
    
    downBtn.alpha=0;
    closeBtn.alpha=0;
}
-(void)IntroAnimationStateEnd
{
    scrollView.alpha=1;
    
    downBtn.center=CGPointMake(self.bounds.size.width-25*CRX, self.bounds.size.height-35*CRX);
    closeBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-35*CRX);
    
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
        
        downBtn.center=CGPointMake(self.bounds.size.width-25*CRX, self.bounds.size.height-35*CRX);
        closeBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-35*CRX);
        
        downBtn.alpha=1;
        closeBtn.alpha=1;
        
        
    } completion:^(BOOL finished) {
        
    }];
    
}
@end


@implementation VideoView

-(void)IntroAnimationStateStart
{

    downBtn.center=CGPointMake(self.bounds.size.width-25*CRX, self.bounds.size.height-35*CRX+200*CRX);
    closeBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-35*CRX+200*CRX);

    downBtn.alpha=0;
    closeBtn.alpha=0;

    
}
-(void)IntroAnimationStateEnd
{
    downBtn.center=CGPointMake(self.bounds.size.width-25*CRX, self.bounds.size.height-35*CRX);
    closeBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-35*CRX);

    downBtn.alpha=1;
    closeBtn.alpha=1;

    [player pause];
}
-(void)IntroAnimation
{
    [player play];
    
    [UIView animateWithDuration:1.0 animations:^{
        
    } completion:^(BOOL finished) {
        
        
        
    }];
    
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        downBtn.center=CGPointMake(self.bounds.size.width-25*CRX, self.bounds.size.height-35*CRX);
        closeBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-35*CRX);
        
        downBtn.alpha=1;
        closeBtn.alpha=1;
        
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}
-(void)setUpUIComponents
{
    //self.backgroundColor=[UIColor colorWithRed:229/255.0f green:58/255.0f blue:63/255.0f alpha:1.0f];
    

    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"mag_app_reducedvid" withExtension:@"mp4"];
    
    // create an AVPlayer
    player = [AVPlayer playerWithURL:videoURL];
    
    // create a player view controller
    AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
    controller.player = player;
    [player prepareForInterfaceBuilder];
    [player addObserver:self forKeyPath:@"rate" options:0 context:nil];

    // show the view controller
    //[self addChildViewController:controller];
    [self addSubview:controller.view];
    controller.view.frame=self.bounds;
    controller.showsPlaybackControls=false;
    controller.videoGravity=AVLayerVideoGravityResizeAspectFill;


    
    UIImageView *shadow1=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height/2,self.bounds.size.width,self.bounds.size.height/2)];
    [self addSubview:shadow1];
    shadow1.image=[UIImage imageNamed:@"BlackShadow.png"];
    shadow1.contentMode=UIViewContentModeScaleToFill;
    shadow1.alpha=0.8;
    
    
    
    
    
    
    playBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80*CRX, 80*CRX)];
    [self addSubview:playBtn];
    playBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [playBtn setBackgroundImage:[UIImage imageNamed:@"playBtn.png"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45*CRX, 45*CRX)];
    [self addSubview:closeBtn];
    closeBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-35*CRX);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
    closeBtn.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.1];
    closeBtn.layer.cornerRadius=25;
    closeBtn.clipsToBounds=YES;
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    downBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50*CRX, 50*CRX)];
    [self addSubview:downBtn];
    downBtn.center=CGPointMake(self.bounds.size.width-25*CRX, self.bounds.size.height-35*CRX);
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
    ProfileVC *vc=(ProfileVC *)[self viewController];
    [vc scrollToPortfolioView];
    
}

-(void)closeBtnClicked:(id)sender
{
    ProfileVC *vc=(ProfileVC *)[self viewController];
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

@implementation PortfolioView 
-(void)setUpUIComponents
{
    
    pagesArray=[[NSMutableArray alloc] init];
    
    
    scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:scrollView];
    
    
    
    scrollView.contentSize=CGSizeMake(self.bounds.size.width*3, self.bounds.size.height);
    scrollView.backgroundColor=[UIColor blackColor];
    
    scrollView.showsHorizontalScrollIndicator=false;
    scrollView.showsVerticalScrollIndicator=false;
    
    
    scrollView.pagingEnabled=YES;
    
    for(int i=0;i<3;i++)
    {
    PortfolioItemView *view=[[PortfolioItemView alloc] initWithFrame:CGRectMake(self.bounds.size.width*i, 0, self.bounds.size.width, self.bounds.size.height)];
    [scrollView addSubview:view];
        [view setUpPortfolioItemViewWithPageNo:i andMax:3];
        
    [pagesArray addObject:view];
    }
    

    

    
        prevBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45*CRX, 45*CRX)];
        [self addSubview:prevBtn];
        [prevBtn setBackgroundImage:[UIImage imageNamed:@"Arrow_left.png"] forState:UIControlStateNormal];
    
    
    
    closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45*CRX, 45*CRX)];
    [self addSubview:closeBtn];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
    closeBtn.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.1];
    closeBtn.layer.cornerRadius=45/2*CRX;
    closeBtn.clipsToBounds=YES;
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
        nextBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45*CRX, 45*CRX)];
        [self addSubview:nextBtn];
        [nextBtn setBackgroundImage:[UIImage imageNamed:@"Arrow_right.png"] forState:UIControlStateNormal];
    
    

    
    
    
    
    lineView=[[UIView alloc] initWithFrame:CGRectMake(12*CRX, self.bounds.size.height-69*CRX, self.bounds.size.width-24*CRX, 1)];
    [self addSubview:lineView];
    lineView.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.2];
    
    
    
    
    
    likeBtn=[[UIButton alloc] initWithFrame:CGRectMake(12*CRX, self.bounds.size.height-112*CRX, 40*CRX, 40*CRX)];
    [self addSubview:likeBtn];
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
    
    
    

    
    commentBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-40/2*CRX, self.bounds.size.height-112*CRX, 40*CRX, 40*CRX)];
    [self addSubview:commentBtn];
    [commentBtn setBackgroundImage:[UIImage imageNamed:@"comments.png"] forState:UIControlStateNormal];
    
    shareBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-12*CRX-40*CRX, self.bounds.size.height-112*CRX, 40*CRX, 40*CRX)];
    [self addSubview:shareBtn];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    
    
  

    
    likeCount=[[UILabel alloc] initWithFrame:CGRectMake(12*CRX, self.bounds.size.height-132*CRX, 40*CRX, 30*CRX)];
    likeCount.text=@"12";
    likeCount.textColor=[UIColor whiteColor];
    [self addSubview:likeCount];
    likeCount.textAlignment=NSTextAlignmentCenter;
    likeCount.font=[UIFont fontWithName:k_fontSemiBold size:14];
    
    commentCount=[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-20*CRX, self.bounds.size.height-132*CRX, 40*CRX, 30*CRX)];
    commentCount.text=@"5";
    commentCount.textColor=[UIColor whiteColor];
    [self addSubview:commentCount];
    commentCount.textAlignment=NSTextAlignmentCenter;
    commentCount.font=[UIFont fontWithName:k_fontSemiBold size:14];
    
    
    
    
    lineView.frame=CGRectMake(12*CRX, self.bounds.size.height-69*CRX, self.bounds.size.width-24*CRX, 1);
    likeBtn.frame=CGRectMake(12*CRX, self.bounds.size.height-112*CRX, 40*CRX, 40*CRX);
    commentBtn.frame=CGRectMake(self.bounds.size.width/2-40/2*CRX, self.bounds.size.height-112*CRX, 40*CRX, 40*CRX);
    shareBtn.frame=CGRectMake(self.bounds.size.width-12*CRX-40*CRX, self.bounds.size.height-112*CRX, 40*CRX, 40*CRX);
    commentCount.frame=CGRectMake(self.bounds.size.width/2-20*CRX, self.bounds.size.height-132*CRX, 40*CRX, 30*CRX);
    likeCount.frame=CGRectMake(12*CRX, self.bounds.size.height-132*CRX, 40*CRX, 30*CRX);
    
    
    
    
    tagLabel=[[UILabel alloc] initWithFrame:CGRectMake(22*CRX, self.bounds.size.height-160*CRX, self.bounds.size.width-60*CRX, 20*CRX)];
    tagLabel.text=@"Wild Life";
    tagLabel.textColor=[UIColor whiteColor];
    [self addSubview:tagLabel];
    tagLabel.font=[UIFont fontWithName:k_fontSemiBold size:14];
    
    timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-100*CRX, self.bounds.size.height-160*CRX, 100*CRX-22*CRX, 20*CRX)];
    timeLabel.text=@"3 hrs";
    timeLabel.textColor=[UIColor whiteColor];
    [self addSubview:timeLabel];
    timeLabel.textAlignment=NSTextAlignmentRight;
    timeLabel.font=[UIFont fontWithName:k_fontLight size:14];
    
    
    
    
    photoLabel=[[UILabel alloc] initWithFrame:CGRectMake(22*CRX, self.bounds.size.height-220*CRX, self.bounds.size.width-44*CRX, 50*CRX)];
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
-(void)nextBtnClicked:(id)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - self.bounds.size.width/ 2) / pageWidth) + 1;

    page=page+1;
    
   
    [UIView animateWithDuration:0.5 animations:^{
        scrollView.contentOffset=CGPointMake(pageWidth*page, 0);

    } completion:^(BOOL finished) {
                [self scrollViewDidEndDecelerating:scrollView];
    }];

}
-(void)prevBtnClicked:(id)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - self.bounds.size.width/ 2) / pageWidth) + 1;
    
    page=page-1;
    
    [UIView animateWithDuration:0.5 animations:^{
        scrollView.contentOffset=CGPointMake(pageWidth*page, 0);
        
    } completion:^(BOOL finished) {
        
        [self scrollViewDidEndDecelerating:scrollView];
    }];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1
{
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - self.bounds.size.width/ 2) / pageWidth) + 1;
   
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

-(NSString *) randomStringWithLength: (int) len {
    
    NSArray *array=[NSArray arrayWithObjects:@"Lorem ipsum dolor sit amet, sed elitr lobortis repudiare eu, fugit admodum has eu.",@"Id mundi suscipit ullamcorper vix, ferri solet ut nam. Ad his congue tempor referrentur.",@"Elit accusam per an, tation option sea cu. Cu tempor elaboraret eos, option propriae qui et.", nil];
    
    return [array objectAtIndex:len];
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
    
    prevBtn.center=CGPointMake(50, self.bounds.size.height-50+200);
    nextBtn.center=CGPointMake(self.bounds.size.width/2*2-50, self.bounds.size.height-50+200);
    closeBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-35*CRX+200*CRX);
    
    lineView.frame=CGRectMake(12*CRX, self.bounds.size.height-69*CRX+200*CRX, self.bounds.size.width-24*CRX, 1);
    likeBtn.frame=CGRectMake(12*CRX, self.bounds.size.height-112*CRX+200*CRX, 40*CRX, 40*CRX);
    commentBtn.frame=CGRectMake(self.bounds.size.width/2-40/2*CRX, self.bounds.size.height-112*CRX+200*CRX, 40*CRX, 40*CRX);
    shareBtn.frame=CGRectMake(self.bounds.size.width-12*CRX-40*CRX, self.bounds.size.height-112*CRX+200*CRX, 40*CRX, 40*CRX);
    commentCount.frame=CGRectMake(self.bounds.size.width/2-20*CRX, self.bounds.size.height-132*CRX+200*CRX, 40*CRX, 30*CRX);
    likeCount.frame=CGRectMake(12*CRX, self.bounds.size.height-132*CRX+200*CRX, 40*CRX, 30*CRX);

}
-(void)IntroAnimationStateEnd
{
    prevBtn.center=CGPointMake(25*CRX, self.bounds.size.height-35*CRX);
    nextBtn.center=CGPointMake(self.bounds.size.width-25*CRX, self.bounds.size.height-35*CRX);
    closeBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-35*CRX);
    
    lineView.frame=CGRectMake(12*CRX, self.bounds.size.height-69*CRX, self.bounds.size.width-24*CRX, 1);
    likeBtn.frame=CGRectMake(12*CRX, self.bounds.size.height-112*CRX, 40*CRX, 40*CRX);
    commentBtn.frame=CGRectMake(self.bounds.size.width/2-40/2*CRX, self.bounds.size.height-112*CRX, 40*CRX, 40*CRX);
    shareBtn.frame=CGRectMake(self.bounds.size.width-12*CRX-40*CRX, self.bounds.size.height-112*CRX, 40*CRX, 40*CRX);
    commentCount.frame=CGRectMake(self.bounds.size.width/2-20*CRX, self.bounds.size.height-132*CRX, 40*CRX, 30*CRX);
    likeCount.frame=CGRectMake(12*CRX, self.bounds.size.height-132*CRX, 40*CRX, 30*CRX);
    
    
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
-(void)closeBtnClicked:(id)sender
{
    ProfileVC *vc=(ProfileVC *)[self viewController];
    [vc dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)IntroAnimation
{
 
//    prevBtn.center=CGPointMake(50, self.bounds.size.height-50+200);
//    nextBtn.center=CGPointMake(self.bounds.size.width/2*2-50, self.bounds.size.height-50+200);
//    closeBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-50+200);
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
        
        
        lineView.frame=CGRectMake(12*CRX, self.bounds.size.height-69*CRX, self.bounds.size.width-24*CRX, 1);
        likeBtn.frame=CGRectMake(12*CRX, self.bounds.size.height-112*CRX, 40*CRX, 40*CRX);
        commentBtn.frame=CGRectMake(self.bounds.size.width/2-40/2*CRX, self.bounds.size.height-112*CRX, 40*CRX, 40*CRX);
        shareBtn.frame=CGRectMake(self.bounds.size.width-12*CRX-40*CRX, self.bounds.size.height-112*CRX, 40*CRX, 40*CRX);
        commentCount.frame=CGRectMake(self.bounds.size.width/2-20*CRX, self.bounds.size.height-132*CRX, 40*CRX, 30*CRX);
        likeCount.frame=CGRectMake(12*CRX, self.bounds.size.height-132*CRX, 40*CRX, 30*CRX);
        
        likeBtn.alpha=1;
        commentBtn.alpha=1;
        shareBtn.alpha=1;
        likeCount.alpha=1;
        commentCount.alpha=1;
        lineView.alpha=1;

        
        prevBtn.center=CGPointMake(25*CRX, self.bounds.size.height-35*CRX);
        nextBtn.center=CGPointMake(self.bounds.size.width-25*CRX, self.bounds.size.height-35*CRX);
        closeBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-35*CRX);
        
        prevBtn.alpha=1;
        closeBtn.alpha=1;
        nextBtn.alpha=1;
        
    } completion:^(BOOL finished) {
        
    }];
    

    
}


@end
@implementation PortfolioItemView

-(void)setUpPortfolioItemViewWithPageNo:(int)number andMax:(int)max
{
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:imageView];
    imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"Portfolio%d.jpeg",number+1]];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds=YES;
    
    
    UIImageView *shadow1=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height/2,self.bounds.size.width,self.bounds.size.height/2)];
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
@implementation BioItemView

-(void)setUpData:(NSDictionary *)dictionary
{
    dataDict=dictionary;
    
}
-(void)setUpUIComponents
{
   
    
    UILabel *screenTitle=[[UILabel alloc] initWithFrame:CGRectMake(20*CRX, 70, 200*CRX, 30*CRX)];
    [self addSubview:screenTitle];
    screenTitle.textColor=[UIColor whiteColor];
    screenTitle.textAlignment=NSTextAlignmentLeft;
    screenTitle.text=@"MY STORY";
    screenTitle.font=[UIFont fontWithName:k_fontExtraBold size:15];
    
    
    UILabel *storyTitle=[[UILabel alloc] initWithFrame:CGRectMake(20*CRX, 105*CRX, self.bounds.size.width-40*CRX, self.bounds.size.height-285*CRX)];
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
    
    
    
    UIButton *readMoreBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-140*CRX, self.bounds.size.height-180*CRX, 100*CRX, 20*CRX)];
    [self addSubview:readMoreBtn];
    [readMoreBtn setTitle:@"Read More" forState:UIControlStateNormal];
    readMoreBtn.titleLabel.font=[UIFont fontWithName:k_fontRegular size:15.0f];
    readMoreBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    
    [readMoreBtn addTarget:self action:@selector(callFull:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    UILabel *tagContent=[[UILabel alloc] initWithFrame:CGRectMake(20*CRX, self.bounds.size.height-140*CRX, self.bounds.size.width-40*CRX, 60*CRX)];
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
    
    
    UITextView *storyTitle=[[UITextView alloc] initWithFrame:CGRectMake(20, 30, self.bounds.size.width-40, self.bounds.size.height-60-30-40)];
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
    
    
    
    
    
    
    
    UILabel *tagContent=[[UILabel alloc] initWithFrame:CGRectMake(20, self.bounds.size.height-60, self.bounds.size.width-40, 60)];
    [fullScreenPreview addSubview:tagContent];
    tagContent.textColor=[UIColor whiteColor];
    tagContent.textAlignment=NSTextAlignmentJustified;
    tagContent.text=@"#work  #idea  #thoughts  #tags  #publicRelation  #media  #content  #speaking  #communication";
    tagContent.numberOfLines=2;
    tagContent.font=[UIFont fontWithName:k_fontSemiBold size:14];
    

    
    

    UIButton *closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [fullScreenPreview addSubview:closeBtn];
    closeBtn.center=CGPointMake(self.bounds.size.width-50, 50);
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


