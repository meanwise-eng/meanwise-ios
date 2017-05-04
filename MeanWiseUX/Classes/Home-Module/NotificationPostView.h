//
//  NotificationPostView.h
//  MeanWiseUX
//
//  Created by Hardik on 02/04/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareComponent.h"
#import "FullCommentDisplay.h"

@interface NotificationPostView : UIView <UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    ShareComponent *sharecompo;
    FullCommentDisplay *commentDisplay;
    
    
    NSArray *arrayData;
    UICollectionView *feedList;
    UIButton *backBtn;
    
    id target;
    SEL backBtnCallBack;
    
    NSString *screenIdentifier;

}
-(void)setTarget:(id)targetReceived backBtnCallBack:(SEL)func;

-(void)setUpWithPostId:(NSDictionary *)postFeedObj withComment:(BOOL)commentFlag;

@end
