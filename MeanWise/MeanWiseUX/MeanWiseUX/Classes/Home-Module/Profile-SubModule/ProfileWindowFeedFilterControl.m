//
//  ProfileWindowFeedFilterControl.m
//  MeanWiseUX
//
//  Created by Hardik on 09/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ProfileWindowFeedFilterControl.h"
#import "Constant.h"

@implementation ProfileWindowFeedFilterControl

-(void)setUp
{
    
    filterData=[[NSMutableArray alloc] init];
    
    UICollectionViewFlowLayout* layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.minimumInteritemSpacing = 0;
    layout1.minimumLineSpacing = 0;
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout1.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    filterCV=[[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout1];
    [self addSubview:filterCV];
    

    filterCV.backgroundColor=[UIColor clearColor];
    
    [filterCV registerClass:[FilterItemCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    filterCV.delegate=self;
    filterCV.dataSource=self;

    filterCV.allowsSelection=YES;
    filterCV.allowsMultipleSelection=false;
    
    [filterCV setShowsHorizontalScrollIndicator:NO];
    [filterCV setShowsVerticalScrollIndicator:NO];


}
-(void)setTarget:(id)targetReceived onfilterSelect:(SEL)func;
{
    target=targetReceived;
    onfilterSelectEvent=func;
    
}
-(void)setFilterData:(NSMutableArray *)array
{
    filterData=array;
    [filterCV reloadData];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FilterItemCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.titleLBL.text=[filterData objectAtIndex:indexPath.row];
    
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return filterData.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [target performSelector:onfilterSelectEvent withObject:[filterData objectAtIndex:indexPath.row] afterDelay:0.01];
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dictAttributes=@{NSFontAttributeName:[UIFont fontWithName:k_fontSemiBold size:15]};
    NSString *dict=[NSString stringWithFormat:@"@%@",[filterData objectAtIndex:indexPath.row]];
    CGSize calCulateSizze =[dict sizeWithAttributes:dictAttributes];
    return CGSizeMake(calCulateSizze.width+10, self.frame.size.height);

    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

@end

@implementation FilterItemCell

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.clipsToBounds=YES;
        
        self.titleLBL=[[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:self.titleLBL];
        self.titleLBL.textColor=[UIColor whiteColor];
        self.titleLBL.textAlignment=NSTextAlignmentCenter;
        self.titleLBL.font=[UIFont fontWithName:k_fontSemiBold size:15];
        self.titleLBL.alpha=0.5;

        self.titleLBL.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

    }
    return self;
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if(selected==true)
    {
        self.titleLBL.alpha=1;
    }
    else
    {
        self.titleLBL.alpha=0.5;
    }
    
}
@end


