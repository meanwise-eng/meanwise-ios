//
//  PostCollectionView.h
//  MeanWiseUX
//
//  Created by Hardik on 04/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmptyView.h"
#import "DetailViewComponent.h"


@interface PostCollectionView : UIView < UICollectionViewDelegate,UICollectionViewDataSource >
{
    UICollectionView *feedList;

    NSMutableArray *resultData;
    EmptyView *emptyView;
    
    CGSize cellSize;
    

    DetailViewComponent *detailPostView;
}
-(void)setUp;


//Detail link [DONE]
//Bottom bar callback
//Paging
//Double Layout
//sizing

@end


