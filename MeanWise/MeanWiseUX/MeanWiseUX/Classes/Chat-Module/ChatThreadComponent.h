//
//  ChatThreadComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@interface ChatThreadComponent : UIView <UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
{
    UIView *bgView;
     UIImageView *profileView;
    
    UICollectionView *chatThreadCollectionView;
    
    NSMutableArray *chatMessages;
    
    UIButton *backBtn;
    
    CGRect Oldframe;
    
    UIView *newChatBox;
    UITextView *newChatMessageBox;
    
   
}
-(void)setUpFrame:(CGRect)rect andImage:(UIImage *)image;

@end
