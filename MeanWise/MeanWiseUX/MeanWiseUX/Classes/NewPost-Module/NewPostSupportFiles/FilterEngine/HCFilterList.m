//
//  HCFilterList.m
//  Exacto
//
//  Created by Hardik on 19/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "HCFilterList.h"

@implementation HCFilterList

-(void)setTarget:(id)targetReceived OnFilterSelect:(SEL)func;
{
    target=targetReceived;
    filterSelectFunc=func;
    
}
-(void)setUp:(NSMutableArray *)masterFilter
{
    masterArray=masterFilter;
    
    UICollectionViewFlowLayout *cellLayout=[[UICollectionViewFlowLayout alloc] init];
    cellLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    cellLayout.sectionInset=UIEdgeInsetsMake(0, 20, 0, 20);
    
    filterList=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100) collectionViewLayout:cellLayout];
    [self addSubview:filterList];
    filterList.delegate=self;
    filterList.backgroundColor=[UIColor clearColor];
    filterList.showsHorizontalScrollIndicator=false;
    filterList.showsVerticalScrollIndicator=false;
    filterList.dataSource=self;
    [filterList registerClass:[HCFilterCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HCFilterCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    NSDictionary *dict=[masterArray objectAtIndex:indexPath.row];

    
    cell.nameLBL.text=[[dict valueForKey:@"MNAME"] uppercaseString];
    cell.clipsToBounds=YES;
    cell.layer.cornerRadius=self.frame.size.height/3;
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.height,self.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect cellRect = attributes.frame;
    
    CGRect cellFrameInSuperview = [collectionView convertRect:cellRect toView:[collectionView superview]];
    
    NSDictionary *dict=@{@"filterNo":[NSNumber numberWithInteger:indexPath.row],@"rect":[NSValue valueWithCGRect:cellFrameInSuperview]};

    [target performSelector:filterSelectFunc withObject:dict afterDelay:0.01];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return masterArray.count;
}


@end


@implementation HCFilterCell

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.clipsToBounds=YES;
        
        
        self.nameLBL=[[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:self.nameLBL];
        self.nameLBL.text=@"Awesome! How do you do that?";
        self.nameLBL.textColor=[UIColor whiteColor];
        self.nameLBL.textAlignment=NSTextAlignmentCenter;
        
        self.backgroundColor=[UIColor blackColor];
        self.nameLBL.textColor=[UIColor whiteColor];

        
    }
    return self;
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if(selected==true)
    {
        self.backgroundColor=[UIColor whiteColor];
        self.nameLBL.textColor=[UIColor blackColor];

   
    }
    else
    {
        self.backgroundColor=[UIColor blackColor];
        self.nameLBL.textColor=[UIColor whiteColor];

    }
}

@end

