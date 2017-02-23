//
//  HomeScreen.m
//  MeanWiseUX
//
//  Created by Hardik on 17/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "HomeScreen.h"

@implementation HomeScreen


-(void)hideBottomBar
{
    
    searchBtn.hidden=true;
    postBtn.hidden=true;
    exploreBtn.hidden=true;
    backBtn.hidden=true;
}
-(void)showBottomBar
{
    
    searchBtn.hidden=false;
    postBtn.hidden=false;
    exploreBtn.hidden=false;
    backBtn.hidden=false;
    
}
-(void)setUp
{
    

    masterControl=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:masterControl];
    [masterControl setContentSize:CGSizeMake(self.frame.size.width*3,0)];
    masterControl.pagingEnabled=true;
    masterControl.showsHorizontalScrollIndicator=false;
    masterControl.showsVerticalScrollIndicator=false;
    
    
    homeComp=[[HomeComponent alloc] initWithFrame:CGRectMake(self.frame.size.width,0, self.frame.size.width, self.frame.size.height)];
    [homeComp setUp];
    [masterControl addSubview:homeComp];
    [homeComp setTarget:self andHide:@selector(hideBottomBar) andShow:@selector(showBottomBar)];
    
    
    exploreComp=[self createExploreComponent];
    [exploreComp setUp];
    [exploreComp setTarget:self andHide:@selector(hideBottomBar) andShow:@selector(showBottomBar)];
    [masterControl addSubview:exploreComp];
    exploreComp.clipsToBounds=YES;

    searchComp=[self createSearchComponent];
    [masterControl addSubview:searchComp];
    [searchComp setUp];
    [searchComp setTarget:self andHide:@selector(hideBottomBar) andShow:@selector(showBottomBar)];
    searchComp.clipsToBounds=YES;

    
    [masterControl setContentOffset:CGPointMake(self.frame.size.width,0)];
    masterControl.delegate=self;
    
    
    
    
    searchBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [searchBtn setShowsTouchWhenHighlighted:YES];
    [searchBtn addTarget:self action:@selector(searchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"SearchIcon.png"] forState:UIControlStateNormal];
    [self addSubview:searchBtn];
    
    postBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [postBtn setShowsTouchWhenHighlighted:YES];
    [postBtn addTarget:self action:@selector(newPostBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [postBtn setBackgroundImage:[UIImage imageNamed:@"PostIcon.png"] forState:UIControlStateNormal];
    [self addSubview:postBtn];
    
    
    exploreBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [exploreBtn setShowsTouchWhenHighlighted:YES];
    [exploreBtn addTarget:self action:@selector(exploreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [exploreBtn setBackgroundImage:[UIImage imageNamed:@"GogglesIcon.png"] forState:UIControlStateNormal];
    [self addSubview:exploreBtn];
    
    backBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23*1.5, 16*1.5)];
    [backBtn setShowsTouchWhenHighlighted:YES];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackButton.png"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    backBtn.alpha=0;
    
    
    postBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-40);
    exploreBtn.center=CGPointMake(self.bounds.size.width/2-100, self.bounds.size.height-40);
    searchBtn.center=CGPointMake(self.bounds.size.width/2+100, self.bounds.size.height-40);
    backBtn.center=CGPointMake(self.bounds.size.width/2-100, self.bounds.size.height-40);
    masterControl.center=CGPointMake(self.frame.size.width*0.5, self.frame.size.height/2);

    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSLog(@"%f",scrollView.contentOffset.x);
    

    float screenWidth=self.frame.size.width;

    if(scrollView.contentOffset.x>screenWidth*2)
    {
        float extraPara=(scrollView.contentOffset.x-screenWidth*2)/screenWidth;
        
//        exploreBtn.alpha=0;
//        postBtn.alpha=1*(1-extraPara);
//        searchBtn.alpha=0;
//        backBtn.alpha=1;
//        backBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-40);
//

        
    }
    else if(scrollView.contentOffset.x>screenWidth)
    {
        float extraPara=(scrollView.contentOffset.x-screenWidth)/screenWidth;

        
        exploreBtn.alpha=1*(1-extraPara);
        postBtn.alpha=1*(1-extraPara);
        searchBtn.alpha=1*(1-extraPara);
        backBtn.alpha=1*extraPara;
        
        
        backBtn.center=CGPointMake(self.bounds.size.width/2-100+(100*extraPara), self.bounds.size.height-40);
        
       // backBtn.center=CGPointMake(self.bounds.size.width/2-100, self.bounds.size.height-40);
        //backBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-40);

    }
    else
    {
        float extraPara=(scrollView.contentOffset.x)/screenWidth;

        exploreBtn.alpha=1*extraPara;
        backBtn.alpha=1*(1-extraPara);

         backBtn.center=CGPointMake(self.bounds.size.width/2-(100*(1-extraPara)), self.bounds.size.height-40);

    }
    
    
}

-(void)newPostBtnClicked:(UIButton *)sender
{
    
    
    [Constant setStatusBarColorWhite:false];
    
    NewPostComponent *cont=[[NewPostComponent alloc] initWithFrame:self.bounds];
    [self addSubview:cont];
    [cont setUpWithCellRect:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
    
}

-(void)exploreBtnClicked:(UIButton *)sender
{
    [Constant setStatusBarColorWhite:YES];
    

    

    [UIView animateWithDuration:0.4 animations:^{
        
        [masterControl setContentOffset:CGPointMake(0,0)];

                backBtn.alpha=1;
                exploreBtn.alpha=0;

        }
     completion:^(BOOL finished)
     {
         
     }];
    
//
//    [UIView animateWithDuration:0.4 animations:^{
//        
//        masterControl.center=CGPointMake(self.frame.size.width*1.5, self.frame.size.height/2);
//        backBtn.alpha=1;
//        exploreBtn.alpha=0;
//        
//        
//        
//    } completion:^(BOOL finished) {
//        
//    }];
    
    
}
-(void)backBtnClicked:(id)sender
{

    [Constant setStatusBarColorWhite:true];

    [UIView animateWithDuration:0.4 animations:^{
        
        [masterControl setContentOffset:CGPointMake(self.frame.size.width,0)];
        
        backBtn.alpha=1;
        exploreBtn.alpha=0;
        
        backBtn.alpha=0;
        exploreBtn.alpha=1;
        postBtn.alpha=1;
        searchBtn.alpha=1;
        backBtn.center=CGPointMake(self.bounds.size.width/2-100, self.bounds.size.height-40);

        
    }
                     completion:^(BOOL finished)
     {
         
     }];
   
    
}


-(void)searchBtnClicked:(UIButton *)sender
{
    [Constant setStatusBarColorWhite:YES];

    
    [UIView animateWithDuration:0.4 animations:^{
        
        [masterControl setContentOffset:CGPointMake(self.frame.size.width*2,0)];

        backBtn.alpha=0;
        exploreBtn.alpha=0;
        postBtn.alpha=0;
        searchBtn.alpha=0;
        backBtn.alpha=1;
        backBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-40);
        
        
    } completion:^(BOOL finished) {
        
        
    }];
    
}



-(ExploreComponent *)createExploreComponent
{
    
    return [[ExploreComponent alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
}
-(SearchComponent *)createSearchComponent
{
    
    return [[SearchComponent alloc] initWithFrame:CGRectMake(self.frame.size.width*2,0, self.frame.size.width, self.frame.size.height)];
}
@end

/*
 //
 //  HomeScreen.m
 //  MeanWiseUX
 //
 //  Created by Hardik on 17/12/16.
 //  Copyright © 2016 Hardik. All rights reserved.
 //
 
 #import "HomeScreen.h"
 
 @implementation HomeScreen
 
 
 -(void)hideBottomBar
 {
 
 searchBtn.hidden=true;
 postBtn.hidden=true;
 exploreBtn.hidden=true;
 backBtn.hidden=true;
 }
 -(void)showBottomBar
 {
 
 searchBtn.hidden=false;
 postBtn.hidden=false;
 exploreBtn.hidden=false;
 backBtn.hidden=false;
 
 }
 -(void)setUp
 {
 
 
 masterControl=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*3, self.frame.size.height)];
 [self addSubview:masterControl];
 
 
 homeComp=[[HomeComponent alloc] initWithFrame:CGRectMake(self.frame.size.width,0, self.frame.size.width, self.frame.size.height)];
 [homeComp setUp];
 [masterControl addSubview:homeComp];
 [homeComp setTarget:self andHide:@selector(hideBottomBar) andShow:@selector(showBottomBar)];
 
 
 
 //    searchComp=[[SearchComponent alloc] initWithFrame:CGRectMake(self.frame.size.width*2,0, self.frame.size.width, self.frame.size.height)];
 //    [masterControl addSubview:searchComp];
 //    [searchComp setUp];
 //    searchComp.clipsToBounds=YES;
 //
 //
 //
 //    exploreComp=[[ExploreComponent alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
 //    [masterControl addSubview:exploreComp];
 //    [exploreComp setUp];
 //    exploreComp.clipsToBounds=YES;
 
 searchComp=nil;
 exploreBtn=nil;
 
 
 searchBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
 [searchBtn setShowsTouchWhenHighlighted:YES];
 [searchBtn addTarget:self action:@selector(searchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
 [searchBtn setBackgroundImage:[UIImage imageNamed:@"SearchIcon.png"] forState:UIControlStateNormal];
 [self addSubview:searchBtn];
 
 postBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
 [postBtn setShowsTouchWhenHighlighted:YES];
 [postBtn addTarget:self action:@selector(newPostBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
 [postBtn setBackgroundImage:[UIImage imageNamed:@"PostIcon.png"] forState:UIControlStateNormal];
 [self addSubview:postBtn];
 
 
 exploreBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
 [exploreBtn setShowsTouchWhenHighlighted:YES];
 [exploreBtn addTarget:self action:@selector(exploreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
 [exploreBtn setBackgroundImage:[UIImage imageNamed:@"GogglesIcon.png"] forState:UIControlStateNormal];
 [self addSubview:exploreBtn];
 
 backBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23*1.5, 16*1.5)];
 [backBtn setShowsTouchWhenHighlighted:YES];
 [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
 [backBtn setBackgroundImage:[UIImage imageNamed:@"BackButton.png"] forState:UIControlStateNormal];
 [self addSubview:backBtn];
 backBtn.alpha=0;
 
 
 postBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-40);
 exploreBtn.center=CGPointMake(self.bounds.size.width/2-100, self.bounds.size.height-40);
 searchBtn.center=CGPointMake(self.bounds.size.width/2+100, self.bounds.size.height-40);
 backBtn.center=CGPointMake(self.bounds.size.width/2-100, self.bounds.size.height-40);
 
 masterControl.center=CGPointMake(self.frame.size.width*0.5, self.frame.size.height/2);
 
 
 }
 -(ExploreComponent *)createExploreComponent
 {
 
 return [[ExploreComponent alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
 }
 -(SearchComponent *)createSearchComponent
 {
 
 return [[SearchComponent alloc] initWithFrame:CGRectMake(self.frame.size.width*2,0, self.frame.size.width, self.frame.size.height)];
 }
 
 -(void)backBtnClicked:(id)sender
 {
 
 
 
 [UIView animateWithDuration:0.4 animations:^{
 
 masterControl.center=CGPointMake(self.frame.size.width*0.5, self.frame.size.height/2);
 backBtn.alpha=0;
 exploreBtn.alpha=1;
 postBtn.alpha=1;
 searchBtn.alpha=1;
 backBtn.center=CGPointMake(self.bounds.size.width/2-100, self.bounds.size.height-40);
 
 
 } completion:^(BOOL finished) {
 
 [Constant setStatusBarColorWhite:true];
 
 if(searchComp!=nil)
 {
 [[searchComp subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
 
 [searchComp removeFromSuperview];
 searchComp=nil;
 }
 if(exploreComp!=nil)
 {
 [[exploreComp subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
 
 [exploreComp removeFromSuperview];
 exploreComp=nil;
 }
 
 }];
 
 
 }
 -(void)newPostBtnClicked:(UIButton *)sender
 {
 
 
 [Constant setStatusBarColorWhite:false];
 
 NewPostComponent *cont=[[NewPostComponent alloc] initWithFrame:self.bounds];
 [self addSubview:cont];
 [cont setUpWithCellRect:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
 
 }
 -(void)exploreBtnClicked:(UIButton *)sender
 {
 [Constant setStatusBarColorWhite:YES];
 
 exploreComp=[self createExploreComponent];
 [exploreComp setUp];
 [exploreComp setTarget:self andHide:@selector(hideBottomBar) andShow:@selector(showBottomBar)];
 
 [masterControl addSubview:exploreComp];
 exploreComp.clipsToBounds=YES;
 
 [UIView animateWithDuration:0.4 animations:^{
 
 masterControl.center=CGPointMake(self.frame.size.width*1.5, self.frame.size.height/2);
 backBtn.alpha=1;
 exploreBtn.alpha=0;
 
 
 
 } completion:^(BOOL finished) {
 
 }];
 
 
 }
 
 -(void)searchBtnClicked:(UIButton *)sender
 {
 [Constant setStatusBarColorWhite:YES];
 
 searchComp=[self createSearchComponent];
 [masterControl addSubview:searchComp];
 [searchComp setUp];
 [searchComp setTarget:self andHide:@selector(hideBottomBar) andShow:@selector(showBottomBar)];
 
 searchComp.clipsToBounds=YES;
 
 [UIView animateWithDuration:0.4 animations:^{
 
 masterControl.center=CGPointMake(-self.frame.size.width*0.5, self.frame.size.height/2);
 backBtn.alpha=0;
 exploreBtn.alpha=0;
 postBtn.alpha=0;
 searchBtn.alpha=0;
 backBtn.alpha=1;
 backBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-40);
 
 
 } completion:^(BOOL finished) {
 
 if(exploreComp!=nil)
 {
 [exploreComp removeFromSuperview];
 exploreComp=nil;
 }
 
 }];
 
 }
 
 @end
*/