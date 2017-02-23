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

-(void)setUp
{
    
    array=[[NSArray alloc] initWithObjects:
           @"I can solve problem, Computers..",
           @"I'm Musician. Music is my life",
           @"Hey I'm Sam and I love basketball",
           @"Hey I'm Max and I love Cricket",
           @"Hey, How are you?", nil];
    
    
    nameArray=[[NSArray alloc] initWithObjects:
               @"Hi,\nI'm Sam",
               @"Hi,\nI'm John",
               @"Hi,\nI'm Marry",
               @"Hi,\nI'm Mike",
               @"Hi,\nI'm Kelvin",
               nil];
    
    
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
    
    [galleryView registerClass:[ProfileCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    
    [self addSubview:galleryView];

    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(20, 30, self.frame.size.width-40, 40)];
    [self addSubview:view];
    view.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.4f];
    view.layer.cornerRadius=2;
    view.clipsToBounds=YES;
    
    
    
    UIImageView *searchIcon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    searchIcon.image=[UIImage imageNamed:@"ChannelSearchIcon.png"];
    [view addSubview:searchIcon];
    searchIcon.contentMode=UIViewContentModeScaleAspectFill;
    
    exploreTerm=[[UITextField alloc] initWithFrame:CGRectMake(50, 0, view.frame.size.width-50, 40)];
    [view addSubview:exploreTerm];
    exploreTerm.tintColor=[UIColor whiteColor];
    exploreTerm.textColor=[UIColor whiteColor];
    
    statusLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 110, self.frame.size.width-40, 100)];
    [self addSubview:statusLabel];
    statusLabel.font=[UIFont fontWithName:k_fontAvenirNextHeavy size:100];
    statusLabel.textColor=[UIColor whiteColor];
    //statusLabel.text=@"Hi I'm sam and I'm a photographer.";
    statusLabel.numberOfLines=3;
    statusLabel.adjustsFontSizeToFitWidth=YES;
    
//    backBtn=[[UIButton alloc] initWithFrame:CGRectMake(20,35, 23*1.2, 16*1.2)];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackButton.png"] forState:UIControlStateNormal];
//    [self addSubview:backBtn];
//    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    self.clipsToBounds=YES;
    
    
    manager=[[APIManager alloc] init];
    
    [manager sendRequestForAllUserData:[UserSession getAccessToken] delegate:self andSelector:@selector(userFriendsReceived:)];
//    [manager sendRequestGettingUsersFriends:[UserSession getUserId] delegate:self andSelector:@selector(userFriendsReceived:)];


}
-(void)userFriendsReceived:(APIResponseObj *)responseObj
{
    NSLog(@"%@",responseObj.response);
    
    if([responseObj.response isKindOfClass:[NSArray class]])
    {
        NSArray *arrayTemp=(NSArray *)responseObj.response;
        APIObjectsParser *parser=[[APIObjectsParser alloc] init];
        resultData=[parser parseObjects_PROFILES:arrayTemp];
        [galleryView reloadData];
        
        if(resultData.count>0)
        {
            APIObjects_ProfileObj *obj=[resultData objectAtIndex:0];


            if(obj.bio.class!=[NSNull class])
            {
            statusLabel.text=obj.bio;
            }
            
        }
    }
    
    int p=0;
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProfileCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor clearColor];
    
    APIObjects_ProfileObj *obj=[resultData objectAtIndex:indexPath.row];
    
    

    cell.nameLBL.text=[NSString stringWithFormat:@"Hi,\nI'm %@",obj.first_name];
    
    
    if(obj.cover_photo.class!=[NSNull class])
    {
        [cell.profileIMGVIEW setUp:obj.cover_photo];

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
    
    UICollectionViewLayoutAttributes * theAttributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect cellFrameInSuperview = [collectionView convertRect:theAttributes.frame toView:collectionView.superview];

    APIObjects_ProfileObj *obj=[resultData objectAtIndex:indexPath.row];

    ProfileFullScreen *com=[[ProfileFullScreen alloc] initWithFrame:self.bounds];
    [self addSubview:com];
    [com setUpProfileObj:obj];
    
    
    [com setUpWithCellRect:cellFrameInSuperview];
    
    [com setDelegate:self andPageChangeCallBackFunc:@selector(openingTableViewAtPath:) andDownCallBackFunc:@selector(downClicked:)];

    ProfileCell *cell=(ProfileCell *)[galleryView cellForItemAtIndexPath:indexPath];
    [cell setHiddenCustom:true];

    
    NSString *imgURL=[NSString stringWithFormat:@"profile%d.jpg",(int)indexPath.row%5+3];
    [com setImage:imgURL andNumber:indexPath];

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
-(void)openingTableViewAtPath:(NSIndexPath *)indexPath
{
    
    
    
}
-(void)downClicked:(NSIndexPath *)indexPath
{
    [self showBottomBar];
    
    ProfileCell *cell=(ProfileCell *)[galleryView cellForItemAtIndexPath:indexPath];
    cell.hidden=false;
    
    // FeedCell *cell=[tableView cellForRowAtIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float ratio=self.bounds.size.height/self.bounds.size.width;
    
    return CGSizeMake(350/ratio, 300);
}

-(void)backToSearchScreen
{
    [self showBottomBar];
}


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
    
    NSLog(@"Page Number :%d, %f",pageNumber, incRatio);
    
    UIColor *color1=[Constant colorGlobal:((pageNumber)%14)];
    UIColor *color0=[Constant colorGlobal:((pageNumber-1)%14)];
    
    
    CGFloat red1 = 0.0, green1 = 0.0, blue1 = 0.0, alpha1 =0.0;
    CGFloat red0 = 0.0, green0 = 0.0, blue0 = 0.0, alpha0 =0.0;
    
    [color1 getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    [color0 getRed:&red0 green:&green0 blue:&blue0 alpha:&alpha0];
    
    UIColor *colorF=[UIColor colorWithRed:red0+red1*incRatio green:green0+green1*incRatio blue:blue0+incRatio*blue1 alpha:alpha0+incRatio*alpha1];
    
    self.backgroundColor=colorF;
}

-(void)scrollingEnded
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
    
    NSLog(@"Page Number : %d", pageNumber);
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:pageNumber inSection:0];
    
    [galleryView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.backgroundColor=[Constant colorGlobal:(pageNumber%14)];
        
    }];
    
    
    APIObjects_ProfileObj *obj=[resultData objectAtIndex:indexPath.row];
    
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


@end
