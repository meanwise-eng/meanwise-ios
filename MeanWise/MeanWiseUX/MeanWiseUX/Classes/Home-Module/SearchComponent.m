//
//  SearchComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 29/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "SearchComponent.h"
#import "ProfileCell.h"
#import "NewPostComponent.h"
#import "ProfileFullScreen.h"
#import "UserSession.h"
#import "APIObjectsParser.h"
#import "APIObjects_ProfileObj.h"


@implementation SearchComponent


-(void)setUp
{
    
    lastSearchType=-1;
    
    
    self.clipsToBounds=YES;
    
    self.backgroundColor=[Constant colorGlobal:0];
    
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);

    
    
    
    CGRect collectionViewFrame = CGRectMake(0, self.frame.size.height-400, self.frame.size.width, 320);
    galleryView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    galleryView.delegate = self;
    galleryView.dataSource = self;
  //  galleryView.pagingEnabled = YES;
    galleryView.showsHorizontalScrollIndicator = NO;
    galleryView.backgroundColor=[UIColor clearColor];
    galleryView.allowsSelection=YES;
    galleryView.allowsMultipleSelection=false;
    galleryView.bounces=YES;
    [galleryView registerClass:[ProfileCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
    [galleryView addSubview:refreshControl];
    galleryView.alwaysBounceVertical = true;
    

    
    [self addSubview:galleryView];

    searchBaseView=[[UIView alloc] initWithFrame:CGRectMake(20, 30, self.frame.size.width-40, 40)];
    [self addSubview:searchBaseView];
    searchBaseView.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.4f];
    searchBaseView.layer.cornerRadius=2;
    searchBaseView.clipsToBounds=YES;
    
    
    
    UIImageView *searchIcon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    searchIcon.image=[UIImage imageNamed:@"ChannelSearchIcon.png"];
    [searchBaseView addSubview:searchIcon];
    searchIcon.contentMode=UIViewContentModeScaleAspectFill;
    
    searchFieldTXT=[[UITextField alloc] initWithFrame:CGRectMake(50, 0, searchBaseView.frame.size.width-50, 40)];
    [searchBaseView addSubview:searchFieldTXT];
    searchFieldTXT.tintColor=[UIColor whiteColor];
    searchFieldTXT.textColor=[UIColor whiteColor];
    searchFieldTXT.keyboardAppearance=UIKeyboardAppearanceDark;
    searchFieldTXT.autocapitalizationType=UITextAutocapitalizationTypeNone;
    searchFieldTXT.autocorrectionType=UITextAutocorrectionTypeNo;
    searchFieldTXT.returnKeyType=UIReturnKeySearch;
    
    
    searchTypeLBL=[[UILabel alloc] initWithFrame:CGRectMake(searchBaseView.frame.size.width-100, 5, 100, 30)];
    [searchBaseView addSubview:searchTypeLBL];
    searchTypeLBL.font=[UIFont fontWithName:k_fontBold size:12];
    searchTypeLBL.textColor=[UIColor whiteColor];
    searchTypeLBL.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.4f];
    searchTypeLBL.layer.cornerRadius=2;
    searchTypeLBL.clipsToBounds=YES;
    searchTypeLBL.textAlignment=NSTextAlignmentCenter;

  
    

    
    
    
    statusLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 110, self.frame.size.width-40, 100)];
    [self addSubview:statusLabel];
    statusLabel.font=[UIFont fontWithName:k_fontAvenirNextHeavy size:100];
    statusLabel.textColor=[UIColor whiteColor];
    //statusLabel.text=@"Hi I'm sam and I'm a photographer.";
    statusLabel.numberOfLines=3;
    statusLabel.adjustsFontSizeToFitWidth=YES;
    
    suggestionBox=[[SearchSuggestionsView alloc] initWithFrame:CGRectMake(20, 72, self.frame.size.width-40, 104)];
    [self addSubview:suggestionBox];
    [suggestionBox setUp];
    [suggestionBox setTarget:self OnOptionSelect:@selector(OnOptionSelect:)];
    
    
    
   
    
//    backBtn=[[UIButton alloc] initWithFrame:CGRectMake(20,35, 23*1.2, 16*1.2)];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackButton.png"] forState:UIControlStateNormal];
//    [self addSubview:backBtn];
//    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    self.clipsToBounds=YES;
    
    
    emptyView=[[EmptyView alloc] initWithFrame:galleryView.frame];
    [self addSubview:emptyView];
    emptyView.hidden=true;
    [emptyView setUIForBlack];
    [emptyView setDelegate:self onReload:@selector(refreshAction)];
    
    [emptyView.reloadBtn setTitle:@"SHOW FEATURED USERS" forState:UIControlStateNormal];


    
    [self refreshAction];

}

#pragma mark - Methods
-(void)updateSearchTitle:(NSString *)searchTitle
{
    searchTypeLBL.hidden=false;
    searchTypeLBL.text=searchTitle;
    CGSize sizeF=[searchTypeLBL sizeThatFits:searchTypeLBL.bounds.size];
    
    int width=sizeF.width+20;
    
    searchTypeLBL.frame=CGRectMake(searchBaseView.frame.size.width-5-width, 10, width, 20);
}
-(void)refershControlAction
{

    if(lastSearchType==-1)
    {
        [self refreshAction];
    }
    else
    {
        [self OnOptionSelect:[NSNumber numberWithInteger:lastSearchType]];
    }


}


-(void)searchFieldTXTChanged:(id)sender
{
    searchTypeLBL.hidden=true;
    
    [suggestionBox setSearchString:searchFieldTXT.text];
    NSLog(@"%@",searchFieldTXT.text);
    
}
-(void)OnOptionSelect:(NSNumber *)number
{
    lastSearchType=number.intValue;
    
    NSLog(@"%d",number.intValue);
    NSLog(@"%@",searchFieldTXT.text);
    
    suggestionBox.hidden=true;
    NSString *paramKey;
    
    if(number.intValue==0)
    {
        paramKey=@"username__contains";
        [self updateSearchTitle:@"Users"];
        [AnalyticsMXManager PushAnalyticsEvent:@"Search -User"];

    }
    else
    {
        paramKey=@"skills_text__contains";
        [self updateSearchTitle:@"Skill"];
        [AnalyticsMXManager PushAnalyticsEvent:@"Search -Skill"];

    }
    

    
    NSDictionary *dict=@{@"paramKey":paramKey,@"searchTerm":searchFieldTXT.text};
    
    [searchFieldTXT resignFirstResponder];
    [self searchAPI:dict];
    
    
}

#pragma mark - CollectionView delegate


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProfileCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor clearColor];
    
    APIObjects_ProfileObj *obj=[[DataSession sharedInstance].searchUserResults objectAtIndex:indexPath.row];
    
    

    cell.nameLBL.text=[NSString stringWithFormat:@"Hi,\nI'm %@",obj.first_name];
    
    
    if(obj.cover_photo.class!=[NSNull class])
    {
        [cell.profileIMGVIEW setUp:obj.cover_photo];

    }
    else
    {
      //  cell.profileIMGVIEW.image=[UIImage imageNamed:[NSString stringWithFormat:@"profile%d.jpg",(int)indexPath.row%5+3]];

        
    }
    
   

//    [cell.profileIMGVIEW setUp:obj.cover_photo];
    
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[DataSession sharedInstance].searchUserResults count];
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{

  
    cell.transform=CGAffineTransformMakeScale(0.8, 0.8);
    
    
        [UIView animateWithDuration:0.5
                         animations:^{
                             
    cell.transform=CGAffineTransformMakeScale(1, 1);

                             
            }
        completion:^(BOOL finished) {
                             
        }];

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

   
    suggestionBox.hidden=true;
    [searchFieldTXT resignFirstResponder];

    
    UICollectionViewLayoutAttributes * theAttributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect cellFrameInSuperview = [collectionView convertRect:theAttributes.frame toView:collectionView.superview];

    APIObjects_ProfileObj *obj=[[DataSession sharedInstance].searchUserResults objectAtIndex:indexPath.row];

    ProfileFullScreen *com=[[ProfileFullScreen alloc] initWithFrame:self.bounds];
    [self addSubview:com];
    [com setUpProfileObj:obj];
    
    
    [com setUpWithCellRect:cellFrameInSuperview];
    
    [com setDelegate:self andPageChangeCallBackFunc:@selector(openingTableViewAtPath:) andDownCallBackFunc:@selector(downClicked:)];

    ProfileCell *cell=(ProfileCell *)[galleryView cellForItemAtIndexPath:indexPath];
    [cell setHiddenCustom:true];

    
    [com setImage:nil andNumber:indexPath];


    galleryView.scrollEnabled=false;
    
    
//    ProfileComponent *com=[[ProfileComponent alloc] initWithFrame:self.bounds];
//    [self addSubview:com];
//
//    [com setUpWithCellRect:cellFrameInSuperview];
//    
//    [com setImage:[NSString stringWithFormat:@"profile%d.jpg",(int)indexPath.row%5+3] andNumber:indexPath];
//    
//    [com setTarget:self andFunc1:@selector(backToSearchScreen)];
//    
   [self hideBottomBar];

   /* NewPostComponent *cont=[[NewPostComponent alloc] initWithFrame:self.bounds];
    [self addSubview:cont];
    [cont setUpWithCellRect:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];*/

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float ratio=self.bounds.size.height/self.bounds.size.width;
    
    return CGSizeMake(350/ratio, 300);
}



#pragma mark - ScrollView delegate


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    
     if(decelerate==true)
     {
        return;
     }
     else
     {
         [self scrollingEnded];
     }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
{
    [self scrollingEnded];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat pageWidth = galleryView.frame.size.width*0.6;
    float currentPage = galleryView.contentOffset.x / pageWidth;
    
    int pageNumber;
    
    if (0.0f != fmodf(currentPage, 1.0f))
    {
        pageNumber = currentPage + 1;
    }
    else
    {
        pageNumber= currentPage;
    }
    
    
    
    //  NSLog(@"Page Number : %d", pageNumber);
    
    float diff=galleryView.contentOffset.x-pageNumber*pageWidth;
    float incRatio=1.0f+diff/pageWidth;
    
   // NSLog(@"Page Number :%d, %f",pageNumber, incRatio);
    
    UIColor *color1=[Constant colorGlobal:((pageNumber)%14)];
    UIColor *color0=[Constant colorGlobal:((pageNumber-1)%14)];
    
    
    CGFloat red1 = 0.0, green1 = 0.0, blue1 = 0.0, alpha1 =0.0;
    CGFloat red0 = 0.0, green0 = 0.0, blue0 = 0.0, alpha0 =0.0;
    
    [color1 getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    [color0 getRed:&red0 green:&green0 blue:&blue0 alpha:&alpha0];
    
    UIColor *colorF=[UIColor colorWithRed:red0+red1*incRatio green:green0+green1*incRatio blue:blue0+incRatio*blue1 alpha:alpha0+incRatio*alpha1];
    
    self.backgroundColor=colorF;
    
    if(scrollView==galleryView)
    {
    if(scrollView.contentOffset.x<500)
    {
        galleryView.bounces = true;

    }
    else
    {
        galleryView.bounces = false;
    }
    }
}

-(void)scrollingEnded
{
    
    NSIndexPath *centerCellIndexPath =
    [galleryView indexPathForItemAtPoint:
     [self convertPoint:[galleryView center] toView:galleryView]];

    [galleryView scrollToItemAtIndexPath:centerCellIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];

    int pageNumber=(int)centerCellIndexPath.row;

    
//    CGFloat pageWidth = galleryView.frame.size.width*0.6;
//    float currentPage = (galleryView.contentOffset.x) / pageWidth;
//    
//    
//    int pageNumber;
//    
//    if (0.0f != fmodf(currentPage, 1.0f))
//    {
//        pageNumber = currentPage + 1;
//    }
//    else
//    {
//        pageNumber= currentPage;
//    }
//    
//  //  NSLog(@"Page Number : %d", pageNumber);
//    
//    if(resultData.count<=pageNumber)
//    {
//        pageNumber=pageNumber-1;
//    }
//    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:pageNumber inSection:0];
//    
    
    
   // CGPoint oldContentOffset=galleryView.contentOffset;

    
//    CGPoint newContentOffset=galleryView.contentOffset;
//    galleryView.contentOffset=oldContentOffset;
//
//    
//    
//    
//    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
//        galleryView.contentOffset=CGPointMake(newContentOffset.x-10, newContentOffset.y);
//
//
//        
//    } completion:^(BOOL finished) {
//        
//      
//        
//    }];
//
//    

    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.backgroundColor=[Constant colorGlobal:(pageNumber%14)];
        
    }];
    
    
    APIObjects_ProfileObj *obj=[[DataSession sharedInstance].searchUserResults objectAtIndex:centerCellIndexPath.row];
    
    if(obj.bio.class!=[NSNull class])
    {
        if(![obj.bio isEqualToString:@""])
        {
        statusLabel.text=obj.bio;
        }
        else
        {
            statusLabel.text=[NSString stringWithFormat:@"I'm %@",obj.first_name];

        }
    }
    else
    {
        statusLabel.text=[NSString stringWithFormat:@"I'm %@",obj.first_name];
    }

}

#pragma mark - API calls
-(void)refreshAction
{

    lastSearchType=-1;
    [self updateSearchTitle:@"Featured Users"];
    
    [searchFieldTXT resignFirstResponder];
    searchFieldTXT.text=@"";
    
    manager=[[APIManager alloc] init];
    
    [manager sendRequestForAllUserData:[UserSession getAccessToken] delegate:self andSelector:@selector(userFriendsReceived:)];
    
    [searchFieldTXT addTarget:self action:@selector(searchFieldTXTChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [FTIndicator showProgressWithmessage:@"Loading.."];
    galleryView.userInteractionEnabled=false;

    
}

-(void)userFriendsReceived:(APIResponseObj *)responseObj
{
    galleryView.userInteractionEnabled=true;

    [refreshControl endRefreshing];

    [FTIndicator dismissProgress];
    
  //  NSLog(@"%@",responseObj.response);
    
    
    if([responseObj.response isKindOfClass:[NSArray class]])
    {
        NSArray *arrayTemp=(NSArray *)responseObj.response;
        APIObjectsParser *parser=[[APIObjectsParser alloc] init];
        [DataSession sharedInstance].searchUserResults=[NSMutableArray arrayWithArray:[parser parseObjects_PROFILES:arrayTemp]];
        [galleryView reloadData];
        [galleryView setContentOffset:CGPointZero animated:false];

       
       
        if([DataSession sharedInstance].searchUserResults.count==0)
        {
            emptyView.hidden=false;
        }
        else
        {
            emptyView.hidden=true;
        }
        
        if([DataSession sharedInstance].searchUserResults.count>0)
        {
            APIObjects_ProfileObj *obj=[[DataSession sharedInstance].searchUserResults objectAtIndex:0];
            
            
            if(![obj.bio isEqualToString:@""])
            {
                statusLabel.text=obj.bio;
            }
            else
            {
                statusLabel.text=[NSString stringWithFormat:@"I'm %@",obj.first_name];
            }
            
        }
        else
        {
            statusLabel.text=@"";
            UIColor *color1=[Constant colorGlobal:1];
            
            [UIView animateWithDuration:0.2 animations:^{
                
                self.backgroundColor=color1;
                
            }];
            
        }
    }
    
}
-(void)searchAPI:(NSDictionary *)dict
{
    manager=[[APIManager alloc] init];
    [manager sendRequestForUserSearch:dict delegate:self andSelector:@selector(userFriendsReceived:)];
    
    [FTIndicator showProgressWithmessage:@"Loading.."];
    
    galleryView.userInteractionEnabled=false;

    
}

#pragma mark -  setting selectors
-(void)setTarget:(id)target andHide:(SEL)func1 andShow:(SEL)func2
{
    delegate=target;
    hideBottomBarFunc=func1;
    showBottomBarFunc=func2;
    
}
-(void)hideBottomBar
{
    [delegate performSelector:hideBottomBarFunc withObject:nil afterDelay:0.01];
}
-(void)showBottomBar
{
    [delegate performSelector:showBottomBarFunc withObject:nil afterDelay:0.01];
    
}
#pragma mark -  Flows

-(void)backToSearchScreen
{
    [self showBottomBar];
}
-(void)openingTableViewAtPath:(NSIndexPath *)indexPath
{
    
    
    
}
-(void)downClicked:(NSIndexPath *)indexPath
{
    [self showBottomBar];
    
    galleryView.scrollEnabled=true;
    ProfileCell *cell=(ProfileCell *)[galleryView cellForItemAtIndexPath:indexPath];
    cell.hidden=false;
    
    // FeedCell *cell=[tableView cellForRowAtIndexPath:indexPath];
}


@end
