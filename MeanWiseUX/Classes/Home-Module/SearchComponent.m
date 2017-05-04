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
#import "NewProfileView.h"
#import "UserSession.h"
#import "APIObjectsParser.h"
#import "APIObjects_ProfileObj.h"


@implementation SearchComponent


-(void)setUp
{
    
  
    
    
    self.clipsToBounds=YES;
    
    self.backgroundColor=[Constant colorGlobal:0];
    
    
   /* UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 320);*/
    
    layout =  [HorizontalLinearFlowLayout layoutConfiguredWithCollectionView:galleryView
                                                                    itemSize:CGSizeMake(180, 180)
                                                          minimumLineSpacing:10];
    layout.scaleItems = NO;
    layout.noOffset = YES;
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 10);

    CGRect collectionViewFrame = CGRectMake(0, 180, self.frame.size.width, self.bounds.size.height*0.5);
    galleryView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    galleryView.delegate = self;
    galleryView.dataSource = self;
    galleryView.showsHorizontalScrollIndicator = NO;
    galleryView.backgroundColor=[UIColor clearColor];
    
    [galleryView registerClass:[ProfileCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    
    [self addSubview:galleryView];

    searchBaseView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 60.0, self.frame.size.width, 40)];
    [self addSubview:searchBaseView];
    searchBaseView.backgroundColor=[UIColor blackColor];
    searchBaseView.alpha = 0;
    
    
    
    UIImageView *searchIcon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    searchIcon.image=[UIImage imageNamed:@"ChannelSearchIcon.png"];
   // [searchBaseView addSubview:searchIcon];
    searchIcon.contentMode=UIViewContentModeScaleAspectFill;
    
    searchFieldTXT=[[UITextField alloc] initWithFrame:CGRectMake(20, self.bounds.size.height - 60.0, self.bounds.size.width - 40, 40)];
    [self addSubview:searchFieldTXT];
    searchFieldTXT.tintColor=[UIColor whiteColor];
    searchFieldTXT.textColor=[UIColor whiteColor];
    searchFieldTXT.placeholder = @"Type here to search";
    searchFieldTXT.keyboardAppearance=UIKeyboardAppearanceDark;
    searchFieldTXT.autocapitalizationType=UITextAutocapitalizationTypeNone;
    searchFieldTXT.autocorrectionType=UITextAutocorrectionTypeNo;
    searchFieldTXT.returnKeyType=UIReturnKeySearch;
    searchFieldTXT.font = [UIFont fontWithName:k_fontRegular size:23];
    searchFieldTXT.delegate = self;
    
    
    searchTypeLBL=[[UILabel alloc] initWithFrame:CGRectMake(searchBaseView.frame.size.width-100, 5, 100, 30)];
    //[searchBaseView addSubview:searchTypeLBL];
    searchTypeLBL.font=[UIFont fontWithName:k_fontBold size:12];
    searchTypeLBL.textColor=[UIColor whiteColor];
    searchTypeLBL.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.4f];
    searchTypeLBL.layer.cornerRadius=2;
    searchTypeLBL.clipsToBounds=YES;
    searchTypeLBL.textAlignment=NSTextAlignmentCenter;

    
    statusLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 60, self.frame.size.width-40, 100)];
    [self addSubview:statusLabel];
    statusLabel.font=[UIFont fontWithName:k_fontAvenirNextHeavy size:26];
    statusLabel.textColor=[UIColor whiteColor];
    statusLabel.numberOfLines=3;
    statusLabel.textAlignment = NSTextAlignmentLeft;
    statusLabel.adjustsFontSizeToFitWidth=YES;
    
    suggestionBox=[[SearchSuggestionsView alloc] initWithFrame:CGRectMake(20, 72, self.frame.size.width-40, 104)];
   // [self addSubview:suggestionBox];
    [suggestionBox setUp];
    [suggestionBox setTarget:self OnOptionSelect:@selector(OnOptionSelect:)];
    
    
    
   
    
//    backBtn=[[UIButton alloc] initWithFrame:CGRectMake(20,35, 22*1, 15*1)];
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



-(void)searchFieldTXTChanged:(id)sender
{
    searchTypeLBL.hidden=true;
    
    [suggestionBox setSearchString:searchFieldTXT.text];
    NSLog(@"%@",searchFieldTXT.text);
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:NO];
}

-(void) animateTextField:(BOOL) up
{
    if(up==false)
    {
        
        
        [UIView animateWithDuration:0.25  animations:^{
            
            searchFieldTXT.frame=CGRectMake(20, self.frame.size.height-60, self.frame.size.width-40, 40);
            searchBaseView.frame=CGRectMake(0, self.frame.size.height-60, self.frame.size.width, 40);
            searchBaseView.alpha = 0;

        }];
        
        
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            
            searchFieldTXT.frame=CGRectMake(20, self.frame.size.height-300, self.frame.size.width-40, 40);
            searchBaseView.frame=CGRectMake(0, self.frame.size.height-300, self.frame.size.width, 40);
            searchBaseView.alpha = 0.5;

        }];
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [searchFieldTXT resignFirstResponder];
    
    NSDictionary *dict=@{@"paramKey":@"username",@"searchTerm":searchFieldTXT.text};
    
    [self searchAPI:dict];
    
    return YES;
}

-(void)OnOptionSelect:(NSNumber *)number
{
    NSLog(@"%d",number.intValue);
    NSLog(@"%@",searchFieldTXT.text);
    
    suggestionBox.hidden=true;
    NSString *paramKey;
    
    if(number.intValue==0)
    {
        paramKey=@"username";
        [self updateSearchTitle:@"Users"];
    }
    else
    {
        paramKey=@"skills_text";
        [self updateSearchTitle:@"Skills"];
    }
    
    NSDictionary *dict=@{@"paramKey":paramKey,@"searchTerm":searchFieldTXT.text};
    
    [searchFieldTXT resignFirstResponder];
    [self searchAPI:dict];
    
    
}

-(NSDictionary *)userDictFromPostDetail:(APIObjects_ProfileObj *)prof
{
    
    NSDictionary *dict=@{
                         @"user_id":prof.userId,
                         @"user_cover_photo":prof.cover_photo
                         };
    
    return dict;
}

#pragma mark - CollectionView delegate


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProfileCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor clearColor];
    
    APIObjects_ProfileObj *obj=[resultData objectAtIndex:indexPath.row];
    
    

    cell.nameLBL.text=[NSString stringWithFormat:@"Hey,\nI'm %@",obj.first_name];
    
    
    if(obj.cover_photo.class!=[NSNull class])
    {
        cell.profileIMGVIEW.defaultImage = [Constant imageWithColor:[Constant colorGlobal:arc4random_uniform(14)] andBounds:cell.bounds];
        cell.profileIMGVIEW.placeholderFadeDuration = 0.25;
        cell.profileIMGVIEW.URL = [NSURL URLWithString:obj.cover_photo];

    }
    else
    {
        cell.profileIMGVIEW.image=[UIImage imageNamed:[NSString stringWithFormat:@"profile%d.jpg",(int)indexPath.row%5+3]];

        
    }
    

//    [cell.profileIMGVIEW setUp:obj.cover_photo];
    
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [resultData count];
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.transform=CGAffineTransformMakeScale(0.9, 0.9);
    
    cell.alpha=0;
    
        [UIView animateWithDuration:0.5
                         animations:^{
                             
                             cell.transform=CGAffineTransformMakeScale(1, 1);
                             cell.alpha=1;

                             
            }
        completion:^(BOOL finished) {
                             
        }];
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [searchFieldTXT resignFirstResponder];
    
    UICollectionViewLayoutAttributes * theAttributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect cellFrameInSuperview = [collectionView convertRect:theAttributes.frame toView:collectionView.superview];
    
    ProfileCell *cell=(ProfileCell *)[galleryView cellForItemAtIndexPath:indexPath];

    APIObjects_ProfileObj *obj=[resultData objectAtIndex:indexPath.row];
    

    NewProfileView *com=[[NewProfileView alloc] initWithFrame:cellFrameInSuperview];
    [com setUpProfileObj:[self userDictFromPostDetail:obj]];
    [com setDelegate:self andFunc1:@selector(closeProfile:)];
    [com setUpFromView:@"searchView"];
    [self addSubview:com];
    
    [UIView animateWithDuration:0.3 animations:^{
        cell.transform=CGAffineTransformMakeScale(0.95, 0.95);
    }];
    
    
    galleryView.scrollEnabled=false;
 
    
    [self hideBottomBar];



}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float ratio=self.bounds.size.height/self.bounds.size.width;
    
    return CGSizeMake(350/ratio, self.bounds.size.height * 0.5);
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


-(void)scrollingEnded
{
    
    CGRect visibleRect = (CGRect){.origin = galleryView.contentOffset, .size = galleryView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [galleryView indexPathForItemAtPoint:visiblePoint];
    

    int pageNumber;
    
    if (0.0f != fmodf(visibleIndexPath.row, 1.0f))
    {
        pageNumber = (int)visibleIndexPath.row + 1;
    }
    else
    {
        pageNumber= (int)visibleIndexPath.row;
    }

    
    if(resultData.count<=pageNumber)
    {
        pageNumber=pageNumber-1;
    }

    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.backgroundColor=[Constant colorGlobal:(pageNumber%14)];
        
    }];
    
    
    APIObjects_ProfileObj *obj=[resultData objectAtIndex:visibleIndexPath.row];
    
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
    [self updateSearchTitle:@"Featured Users"];
    
    [searchFieldTXT resignFirstResponder];
    searchFieldTXT.text=@"";
    
    manager=[[APIManager alloc] init];
    
    [manager sendRequestForAllUserData:[UserSession getAccessToken] delegate:self andSelector:@selector(userFriendsReceived:)];
    
    [searchFieldTXT addTarget:self action:@selector(searchFieldTXTChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [FTIndicator showProgressWithmessage:@"Loading.."];
    
    
}
-(void)userFriendsReceived:(APIResponseObj *)responseObj
{
    [FTIndicator dismissProgress];
    
  //  NSLog(@"%@",responseObj.response);
    
    if([responseObj.response isKindOfClass:[NSArray class]])
    {
        NSArray *arrayTemp=(NSArray *)responseObj.response;
        APIObjectsParser *parser=[[APIObjectsParser alloc] init];
        resultData=[parser parseObjects_PROFILES:arrayTemp];
        [galleryView reloadData];
        [galleryView setContentOffset:CGPointZero animated:false];

       
        
        if(resultData.count==0)
        {
            emptyView.hidden=false;
        }
        else
        {
            emptyView.hidden=true;
        }
        
        if(resultData.count>0)
        {
            APIObjects_ProfileObj *obj=[resultData objectAtIndex:0];
            
            
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
-(void)closeProfile:(NSIndexPath *)indexPath
{
    
    [self showBottomBar];
    
    galleryView.scrollEnabled=true;
    ProfileCell *cell=(ProfileCell *)[galleryView cellForItemAtIndexPath:indexPath];
    cell.hidden=false;
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.0 options:0 animations: ^{
        
        cell.transform=CGAffineTransformMakeScale(1, 1);
        
    } completion:nil];
    
    // FeedCell *cell=[tableView cellForRowAtIndexPath:indexPath];
}


@end
