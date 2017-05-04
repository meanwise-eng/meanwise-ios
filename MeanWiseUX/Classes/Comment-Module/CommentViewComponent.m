//
//  CommentViewComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 12/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "CommentViewComponent.h"
#import "CommentCell.h"

@implementation CommentViewComponent

-(void)setUp
{
    chatMessages=[[NSMutableArray alloc] init];
    
    
    NSArray *randomMessages=[[NSArray alloc] initWithObjects:
                             @"yeah",
                             @"ok",
                             @"That's amazing!!.",
                             @"Hey How are you?",
                             @"Oh My god fine.",
                             @"So where are you now?",
                             @"for them, you are not even bound by the above copyright.", nil];
    
    for(int i=0;i<20;i++)
    {
        
        
        NSString *msg=[randomMessages objectAtIndex:arc4random()%(randomMessages.count)];
        
        
        NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:msg,@"msg",
                            [NSNumber numberWithInt:arc4random()%2],@"sender",
                            nil];
        
        [chatMessages addObject:dict];
        
        
        
    }
    
    
    self.clipsToBounds=YES;
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    
    
    commentList = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    commentList.delegate = self;
    commentList.dataSource = self;
    commentList.pagingEnabled = YES;
    commentList.showsHorizontalScrollIndicator = false;

    commentList.backgroundColor=[UIColor clearColor];
    [commentList registerClass:[CommentCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:commentList];

    commentList.pagingEnabled=true;
   
    [self scrollToLastItem:false];
    
}
-(void)scrollToLastItem:(BOOL)animated
{
    NSInteger section = [commentList numberOfSections] - 1;
    NSInteger item = [commentList numberOfItemsInSection:section] - 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
    [commentList scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionBottom) animated:animated];
    
    commentList.alpha=0;
    
    [self showComments];
}
-(void)showComments
{
    commentList.alpha=0;

    [UIView animateKeyframesWithDuration:0.5 delay:0.5 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{

        
    } completion:^(BOOL finished) {
        
        [self scrollViewDidScroll:commentList];

        [UIView animateKeyframesWithDuration:0.5 delay:0.5 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            commentList.alpha=1;
            
            
        } completion:^(BOOL finished) {
            
            
        }];
    }];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor clearColor];
    
    [cell setNameLBLText:[[chatMessages objectAtIndex:indexPath.row] valueForKey:@"msg"]];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return chatMessages.count;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.frame.size.width, 50);
//    return [self sizingForRowAtIndexPath:indexPath];
    
}
- (CGSize)sizingForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self calculateText:[[chatMessages objectAtIndex:indexPath.row] valueForKey:@"msg"]];
    
    
}
-(CGSize )calculateText:(NSString *)string
{
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width*0.6, 100)];
    
    
    label.textAlignment=NSTextAlignmentLeft;
    label.font=kk_chatFont;
    label.numberOfLines=0;
    
    label.text=string;
    
    CGFloat fixedWidth = label.frame.size.width;
    CGSize newSize = [label sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    
    CGRect newFrame = label.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height+20);
    
    
    //label.frame = newFrame;
    //label.backgroundColor=[UIColor greenColor];
    
    int height=kk_CommentHeadMinHeight;
    if(newFrame.size.height>height)
    {
        height=newFrame.size.height;
    }
    
    return CGSizeMake(self.frame.size.width, height);
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    NSArray *array=[commentList visibleCells];
    
    for(int i=0;i<[array count];i++)
    {
        
        UICollectionViewCell *cell=[array objectAtIndex:i];
        if(CGRectContainsRect(commentList.bounds, cell.frame))
        {
            cell.alpha=1;
        }
        else
        {
            cell.alpha=0;
        }
        
        
    }
    
    
}


@end
