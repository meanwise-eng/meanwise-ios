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
#import "ProfileWindowControl.h"
#import "UIColor+Hexadecimal.h"

@implementation SearchGraphComponent

-(void)setTarget:(id)targetReceived onCloseFunc:(SEL)func;
{
    target=targetReceived;
    onCloseFunc=func;
    
}
-(void)closeBtnClicked:(id)sender
{
    [target performSelector:onCloseFunc withObject:nil afterDelay:0.01];
}
-(void)setUp
{

    userMainData=[[NSMutableArray alloc] init];
    
    searchType=0;
    isSearchBtnInside=true;
    
//    UIImageView *bgImage;
//    bgImage=[[UIImageView alloc] initWithFrame:self.bounds];
//    [self addSubview:bgImage];
//    bgImage.image=[UIImage imageNamed:@"pqr6.jpg"];

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:blurEffectView];
    
    cControl=[[CircularGraphManager alloc] initWithFrame:self.bounds];
    [self addSubview:cControl];
    [cControl setUp];
    [cControl setTarget:self onScroll:@selector(onCContronScroll:) andOnUserTap:@selector(onUserTap:) andLongTap:@selector(longTap:)];
    
    
//    searchBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    [scro addSubview:searchBtn];
//    searchBtn.center=self.center;
//    searchBtn.backgroundColor=[UIColor colorWithWhite:1 alpha:0.5];
//    searchBtn.layer.cornerRadius=50/2;
    
    
  
    [self setAllElements];
    
    isSearchBoxEditMode=false;

    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture:)];
    [self addGestureRecognizer:gesture];

    
    
    statusLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 25)];
    [self addSubview:statusLabel];
    statusLabel.textAlignment=NSTextAlignmentCenter;
    statusLabel.font=[UIFont fontWithName:k_fontBold size:18];
    statusLabel.text=@"Search";
    statusLabel.textColor=[UIColor whiteColor];
    
    miniStatusLabel=[[UIButton alloc] initWithFrame:CGRectMake(0, 45, self.frame.size.width, 15)];
    [self addSubview:miniStatusLabel];
    
    miniStatusLabel.titleLabel.font=[UIFont fontWithName:k_fontBold size:12];
    [miniStatusLabel setTitle:@"Featured" forState:UIControlStateNormal];
    [miniStatusLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    errorMessageLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 45, self.frame.size.width, 15)];
    [self addSubview:errorMessageLBL];
    errorMessageLBL.textAlignment=NSTextAlignmentCenter;
    errorMessageLBL.font=[UIFont fontWithName:k_fontBold size:12];
    errorMessageLBL.text=@"Nothing to Display";
    errorMessageLBL.textColor=[UIColor whiteColor];
    errorMessageLBL.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-150);
 
    errorMessageLBL.hidden=true;
    
    resetSearch=[[UIButton alloc] initWithFrame:CGRectMake(10, 30, 70, 25)];
    [resetSearch setShowsTouchWhenHighlighted:YES];
    [resetSearch addTarget:self action:@selector(resetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [resetSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resetSearch setTitle:@"CLEAR" forState:UIControlStateNormal];
    resetSearch.titleLabel.font=[UIFont fontWithName:k_fontBold size:12];
    [self addSubview:resetSearch];
    resetSearch.backgroundColor=[UIColor colorWithWhite:1 alpha:0.4];
    resetSearch.clipsToBounds=YES;
    resetSearch.layer.cornerRadius=4;
    resetSearch.hidden=true;

    
    closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 60, 40, 40)];
    [closeBtn setShowsTouchWhenHighlighted:YES];
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [self addSubview:closeBtn];
    
    closeBtn.center=CGPointMake(self.frame.size.width-10-25/2, 20+65/2-10);


    if([DataSession sharedInstance].searchUserResults.count==0)
    {
        [self refreshAction];
    }
    else
    {
        userMainData=[DataSession sharedInstance].searchUserResults;
        [cControl addNewObjects:[NSArray arrayWithArray:userMainData]];
        [self setComponentState_SearchResult];
    }
    
    
    quickLookView=[[ProfileQuickLookView alloc] initWithFrame:self.bounds];
    [self addSubview:quickLookView];
    [quickLookView setUp];
    [quickLookView setTarget:self onTap:@selector(closeQuickLookControl:)];

}
-(void)closeQuickLookControl:(id)sender
{
    [cControl makeAllVisible];
    
}
-(void)resetBtnClicked:(id)sender
{
    [miniStatusLabel setTitle:@"Featured" forState:UIControlStateNormal];
    [cControl removeAllClear];

    resetSearch.hidden=true;
    [self refreshAction];
    
}
-(void)longTap:(NSArray *)array
{
    NSString *userId=[array objectAtIndex:0];
    CGRect objectRect=[[array objectAtIndex:1] CGRectValue];
    
    NSLog(@"%@",userId);
    
    for(int i=0;i<userMainData.count;i++)
    {
        APIObjects_ProfileObj *obj=[userMainData objectAtIndex:i];
        
        if([[NSString stringWithFormat:@"%@",obj.userId] isEqualToString:[NSString stringWithFormat:@"%@",userId]])
        {
            NSLog(@"%@",obj.first_name);
            
            [quickLookView assignData:obj withFrame:objectRect];
            
            //  [self openProfile:obj withFrame:objectRect];
            break;
        }
        
    }
}
-(void)onUserTap:(NSArray *)array
{

    NSString *userId=[array objectAtIndex:0];
    CGRect objectRect=[[array objectAtIndex:1] CGRectValue];

    NSLog(@"%@",userId);

    for(int i=0;i<userMainData.count;i++)
    {
        APIObjects_ProfileObj *obj=[userMainData objectAtIndex:i];

        if([[NSString stringWithFormat:@"%@",obj.userId] isEqualToString:[NSString stringWithFormat:@"%@",userId]])
        {

            NSLog(@"%@",obj.first_name);
            
            //[quickLookView assignData:obj];
            
           [self openProfile:obj withFrame:objectRect];
            break;
        }
        
    }

}
-(void)openProfile:(APIObjects_ProfileObj *)obj withFrame:(CGRect)frame
{
    NSDictionary *dict=@{@"cover_photo":obj.cover_photo,@"user_id":obj.userId};
    
    
    ProfileWindowControl *control=[[ProfileWindowControl alloc] init];
    [control setUp:dict andSourceFrame:frame];
    [control setTarget:self onClose:@selector(backFromProfile:)];
    
}
-(void)backFromProfile:(id)sender
{
    [cControl makeAllVisible];
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
    
    if(userMainData.count!=0)
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
        resetSearch.hidden=true;

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
        [miniStatusLabel setTitle:[NSString stringWithFormat:@"'%@'",searchBox.text] forState:UIControlStateNormal];

        resetSearch.hidden=false;
        
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
    if(searchType!=0)
    {
        resetSearch.hidden=false;

    }
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
    searchType=0;
    [self setComponentState_SearchProcess];
    
    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestForAllUserData:[UserSession getAccessToken] delegate:self andSelector:@selector(futuredUsersReceived:)];
    
}
-(void)refreshActionWithTerm:(NSString *)term withType:(int)lastSearchType
{
    searchType=1;

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
    [manager sendRequestForUserSearch:dict delegate:self andSelector:@selector(searchSkillUsersReceived:)];
    

    
    
}
-(void)calculateData:(APIResponseObj *)responseObj withSearchType:(int)type
{
    if([responseObj.response isKindOfClass:[NSArray class]])
    {
        
        NSArray *arrayTemp=(NSArray *)responseObj.response;
        APIObjectsParser *parser=[[APIObjectsParser alloc] init];
        userMainData=[NSMutableArray arrayWithArray:[parser parseObjects_PROFILES:arrayTemp]];
       
        if(type==0)
        {
        [DataSession sharedInstance].searchUserResults=[[NSMutableArray alloc] initWithArray:userMainData];
        }
        
        [cControl addNewObjects:[NSArray arrayWithArray:userMainData]];
        
        [self setComponentState_SearchResult];
        
    }
}
-(void)futuredUsersReceived:(APIResponseObj *)responseObj
{
    [self calculateData:responseObj withSearchType:0];
}
-(void)searchSkillUsersReceived:(APIResponseObj *)responseObj
{
    [self calculateData:responseObj withSearchType:1];
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
    searchBox.delegate=self;
    
    searchBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50,50)];
    [self addSubview:searchBtn];
    searchBtn.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.5f];
    searchBtn.layer.cornerRadius=25;
    [searchBtn setImage:[UIImage imageNamed:@"ChannelSearchIcon.png"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 15, 15, 15)];

    
    

    
    
    
    searchBox.hidden=true;
    searchBox.alpha=0;
    searchBox.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    loaderView.hidden=true;
    loaderView.alpha=0;
    loaderView.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    searchBtn.hidden=true;
    searchBtn.alpha=0;
    searchBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
 
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==searchBox)
    {
        [self searchBtnClicked:searchBtn];

    }
    return true;
}

@end

@implementation ProfileQuickLookView

-(void)setUp
{
    self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.0f];
    
    popUpView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height/2)];
    [self addSubview:popUpView];
    [popUpView setBackgroundColor:[UIColor darkGrayColor]];
    popUpView.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    popUpView.layer.cornerRadius=4;
    popUpView.clipsToBounds=YES;

    profilePic=[[UIImageHM alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    [self addSubview:profilePic];
    profilePic.backgroundColor=[UIColor grayColor];
    profilePic.layer.cornerRadius=35;
    profilePic.clipsToBounds=YES;
    profilePic.layer.borderWidth=2;
    profilePic.layer.borderColor=[UIColor whiteColor].CGColor;

    bioInfoLBL=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, 10)];
    [popUpView addSubview:bioInfoLBL];
    bioInfoLBL.font=[UIFont fontWithName:k_fontRegular size:14];
    bioInfoLBL.numberOfLines=0;
    bioInfoLBL.textColor=[UIColor whiteColor];

    self.hidden=true;
    
}
-(void)assignData:(APIObjects_ProfileObj *)dataObj withFrame:(CGRect)frame
{
    sourceFrame=frame;
    obj=dataObj;

//    bioTXT=@"I deliver fun, rock and crowd, whatever is needed.";
//     locationTXT=@"Columbia, MD";
//    subBioTXT=@"I have always sought out fun, but never truly realized how powerful it could be. Then one dance changed my life. My goal is to eventually bring smiles to the world and help take my fun worldwide.";
//    [profilePic setUp:@"http://ec2-34-228-26-196.compute-1.amazonaws.com/media/profile_photo_thumbs/profile_photo_ARLJjcj_ZfaiUrM_SwMNIxM_2qu36Wh_iyqW1CQ_w7d5MQj_4mM02_hphgB9J.jpg"];


    
    float padding=10;
    bioInfoLBL.frame=CGRectMake(0, padding+35, self.frame.size.width/2-padding*2, popUpView.frame.size.height-padding*2);
    popUpView.backgroundColor=[UIColor colorWithHexString:dataObj.profile_background_color];
    profilePic.layer.borderColor=[UIColor colorWithHexString:dataObj.profile_background_color].CGColor;

    
    NSString *bioTXT=[dataObj.bio stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    NSString *locationTXT=[dataObj.city stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    NSString *subBioTXT=[dataObj.profile_story_description stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    if([bioTXT isEqualToString:@""])
    {
        bioTXT=[NSString stringWithFormat:@"Hi! I'm %@",dataObj.first_name];
    }
    
    if([locationTXT isEqualToString:@""] && ![dataObj.profession_text isEqualToString:@""])
    {
        locationTXT=[NSString stringWithFormat:@"%@",dataObj.profession_text];
    }
    
    if([locationTXT isEqualToString:@""] && [dataObj.profession_text isEqualToString:@""])
    {
        int count=3;
        if(dataObj.skill_List.count<3)
        {
            count=(int)dataObj.skill_List.count;
        }
        
        NSString *skillsStr=[[dataObj.skill_List subarrayWithRange:NSMakeRange(0, count)] componentsJoinedByString:@" #"];
        locationTXT=[NSString stringWithFormat:@"#%@",skillsStr];


    }
    
    
    [profilePic setUp:obj.profile_photo_small];

    NSString *allInfo=[NSString stringWithFormat:@"%@",bioTXT];
    if(![locationTXT isEqualToString:@""])
    {
        allInfo=[allInfo stringByAppendingString:@"\n\n"];
        allInfo=[allInfo stringByAppendingString:locationTXT];
    }
    if(![subBioTXT isEqualToString:@""])
    {
        allInfo=[allInfo stringByAppendingString:@"\n\n"];
        allInfo=[allInfo stringByAppendingString:subBioTXT];
    }
    
    

    
    
   
    NSMutableAttributedString *goodText = [[NSMutableAttributedString alloc] initWithString:allInfo];
    
    NSRange range1 = [allInfo rangeOfString:bioTXT options:NSRegularExpressionSearch|NSCaseInsensitiveSearch];
    if (range1.location != NSNotFound) {
        [goodText addAttribute:NSFontAttributeName value:[UIFont fontWithName:k_fontBold size:14] range:range1];
    }
    
    if(![locationTXT isEqualToString:@""])
    {
    NSRange range2 = [allInfo rangeOfString:locationTXT options:NSRegularExpressionSearch|NSCaseInsensitiveSearch];
    if (range2.location != NSNotFound) {
        [goodText addAttribute:NSFontAttributeName value:[UIFont fontWithName:k_fontBold size:12] range:range2];
    }
    }
    
    if(![subBioTXT isEqualToString:@""])
    {
    NSRange range3 = [allInfo rangeOfString:subBioTXT options:NSRegularExpressionSearch|NSCaseInsensitiveSearch];
    if (range3.location != NSNotFound) {
        [goodText addAttribute:NSFontAttributeName value:[UIFont fontWithName:k_fontRegular size:12] range:range3];
    }
        bioInfoLBL.textAlignment=NSTextAlignmentLeft;
    }
    else
    {
        bioInfoLBL.textAlignment=NSTextAlignmentCenter;
    }
    bioInfoLBL.textAlignment=NSTextAlignmentCenter;

    
    [bioInfoLBL setAttributedText:goodText];

    
    
    
    
    
    
    
    
    CGSize size=[bioInfoLBL sizeThatFits:CGSizeMake(bioInfoLBL.frame.size.width, FLT_MAX)];
    
    if(size.width<self.frame.size.width/2)
    {
        size=CGSizeMake(self.frame.size.width/2, size.height);
        
    }
    
    popUpView.frame=CGRectMake(0, 0, size.width+2*padding, size.height+2*padding+35);
    
    bioInfoLBL.frame=CGRectMake(padding, padding+35, popUpView.frame.size.width-padding*2, popUpView.frame.size.height-padding*2-35);
    
    
    popUpView.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);

    popUpView.alpha=0;
    
    profilePic.center=CGPointMake(sourceFrame.origin.x+sourceFrame.size.width/2, sourceFrame.origin.y+sourceFrame.size.height/2);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        profilePic.center=CGPointMake(self.frame.size.width/2, popUpView.frame.origin.y);
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5f];
        

        
    } completion:^(BOOL finished) {
        
        popUpView.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height*2);
        popUpView.alpha=1;

        
        [UIView animateWithDuration:0.3 animations:^{
            
            popUpView.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);

            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    

    
    self.hidden=false;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];
    
    if(!CGRectContainsPoint(popUpView.frame, point) && self.hidden==false)
    {
        
  
        [UIView animateWithDuration:0.3 animations:^{
            
            profilePic.center=CGPointMake(sourceFrame.origin.x+sourceFrame.size.width/2, sourceFrame.origin.y+sourceFrame.size.height/2);
            self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.0f];
            popUpView.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height*2);

            
        } completion:^(BOOL finished) {
            
            self.hidden=true;

            [target performSelector:onTapEvent withObject:nil afterDelay:0.001];
         
            
        }];

    }

}
-(void)hideThisView
{
    
}
-(void)setTarget:(id)targetReceived onTap:(SEL)func;
{
     target=targetReceived;
     onTapEvent=func;

}

@end


