//
//  WalkthroughControl.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "WalkthroughControl.h"

@implementation WalkthroughControl
-(void)setTarget:(id)target andFunc1:(SEL)func;
{
    delegate=target;
    skipButtonClickedFunc=func;
    
}
-(void)setTarget:(id)target andFunc01:(SEL)func
{
    delegate=target;
    func1=func;

}
-(void)setTarget:(id)target andFunc02:(SEL)func
{
    delegate=target;
    func2=func;

}
-(void)setUp
{
    self.backgroundColor=[UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:1.00];
    
    CGRect scrollViewFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame] ;
    scrollView.delegate = self;
    scrollView.backgroundColor=[UIColor clearColor];
    [self addSubview:scrollView];
    
    [scrollView setPagingEnabled:YES];
    scrollView.showsHorizontalScrollIndicator = NO;
    
    
    CGSize scrollViewContentSize = CGSizeMake(self.frame.size.width*4, 0);
    [scrollView setContentSize:scrollViewContentSize];
    
    NSArray *titleArray=[NSArray arrayWithObjects:@"GET TO BE YOURSELF",@"FIT WHERE YOU BELONG",@"INSTANT JOB APPLICATION", nil];
    NSArray *detailArray=[NSArray arrayWithObjects:
                          @"Everyone has their own story to tell. Create your own unique identity and connect with friends. Let your story be discovered by the world.",
                          @"Share your ideas with like-minded people. Create and engage in conversations you care about and boost your chances of being discovered by potential employers.",
                          @"Say goodbye to your old-fashined resume. Apply for the job you want in seconds.", nil];
    
    
    for(int i=0;i<3;i++)
    {
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [scrollView addSubview:view];
        
        view.center=CGPointMake(self.frame.size.width*i+self.frame.size.width/2, (self.frame.size.height)/2);
        
        
        /* UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width*0.78, view.frame.size.width)];
         imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"D%d",i+1]];
         [view addSubview:imageView];
         imageView.layer.cornerRadius=10;
         imageView.clipsToBounds=YES;
         */
        
        
        
        
        UILabel *titleLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height*0.67, self.frame.size.width, 20)];
        [view addSubview:titleLBL];
        titleLBL.textAlignment=NSTextAlignmentCenter;
        titleLBL.text=[titleArray objectAtIndex:i];
        titleLBL.numberOfLines=1;
        titleLBL.textColor=[UIColor whiteColor];
        [titleLBL setFont:[UIFont fontWithName:k_fontExtraBold size:17]];
        
        
        UILabel *titleLBL2=[[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.height*0.67+20, self.frame.size.width-40,100)];
        [view addSubview:titleLBL2];
        titleLBL2.textAlignment=NSTextAlignmentCenter;
        titleLBL2.text=[detailArray objectAtIndex:i];
        titleLBL2.numberOfLines=4;
        titleLBL2.textColor=[UIColor whiteColor];
        [titleLBL2 setFont:[UIFont fontWithName:k_fontRegular size:15]];
        
        
        
        
    }
    
    component=[[LoginComponent alloc] initWithFrame:CGRectMake(3*self.frame.size.width, -20, self.frame.size.width, self.frame.size.height)];
    [component setUp];
    [scrollView addSubview:component];
    [component setTarget:self andFunc1:@selector(func1Clicked:)];
    [component setTarget:self andFunc2:@selector(func2Clicked:)];

    
    skipBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-100, 20, 100, 50)];
    [skipBtn addTarget:self action:@selector(skipButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [skipBtn setTitle:@"SKIP" forState:UIControlStateNormal];
    [skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [skipBtn setShowsTouchWhenHighlighted:YES];
    skipBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:13];

   // [skipBtn setBackgroundImage:[UIImage imageNamed:@"SkipButton.png"] forState:UIControlStateNormal];
    [self addSubview:skipBtn];
    
    
    
    
    
    pageControl = [[UIPageControl alloc] init] ;
    pageControl.frame = CGRectMake(0,0,50,100);
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    [self addSubview:pageControl];
    pageControl.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-50);
    

}
-(void)func1Clicked:(id)sender
{
    [delegate performSelector:func1 withObject:nil afterDelay:0.1];

}
-(void)func2Clicked:(id)sender
{
    [delegate performSelector:func2 withObject:nil afterDelay:0.1];
   
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
    
    if(fractionalPage>2)
    {
        float alpha=fractionalPage-2;
        alpha=alpha*2;
        
        if(alpha<=1)
        {
            skipBtn.alpha=1-alpha;
            pageControl.alpha=1-alpha;
            skipBtn.hidden=true;
        }
       

    }
    else
    {
        skipBtn.hidden=false;
        pageControl.hidden=false;
        skipBtn.alpha=1;
        pageControl.hidden=false;
    }
    
    
}
@end
