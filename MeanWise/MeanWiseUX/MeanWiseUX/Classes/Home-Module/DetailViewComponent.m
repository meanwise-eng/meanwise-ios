//
//  DetailViewComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 28/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "DetailViewComponent.h"
#import "PostFullCell.h"
#import "APIObjects_FeedObj.h"


@implementation DetailViewComponent

-(void)setDataRecords:(NSMutableArray *)array;
{
    dataRecords=array;
    [galleryView reloadData];
}
-(void)setUpWithCellRect:(CGRect)rect
{
    self.backgroundColor=[UIColor clearColor];
    
    
    [self setUpCellRectResizer:rect];

    containerView.backgroundColor=[UIColor whiteColor];
    self.clipsToBounds=YES;
   
       postIMGVIEW=[[UIImageHM alloc] initWithFrame:containerView.bounds];
      //  postIMGVIEW.image=[UIImage imageNamed:@"post_3.jpeg"];
        postIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
        [containerView addSubview:postIMGVIEW];
    
        postIMGVIEW.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        postIMGVIEW.clipsToBounds=YES;
    
    
    containerView.clipsToBounds=YES;
    NSLog(@"%@",NSStringFromCGRect(containerView.frame));
    
    NSLog(@"%@",NSStringFromCGRect(rect));
    
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    CGRect collectionViewFrame = self.bounds;
    galleryView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    galleryView.delegate = self;
    galleryView.dataSource = self;
    galleryView.pagingEnabled = YES;
    galleryView.showsHorizontalScrollIndicator = NO;
    
    [galleryView registerClass:[PostFullCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    
    [containerView addSubview:galleryView];
    




    [self zoomDownGestureDetected];
    [self setUpCellRectResizerAnimate];

    
}
-(void)setColorNumber:(int)number
{
    colorNumber=number;
    
}
-(void)setImage:(NSString *)string andNumber:(NSIndexPath *)indexPath
{
    if([string isEqualToString:@"red"])
    {
        
        postIMGVIEW.backgroundColor=[Constant colorGlobal:colorNumber];
        [postIMGVIEW clearImageAll];

    }
    else
    {
        postIMGVIEW.backgroundColor=[UIColor whiteColor];
        [postIMGVIEW clearImageAll];

        [postIMGVIEW setUp:string];

    }
    
    globalPath=indexPath;
    [galleryView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
    
    [self performSelector:@selector(playFirstVideo) withObject:nil afterDelay:0.5];
    
}


-(void)zoomDownGestureDetected
{
    galleryView.hidden=true;

    postIMGVIEW.hidden=false;
    
}
-(void)zoomDownGestureEnded
{
    galleryView.hidden=false;
    postIMGVIEW.hidden=true;
    


}
-(void)zoomDownOut
{
    
    [delegate performSelector:downCallBackFunc withObject:globalPath afterDelay:0.0001];

 
    
    NSArray *array=galleryView.visibleCells;
    for(int i=0;i<array.count;i++)
    {
        PostFullCell *cell=[array objectAtIndex:i];
        [cell removeURL];
    }

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PostFullCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    

    [cell setDataObj:[dataRecords objectAtIndex:indexPath.row]];
    [cell setTarget:self shareBtnFunc:@selector(shareBtnClicked:) andCommentBtnFunc:@selector(commentBtnClicked:)];

    /*
    cell.profileIMGVIEW.image=[UIImage imageNamed:[NSString stringWithFormat:@"profile%d.jpg",(int)indexPath.row%5+3]];
    
    int mediaType=[[[dataRecords objectAtIndex:indexPath.row] valueForKey:@"postType"] intValue];
    
    int colorN=[[[dataRecords objectAtIndex:indexPath.row] valueForKey:@"color"] intValue];
    
    
    
    [cell setUpMediaType:mediaType andColorNumber:colorN];
    
    if(mediaType==2)
    {
        NSString *videoURL=[[dataRecords objectAtIndex:indexPath.row] valueForKey:@"videoURL"];
        [cell setURL:videoURL];
    }
    else
    {
        [cell removeURL];
    }
    
    if(mediaType!=0)
    {
        NSString *imgURL=[[dataRecords objectAtIndex:indexPath.row] valueForKey:@"imageURL"];
        cell.postIMGVIEW.image=[UIImage imageNamed:imgURL];
    }
    else
    {
        
    }
    */
    
    return cell;
    
}
-(void)shareBtnClicked:(NSString *)senderId
{
    if(sharecompo==nil)
    {
        
        sharecompo=[[ShareComponent alloc] initWithFrame:self.bounds];
        [sharecompo setUp];
        [sharecompo setTarget:self andCloseBtnClicked:@selector(commentFullClosed:)];
        
        [self addSubview:sharecompo];
    }
    
}
-(void)commentBtnClicked:(NSString *)senderId
{
    if(commentDisplay==nil)
    {
        
        
        commentDisplay=[[FullCommentDisplay alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        [commentDisplay setUpWithPostId:[NSString stringWithFormat:@"%@",senderId]];
        [self addSubview:commentDisplay];
        [commentDisplay setTarget:self andCloseBtnClicked:@selector(commentFullClosed:)];
        
        
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
            
            commentDisplay.frame=self.bounds;
            
        } completion:^(BOOL finished) {
            
            
            
        }];
    }
    
}
-(void)commentFullClosed:(id)sender
{
    
    commentDisplay=nil;
    sharecompo=nil;
}
-(void)setUpNewScrolledRect:(CGRect)rect
{
    cellRect=rect;
}
-(void)setDelegate:(id)target andPageChangeCallBackFunc:(SEL)function1 andDownCallBackFunc:(SEL)function2;
{
    delegate=target;
    pageChangeCallBackFunc=function1;
    downCallBackFunc=function2;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataRecords.count;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = galleryView.frame.size.width;
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
    APIObjects_FeedObj *obj=[dataRecords objectAtIndex:indexPath.row];

    [postIMGVIEW clearImageAll];
    
    
    int mediaType=[obj.mediaType intValue];

    if(mediaType!=0)
    {
        NSString *imgURL=obj.image_url;
        [postIMGVIEW setUp:imgURL];
        postIMGVIEW.backgroundColor=[UIColor whiteColor];
    }
    else
    {
       // int colorNumber1=[[[dataRecords objectAtIndex:indexPath.row] valueForKey:@"color"] intValue];
        
        int colorNumber1=[obj.colorNumber intValue];
        [postIMGVIEW clearImageAll];
        postIMGVIEW.backgroundColor=[Constant colorGlobal:colorNumber1];
        
    }

    
    globalPath=indexPath;

    [delegate performSelector:pageChangeCallBackFunc withObject:indexPath afterDelay:0.01];
    
   
    [self playFirstVideo];

}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate==false)
    {
        [self playFirstVideo];
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [(PostFullCell *)cell removeURL];

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}
-(void)playFirstVideo
{
        NSLog(@"cell Changed");
        
        
        NSArray *visibleCells=[galleryView visibleCells];
        
        for(int i=0;i<visibleCells.count;i++)
        {
            PostFullCell *cell=[visibleCells objectAtIndex:i];
            
            [cell pausePlayer];
            [cell setMute];
            
        }
        
        for(int i=0;i<visibleCells.count;i++)
        {
            PostFullCell *cell=[visibleCells objectAtIndex:i];
            
            CGRect rect=cell.frame;
            
            rect=CGRectMake(cell.frame.origin.x-galleryView.contentOffset.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
            
            
            if(rect.origin.y<10 && rect.origin.y>-10)
            {
                [cell setUnMute];
                
                
                //   [cell playVideoIfAvaialble];
                
                
                //        UIView *view=[[UIView alloc] initWithFrame:rect];
                //        [self addSubview:view];
                //        view.backgroundColor=[UIColor blackColor];
                //        view.alpha=0.5;
                //
                //        [UIView animateWithDuration:0.5 animations:^{
                //            view.alpha=0;
                //            
                //        } completion:^(BOOL finished) {
                //            [view removeFromSuperview];
                //        }];
            }
            
            
        }
        
    

}



@end
