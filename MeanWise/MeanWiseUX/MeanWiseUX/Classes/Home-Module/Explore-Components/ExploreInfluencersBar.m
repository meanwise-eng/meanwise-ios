//
//  ExploreInfluencersBar.m
//  MeanWiseUX
//
//  Created by Hardik on 07/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ExploreInfluencersBar.h"
#import "InfluencerCell.h"
#import "APIManager.h"
#import "APIObjectsParser.h"

@implementation ExploreInfluencersBar

-(void)setTarget:(id)targetReceived onTapEvent:(SEL)tap;
{
    target=targetReceived;
    onTapButtonClick=tap;
}

-(void)setUp
{
    
    UICollectionViewFlowLayout* layout2 = [[UICollectionViewFlowLayout alloc] init];
    layout2.minimumInteritemSpacing = 5;
    layout2.minimumLineSpacing = 5;
    layout2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout2.sectionInset = UIEdgeInsetsMake(0, 18, 0, 18);
    
    CGRect collectionViewFrame = self.bounds;
    userLists = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout2];
    userLists.delegate = self;
    userLists.dataSource = self;
    userLists.showsHorizontalScrollIndicator = NO;
    [userLists registerClass:[InfluencerCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:userLists];
    userLists.alwaysBounceHorizontal=YES;
    userLists.bounces=true;
    userLists.backgroundColor=[UIColor clearColor];
    
    dataArray=[[NSMutableArray alloc] init];
    
}
-(void)refreshAction:(NSDictionary *)dict;
{
    dataArray=[[NSMutableArray alloc] init];
    [userLists reloadData];
    
    
    if(typeOfSearch==-1 || typeOfSearch==1)
    {
        APIManager *manager=[[APIManager alloc] init];
        [manager sendRequestForGetInfluencers:dict delegate:self andSelector:@selector(userDataReceived:)];

    }
    else
    {
        
    }

    
}
-(void)setSearchType:(int)searchType;
{
    typeOfSearch=searchType;
}
-(int)getTypeOfSearch
{
    return typeOfSearch;
}
-(NSDictionary *)getSearchDict
{
    return searchDict;
}


-(void)userDataReceived:(APIResponseObj *)responseObj
{
    

        if([responseObj.response isKindOfClass:[NSArray class]])
        {
            
            NSArray *arrayTemp=(NSArray *)responseObj.response;
            APIObjectsParser *parser=[[APIObjectsParser alloc] init];
            
            dataArray=[NSMutableArray arrayWithArray:[parser parseObjects_PROFILES:arrayTemp]];
            
            
            [userLists reloadData];
        }
        
    
   
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    InfluencerCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    APIObjects_ProfileObj *obj=[dataArray objectAtIndex:indexPath.row];
    cell.firstNameLBL.text=obj.first_name;
//    cell.profLBL.text=obj.profession_text;
    [cell.userImageView setUp:obj.profile_photo_small];
    
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(75, 100);
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect cellRect = attributes.frame;
    
    CGRect cellFrameInSuperview = [collectionView convertRect:cellRect toView:[collectionView superview]];
   
    APIObjects_ProfileObj *obj=[dataArray objectAtIndex:indexPath.row];
    NSDictionary *userInfo=@{@"cover_photo":obj.cover_photo,@"user_id":obj.userId};

    NSDictionary *dict=@{@"FRAME":[NSValue valueWithCGRect:cellFrameInSuperview],@"USER":userInfo};
    
    [target performSelector:onTapButtonClick withObject:dict afterDelay:0.01];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

@end
