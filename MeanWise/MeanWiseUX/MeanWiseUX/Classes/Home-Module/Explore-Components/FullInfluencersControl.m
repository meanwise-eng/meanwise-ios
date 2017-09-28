//
//  FullInfluencersControl.m
//  MeanWiseUX
//
//  Created by Hardik on 11/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "FullInfluencersControl.h"
#import "APIManager.h"
#import "APIObjectsParser.h"
#import "APIManager.h"
#import "FTIndicator.h"
#import "ProfileWindowControl.h"


@implementation FullInfluencersControl

-(void)setTarget:(id)tReceived onClose:(SEL)func;
{
    target=tReceived;
    closeBtnClicked=func;
}
-(void)setUp
{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:blurEffectView];
    
 
    UICollectionViewFlowLayout* layout2 = [[UICollectionViewFlowLayout alloc] init];
    layout2.minimumInteritemSpacing = 0;
    layout2.minimumLineSpacing = 5;
    layout2.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout2.sectionInset = UIEdgeInsetsMake(20, 0, 150, 0);
    
    CGRect collectionViewFrame = CGRectMake(18, 30, self.frame.size.width-36, self.frame.size.height-30);
    userLists = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout2];
    userLists.delegate = self;
    userLists.dataSource = self;
    userLists.showsHorizontalScrollIndicator = NO;
    [userLists registerClass:[FullInfluencerCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:userLists];
    userLists.backgroundColor=[UIColor clearColor];

    dataArray=[[NSMutableArray alloc] init];

    //Base_Shadow.png
    baseShadow=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-324/2, self.frame.size.width, 324/2)];
    [self addSubview:baseShadow];
    [baseShadow setImage:[UIImage imageNamed:@"Base_Shadow.png"]];
    baseShadow.contentMode=UIViewContentModeScaleToFill;
    
    closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    [self addSubview:closeBtn];
    closeBtn.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-25);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    closeBtn.layer.cornerRadius=45/2;
    closeBtn.clipsToBounds=YES;
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self reloadData];
    
}
-(void)closeBtnClicked:(id)sender
{
    [FTIndicator dismissProgress];

    [target performSelector:closeBtnClicked withObject:nil afterDelay:0.001];
    
}
-(void)setSearchDict:(NSDictionary *)dict;
{
    searchDict=dict;
}
-(void)setSearchType:(int)searchType;
{
    typeOfSearch=searchType;
}
-(void)reloadData
{
    dataArray=[[NSMutableArray alloc] init];
    [userLists reloadData];

    if(typeOfSearch==-1 || typeOfSearch==1)
    {

    [FTIndicator showProgressWithmessage:@"Loading.."];
 
    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestForGetInfluencers:searchDict delegate:self andSelector:@selector(userDataReceived:)];
    }

}
-(void)userDataReceived:(APIResponseObj *)responseObj
{
    [FTIndicator dismissProgress];
    
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
    
    
    
    FullInfluencerCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    APIObjects_ProfileObj *obj=[dataArray objectAtIndex:indexPath.row];
    cell.firstNameLBL.text=obj.first_name;
    cell.profLBL.text=obj.profession_text;
    [cell.userImageView setUp:obj.profile_photo_small];
    cell.friendshipBtn.hidden=false;
//
//    if([obj.friend_request_status isEqualToString:@""])
//    {
//        cell.friendshipBtn.hidden=false;
//    }
//    else
//    {
//        cell.friendshipBtn.hidden=true;
//    }
    
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.frame.size.width-36, 50);
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect myRect = attributes.frame;
    CGRect rect=CGRectMake(collectionView.frame.origin.x+myRect.origin.x+8, collectionView.frame.origin.y+myRect.origin.y+8, 35, 35);
    
    rect = CGRectOffset(rect, -collectionView.contentOffset.x, -collectionView.contentOffset.y);
    [self openProfile:[dataArray objectAtIndex:indexPath.row] withFrame:rect];
    
}

-(void)openProfile:(APIObjects_ProfileObj *)obj withFrame:(CGRect)frame
{
    NSDictionary *dict=@{@"cover_photo":obj.cover_photo,@"user_id":obj.userId};
    
    
    ProfileWindowControl *control=[[ProfileWindowControl alloc] init];
    [control setUp:dict andSourceFrame:frame];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}





@end

@implementation FullInfluencerCell
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.clipsToBounds=YES;
        
        self.backgroundColor=[UIColor colorWithWhite:1 alpha:1];
        self.layer.cornerRadius=3;

        self.firstNameLBL=[[UILabel alloc] initWithFrame:CGRectMake(35+8+8, 8, self.frame.size.width-4, 17)];
        [self addSubview:self.firstNameLBL];
        self.firstNameLBL.font=[UIFont fontWithName:k_fontSemiBold size:11];
        
      

        
        self.userImageView=[[UIImageHM alloc] initWithFrame:CGRectMake(8, 8, 35, 35)];
        [self addSubview:self.userImageView];
        self.userImageView.layer.cornerRadius=self.userImageView.frame.size.width/2;
        
        self.firstNameLBL.textColor=[UIColor colorWithRed:20.0f/255.0f green:23.0f/255.0f blue:26.0f/255.0f alpha:1.0f];

        self.friendshipBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-65-12, 12, 65, 25)];
        [self addSubview:self.friendshipBtn];
        self.friendshipBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:11];
        [self.friendshipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.friendshipBtn setTitle:@"View" forState:UIControlStateNormal];
        self.friendshipBtn.backgroundColor=[UIColor colorWithRed:103.0f/255.0f green:205.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
        self.friendshipBtn.layer.cornerRadius=2.5f;
        self.friendshipBtn.clipsToBounds=YES;
        
        self.friendshipBtn.userInteractionEnabled=false;
        
        
        self.profLBL=[[UILabel alloc] initWithFrame:CGRectMake(35+8+8, 8+17, self.frame.size.width-4, 17)];
        [self addSubview:self.profLBL];
        self.profLBL.font=[UIFont fontWithName:k_fontSemiBold size:9];
        self.firstNameLBL.textAlignment=NSTextAlignmentLeft;
        self.profLBL.textAlignment=NSTextAlignmentLeft;
        self.profLBL.textColor=[UIColor colorWithRed:101.0f/255.0f green:119.0f/255.0f blue:134.0f/255.0f alpha:1.0f];
        
    }
    return self;
}

@end
