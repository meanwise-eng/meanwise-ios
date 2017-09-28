//
//  EditTagListControl.m
//  MeanWiseUX
//
//  Created by Hardik on 29/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "EditTagListControl.h"
#import "Constant.h"

@implementation EditTagListControl

-(void)setUp:(NSMutableArray *)array
{
    userTagList=[NSMutableArray arrayWithArray:array];
    
    
    
    self.backgroundColor=[UIColor whiteColor];
    
    
    UICollectionViewLeftAlignedLayout* layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    //layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    
    
    CGRect collectionViewFrame = self.bounds;
    
    
    tagListCV = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    tagListCV.delegate = self;
    tagListCV.dataSource = self;
    //  interestCollectionView.pagingEnabled = YES;
    tagListCV.showsHorizontalScrollIndicator = NO;
    tagListCV.backgroundColor=[UIColor clearColor];
    [tagListCV registerClass:[EditTagLabelCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    [self addSubview:tagListCV];

    
}
-(NSArray *)getCurrentTagList
{
    return [NSArray arrayWithArray:userTagList];
}
-(void)addNewTag:(NSDictionary *)dict
{
    [userTagList addObject:dict];
    [tagListCV reloadData];
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EditTagLabelCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    
    
    
    NSDictionary *dict=[userTagList objectAtIndex:indexPath.row];
    
    [cell setUp:dict target:self OnDelete:@selector(onRemoveTag:)];

    
    
    return cell;
}
-(void)onRemoveTag:(NSDictionary *)info
{
    
  
    
    
    [tagListCV performBatchUpdates:^{
        
        
        int deletingItem=-1;
        
        for(int i=0;i<[userTagList count];i++)
        {
            NSDictionary *dict=[userTagList objectAtIndex:i];
            
            if(dict==info)
            {
                [userTagList removeObjectAtIndex:i];
                deletingItem=i;
                break;
            }
        }
        
        NSArray *selectedItemsIndexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:deletingItem inSection:0], nil];

        // Now delete the items from the collection view.
        [tagListCV deleteItemsAtIndexPaths:selectedItemsIndexPaths];
        
    } completion:nil];

   
    
    [tagListCV reloadData];
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return userTagList.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dict=[userTagList objectAtIndex:indexPath.row];

    
    
    return [self calculatingSize:dict];
}
-(CGSize)calculatingSize:(NSDictionary *)dict
{
    //setup
    UILabel *tagLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    tagLabel.text=[[dict valueForKey:@"text"] lowercaseString];
    tagLabel.font=[UIFont fontWithName:k_fontBold size:15];
    
    //calculating size
    [tagLabel sizeToFit];
    CGSize size=CGSizeMake(tagLabel.frame.size.width+30+20, tagLabel.frame.size.height+10);
    
    
    return size;

}

@end

@implementation EditTagLabelCell
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        
        tagLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:tagLabel];
        removeTagBtn=[[UIButton alloc] initWithFrame:CGRectZero];
        [removeTagBtn setTitle:@"x" forState:UIControlStateNormal];
        removeTagBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:15];
        removeTagBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        [removeTagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        removeTagBtn.backgroundColor=[UIColor colorWithWhite:1 alpha:0.5];
        [self.contentView addSubview:removeTagBtn];
        
        [removeTagBtn addTarget:self action:@selector(removeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        

    }
    return self;
}
-(void)removeBtnClicked:(id)sender
{
    [target performSelector:onRemoveTagBtnClick withObject:tagInfo afterDelay:0.01];
    
}
-(void)setUp:(NSDictionary *)dict target:(id)targetReceived OnDelete:(SEL)func;
{
     target=targetReceived;
     onRemoveTagBtnClick=func;
    
    int skillNo=[[dict valueForKey:@"id"] intValue];
    
  
    
    tagInfo=dict;
    
    //setup
    if(skillNo!=-1)
    {
    tagLabel.text=[[dict valueForKey:@"text"] lowercaseString];
    }
    else
    {
        tagLabel.text=[dict valueForKey:@"text"] ;

    }
    tagLabel.font=[UIFont fontWithName:k_fontBold size:15];

    
    //visual property
    
    
    //calculating size
    [tagLabel sizeToFit];
    CGSize size=CGSizeMake(tagLabel.frame.size.width+20, tagLabel.frame.size.height+10);
    
    //extra
    tagLabel.frame=CGRectMake(10, 0, tagLabel.frame.size.width, size.height);
    removeTagBtn.frame=CGRectMake(size.width, 0, 30, size.height);
    
    
    
    if(skillNo!=-1)
    {
        self.layer.cornerRadius=size.height/2;
        tagLabel.textColor=[UIColor whiteColor];
        tagLabel.textAlignment=NSTextAlignmentLeft;
        self.backgroundColor=[Constant colorGlobal:skillNo%12];
        self.layer.borderWidth=0;
        [removeTagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }
    else
    {
        self.layer.cornerRadius=5;
        tagLabel.textColor=[UIColor lightGrayColor];
        tagLabel.textAlignment=NSTextAlignmentLeft;
        self.backgroundColor=[UIColor whiteColor];
        self.layer.borderWidth=1;
        self.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [removeTagBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    }

    self.clipsToBounds=YES;

}

@end



