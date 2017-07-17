//
//  EditSCTagListControl.m
//  MeanWiseUX
//
//  Created by Hardik on 29/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "EditSCTagListControl.h"
#import "Constant.h"
#import "FTIndicator.h"

@implementation EditSCTagListControl

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
    tagListCV.showsHorizontalScrollIndicator = NO;
    tagListCV.backgroundColor=[UIColor clearColor];
    [tagListCV registerClass:[EditSCTagLabelCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:tagListCV];
    
    

    
}


-(NSArray *)getCurrentTagList
{
    return [NSArray arrayWithArray:userTagList];
}
-(void)addNewTag:(NSString *)string
{
    

    string=[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    int flag=0;
    
    
    
    for(int i=0;i<[userTagList count];i++)
    {
        
        if([[[userTagList objectAtIndex:i] lowercaseString] isEqualToString:[string lowercaseString]])
        {
            [FTIndicator showToastMessage:@"Skill already added!"];
            flag=1;

        }
        
    }
    
    
    if(flag==0)
    {
    
    [userTagList addObject:string];
    [tagListCV reloadData];
    }
  
    
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EditSCTagLabelCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    
    
    
    NSString *str=[userTagList objectAtIndex:indexPath.row];
    
    [cell setUp:str target:self OnDelete:@selector(onRemoveTag:)];
    
    
    
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
    
    NSString *str=[userTagList objectAtIndex:indexPath.row];
    
    
    
    return [self calculatingSize:str];
}
-(CGSize)calculatingSize:(NSString *)str
{
    //setup
    UILabel *tagLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    tagLabel.text=str;
    tagLabel.font=[UIFont fontWithName:k_fontBold size:15];
    
    //calculating size
    [tagLabel sizeToFit];
    CGSize size=CGSizeMake(tagLabel.frame.size.width+30+20, tagLabel.frame.size.height+10);
    
    
    return size;
    
}

@end

@implementation EditSCTagLabelCell
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
    [target performSelector:onRemoveTagBtnClick withObject:tagName afterDelay:0.01];
    
}
-(void)setUp:(NSString *)str target:(id)targetReceived OnDelete:(SEL)func;
{
    target=targetReceived;
    onRemoveTagBtnClick=func;
    
    
    int asciiCode = [str characterAtIndex:0]; // 65

    self.backgroundColor=[Constant colorGlobal:asciiCode%12];
   // self.backgroundColor=[UIColor blueColor];
    
    tagName=str;
    
    //setup
    tagLabel.text=tagName;
    tagLabel.font=[UIFont fontWithName:k_fontBold size:15];
    
    
    //visual property
    tagLabel.textColor=[UIColor whiteColor];
    tagLabel.textAlignment=NSTextAlignmentLeft;
    
    
    
    
    
    //calculating size
    [tagLabel sizeToFit];
    CGSize size=CGSizeMake(tagLabel.frame.size.width+20, tagLabel.frame.size.height+10);
    
    //extra
    tagLabel.frame=CGRectMake(10, 0, tagLabel.frame.size.width, size.height);
    removeTagBtn.frame=CGRectMake(size.width, 0, 30, size.height);
    
    
    self.layer.cornerRadius=size.height/2;
    self.clipsToBounds=YES;
    
}

@end



