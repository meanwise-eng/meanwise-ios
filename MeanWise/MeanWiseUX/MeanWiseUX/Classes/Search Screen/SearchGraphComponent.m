//
//  SearchGraphComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 02/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "SearchGraphComponent.h"
#import "APIManager.h"
#import "DataSession.h"
#import "APIObjectsParser.h"
#import "Constant.h"
@implementation SearchGraphComponent

-(void)setUp
{

    isSearchBtnInside=true;
    UIImageView *bgImage;
    
    bgImage=[[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:bgImage];
    bgImage.image=[UIImage imageNamed:@"pqr6.jpg"];

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:blurEffectView];
    
    cControl=[[CircularGraphManager alloc] initWithFrame:self.bounds];
    [self addSubview:cControl];
    [cControl setUp];
    [cControl setTarget:self onScroll:@selector(onCContronScroll:)];
    
    
//    searchBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    [scro addSubview:searchBtn];
//    searchBtn.center=self.center;
//    searchBtn.backgroundColor=[UIColor colorWithWhite:1 alpha:0.5];
//    searchBtn.layer.cornerRadius=50/2;
    
    
  
    [self setAllElements];
    
    isSearchBoxEditMode=false;
    [self refreshAction];

    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture:)];
    
    [self addGestureRecognizer:gesture];

    
    statusLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 25)];
    [self addSubview:statusLabel];
    statusLabel.textAlignment=NSTextAlignmentCenter;
    statusLabel.font=[UIFont fontWithName:k_fontBold size:18];
    statusLabel.text=@"Search";
    statusLabel.textColor=[UIColor whiteColor];
    
    miniStatusLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 45, self.frame.size.width, 15)];
    [self addSubview:miniStatusLabel];
    miniStatusLabel.textAlignment=NSTextAlignmentCenter;
    miniStatusLabel.font=[UIFont fontWithName:k_fontBold size:12];
    miniStatusLabel.text=@"Featured";
    miniStatusLabel.textColor=[UIColor whiteColor];
    
    errorMessageLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 45, self.frame.size.width, 15)];
    [self addSubview:errorMessageLBL];
    errorMessageLBL.textAlignment=NSTextAlignmentCenter;
    errorMessageLBL.font=[UIFont fontWithName:k_fontBold size:12];
    errorMessageLBL.text=@"Nothing to Display";
    errorMessageLBL.textColor=[UIColor whiteColor];
    errorMessageLBL.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-150);
 
    errorMessageLBL.hidden=true;
    
}
-(void)gesture:(UITapGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateRecognized && isSearchBoxEditMode==true)
    {
        CGPoint point = [recognizer locationInView:recognizer.view];
        
        if(point.y<self.frame.size.height)
        {
            [self searchCancelBtnClicked:nil];
        }
       
    }
    
}
-(void)onCContronScroll:(NSValue *)pointValue
{
    if(isSearchBoxEditMode==false)
    {
        CGPoint point=[pointValue CGPointValue];
        point=CGPointMake(self.center.x-point.x, self.center.y-point.y);
        CGRect pointRect=CGRectMake(point.x-25, point.y-25, 50, 50);
        
        
        if(CGRectContainsRect(self.bounds, pointRect))
        {
            
            if(isSearchBtnInside==false)
            {
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    searchBtn.center=point;

                }];

            }
            else
            {
                searchBtn.center=point;

            }
            
            
            isSearchBtnInside=true;
            

            
        }
        else
        {
            if(isSearchBtnInside==true)
            {
                
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    searchBtn.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-50);

                    
                }];
            }
            else
            {
                searchBtn.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-50);

            }
            
            isSearchBtnInside=false;

            
        }
    }
}

-(void)setComponentState_SearchProcess
{
    [self setHiddenAnimated:searchBox withFlag:YES];
    [self setHiddenAnimated:searchBtn withFlag:YES];
    [self setHiddenAnimated:loaderView withFlag:false];

    
    
}
-(void)setComponentState_SearchEdit
{
    [self setHiddenAnimated:searchBox withFlag:false];
    [self setHiddenAnimated:searchBtn withFlag:false];
    [self setHiddenAnimated:loaderView withFlag:true];
    
    
}
-(void)setComponentState_SearchResult
{
    
    [self setHiddenAnimated:searchBox withFlag:true];
    [self setHiddenAnimated:searchBtn withFlag:false];
    [self setHiddenAnimated:loaderView withFlag:true];
    
    if([DataSession sharedInstance].searchUserResults.count!=0)
    {
        errorMessageLBL.hidden=true;
    }
    else
    {
        errorMessageLBL.hidden=false;
    }
    
}

#pragma mark - Events

-(void)searchBtnClicked:(id)sender
{
    if(isSearchBoxEditMode==false)
    {
        isSearchBoxEditMode=true;
        [self setComponentState_SearchEdit];
        [cControl setSearchMode:true];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            searchBox.bounds=CGRectMake(0, 0, 250, 50);
            searchBox.center=self.center;
            
            searchBtn.center=CGPointMake(self.center.x+250/2+25,self.center.y);
            
            
        } completion:^(BOOL finished) {
           
            [searchBox becomeFirstResponder];
        }];
    }
    else
    {
        miniStatusLabel.text=[NSString stringWithFormat:@"'%@'",searchBox.text];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            searchBox.bounds=CGRectMake(0, 0, 50, 50);
            searchBox.center=self.center;
            
            searchBtn.center=CGPointMake(self.center.x,self.center.y);
            
            
        } completion:^(BOOL finished) {
            
            [searchBox resignFirstResponder];

        }];

        [cControl setSearchMode:false];
        [cControl removeAllClear];

        isSearchBoxEditMode=false;
        [self refreshActionWithTerm:searchBox.text withType:0];
    }
}
-(void)searchCancelBtnClicked:(id)sender
{
    
            [searchBox resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        searchBox.bounds=CGRectMake(0, 0, 50, 50);
        searchBox.center=self.center;
        
        searchBtn.center=CGPointMake(self.center.x,self.center.y);
        
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    
    isSearchBoxEditMode=false;
    
    [self setComponentState_SearchResult];
    [cControl setSearchMode:false];

}

#pragma mark - API calls

-(void)refreshAction
{
    [self setComponentState_SearchProcess];
    
    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestForAllUserData:[UserSession getAccessToken] delegate:self andSelector:@selector(userFriendsReceived:)];
    
}
-(void)refreshActionWithTerm:(NSString *)term withType:(int)lastSearchType
{
    lastSearchType=1;
    
    NSString *paramKey;
    
    if(lastSearchType==0)
    {
        paramKey=@"username__contains";
        
    }
    else
    {
        paramKey=@"skills_text__contains";
        
    }
    
    
    
    NSDictionary *dict=@{@"paramKey":paramKey,@"searchTerm":searchBox.text};
    
    [self searchAPI:dict];

}
-(void)searchAPI:(NSDictionary *)dict
{
    [self setComponentState_SearchProcess];

    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestForUserSearch:dict delegate:self andSelector:@selector(userFriendsReceived:)];
    

    
    
}
-(void)userFriendsReceived:(APIResponseObj *)responseObj
{


    if([responseObj.response isKindOfClass:[NSArray class]])
    {

        NSArray *arrayTemp=(NSArray *)responseObj.response;
        APIObjectsParser *parser=[[APIObjectsParser alloc] init];
        [DataSession sharedInstance].searchUserResults=[NSMutableArray arrayWithArray:[parser parseObjects_PROFILES:arrayTemp]];
        
        [cControl addNewObjects:[NSArray arrayWithArray:[DataSession sharedInstance].searchUserResults]];
        
        [self setComponentState_SearchResult];

    }
  
}
#pragma mark - States




#pragma mark - Helper
-(void)setHiddenAnimated:(UIView *)view withFlag:(BOOL)flag
{
    if(flag==true)
    {
        if([view isKindOfClass:[UIActivityIndicatorView class]])
        {
            [((UIActivityIndicatorView *)view) stopAnimating];
        }
        if([view isKindOfClass:[UITextField class]])
        {
            [((UITextField *)view) setUserInteractionEnabled:false];
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            view.alpha=0;
            
        } completion:^(BOOL finished) {
            view.hidden=true;
        }];
        
        
        
    }
    else
    {
        if([view isKindOfClass:[UIActivityIndicatorView class]])
        {
            [((UIActivityIndicatorView *)view) startAnimating];
        }
        if([view isKindOfClass:[UITextField class]])
        {
            [((UITextField *)view) setUserInteractionEnabled:true];
        }
        
        view.hidden=false;
        
        [UIView animateWithDuration:0.5 animations:^{
            view.alpha=1;
            
        } completion:^(BOOL finished) {
        }];
        
        
    }
    
    
}
-(void)setAllElements
{
    loaderView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:loaderView];
    [loaderView stopAnimating];
    
    searchBox=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:searchBox];
    searchBox.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
    searchBox.clipsToBounds=YES;
    searchBox.layer.cornerRadius=25;
    searchBox.returnKeyType=UIReturnKeySearch;
    searchBox.keyboardAppearance=UIKeyboardAppearanceDark;
    searchBox.inputAccessoryView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    searchBox.textAlignment=NSTextAlignmentCenter;
    searchBox.font=[UIFont fontWithName:k_fontBold size:18];
    searchBox.textColor=[UIColor colorWithWhite:1 alpha:0.8];
    searchBox.tintColor=[UIColor whiteColor];

    
    searchBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50,50)];
    [self addSubview:searchBtn];
    searchBtn.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.5f];
    searchBtn.layer.cornerRadius=25;
    [searchBtn setImage:[UIImage imageNamed:@"ChannelSearchIcon.png"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 15, 15, 15)];

    
    

    
    
    
    searchBox.hidden=true;
    searchBox.alpha=0;
    searchBox.center=self.center;
    
    loaderView.hidden=true;
    loaderView.alpha=0;
    loaderView.center=self.center;
    
    searchBtn.hidden=true;
    searchBtn.alpha=0;
    searchBtn.center=self.center;
 
    
    
}


@end
