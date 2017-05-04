//
//  CommentViewComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 12/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@interface CommentViewComponent : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *commentList;

    NSMutableArray *chatMessages;

}
-(void)setUp;

@end
