//
//  TutorialComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "TutorialComponent.h"

@implementation TutorialComponent

-(void)setTarget:(id)target andDoneBtnCallBack:(SEL)func;
{
    delegate=target;
    skipButtonClickedFunc=func;
    
}
-(void)setUp
{
    
    numberOfItems=5;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:blurEffectView];
    
    CGRect scrollViewFrame = CGRectMake(0, 0, self.frame.size.width*0.7, self.frame.size.height*0.7);
    scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame] ;
    scrollView.delegate = self;
    scrollView.backgroundColor=[UIColor whiteColor];
    [self addSubview:scrollView];
    
    [scrollView setPagingEnabled:YES];
    scrollView.showsHorizontalScrollIndicator = NO;
    
    scrollView.layer.cornerRadius=4;
    scrollView.clipsToBounds=YES;
    
    CGSize scrollViewContentSize = CGSizeMake(self.frame.size.width*0.7*numberOfItems, 0);
    [scrollView setContentSize:scrollViewContentSize];
    
    
//    NSArray *titleArray=[NSArray arrayWithObjects:@"Home",@"Camera",@"Profile",@"Explore",@"Discover", nil];
//    
//    NSArray *detailArray=[NSArray arrayWithObjects:
//                          
//                          @"Your Homefeed contains content people have posted in the Channels of Interests that you subscribed to when you signed up. Swipe up and down to view them!",
//                          
//                          @"Use the camera button to capture a video or image of what you are working on, pick a channel, attach to a topic and post!",
//                          
//                          @"Tap the Meanwise Icon on top to access your profile. Add a cool Cover Photo, Profile Photo, Intro and a Story to increase you Profile’s visibility and standout from there rest!",
//                          
//                          @"The Explore button takes you to the Channels of Interest that you subscribed to when signing up. View and Interact with amazing content people like you are posting there!",
//                          
//                          @"Discover lets you Search Find talented people like yourself who are on Meanwise. You could stumble on your future business partner, co-founder or client here!",
//                          
//                          
//                          nil];
    
    
    scrollView.center=self.center;
    
    
    for(int i=0;i<numberOfItems;i++)
    {
        //
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(scrollViewFrame.size.width*i, 0, scrollViewFrame.size.width,  scrollViewFrame.size.height)];
        [scrollView addSubview:view];
        
        
        view.backgroundColor=[UIColor colorWithWhite:i*0.2 alpha:1];
        view.backgroundColor=[UIColor whiteColor];
        
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,scrollViewFrame.size.width, scrollViewFrame.size.height-20)];
        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"Tutorial-page-%d.jpg",i+1]];
        [view addSubview:imageView];
        imageView.clipsToBounds=YES;
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        
        
        
        
        //        UILabel *titleLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, scrollViewFrame.size.height/2, scrollViewFrame.size.width, 30)];
        //        [view addSubview:titleLBL];
        //        titleLBL.textAlignment=NSTextAlignmentCenter;
        //        titleLBL.font=[UIFont fontWithName:@"Avenir-Roman" size:18];;
        //        titleLBL.textColor=[UIColor blackColor];
        //        titleLBL.text=[titleArray objectAtIndex:i];
        //
        //
        //        UILabel *descLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, scrollViewFrame.size.height/2+30, scrollViewFrame.size.width, scrollViewFrame.size.height/2-30)];
        //        [view addSubview:descLBL];
        //        descLBL.textAlignment=NSTextAlignmentCenter;
        //        descLBL.font=[UIFont fontWithName:@"Avenir-Roman" size:13];;
        //        descLBL.textColor=[UIColor blackColor];
        //        descLBL.text=[detailArray objectAtIndex:i];
        //        descLBL.numberOfLines=0;
        //
        
        
    }
    
    UILabel *pageTitleLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 50)];
    
    [pageTitleLBL setText:@"GETTING STARTED"];
    pageTitleLBL.font=[UIFont fontWithName:@"Avenir-Roman" size:15];;
    pageTitleLBL.textColor=[UIColor whiteColor];
    pageTitleLBL.textAlignment=NSTextAlignmentCenter;
    [self addSubview:pageTitleLBL];
    
    skipBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height-60, 40, 40)];
    [skipBtn addTarget:self action:@selector(skipButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [skipBtn setBackgroundImage:[UIImage imageNamed:@"MX_cCloseBtn.png"] forState:UIControlStateNormal];
  //  [skipBtn setTitle:@"CLOSE" forState:UIControlStateNormal];
    [skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [skipBtn setShowsTouchWhenHighlighted:YES];
    skipBtn.titleLabel.font=[UIFont fontWithName:@"Avenir-Roman" size:13];
    [self addSubview:skipBtn];
    
    skipBtn.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-30);
    
    
    
    
    pageControl = [[UIPageControl alloc] init] ;
    pageControl.frame = CGRectMake(0,0,50,40);
    pageControl.numberOfPages = numberOfItems;
    pageControl.currentPage = 0;
    [self addSubview:pageControl];
    pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:1.00];
    pageControl.pageIndicatorTintColor=[UIColor lightGrayColor];
    pageControl.center=CGPointMake(self.frame.size.width/2, self.frame.size.height*0.85-20);

    
}


-(void)skipButtonClicked:(id)sender
{
    
    [delegate performSelector:skipButtonClickedFunc withObject:nil afterDelay:0.1];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView1{
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page;
    
   
    
}
@end
