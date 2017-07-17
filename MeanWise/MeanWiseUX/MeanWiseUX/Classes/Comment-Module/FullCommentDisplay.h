//
//  FullCommentDisplay.h
//  MeanWiseUX
//
//  Created by Hardik on 24/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "IQKeyboardManager.h"
#import "APIManager.h"
#import "EmptyView.h"
#import "SAMTextView.h"


@interface FullCommentDisplay : UIView <UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
{
 
    EmptyView *emptyView;
    NSString *postId;
    
    APIManager *manager;
    UIView *navBar;
    UILabel *navBarTitle;
    UIButton *backBtn;
    
    UICollectionView *commentList;
    
    NSMutableArray *chatMessages;

    
    UIView *newChatBox;
    SAMTextView *newChatMessageBox;
    UIButton *sendBtn;
    
    id delegate;
    SEL closeBtnClicked;
    
    BOOL wasKeyboardManagerEnabled;
    UIRefreshControl *refreshControl;

}
-(void)setUpWithPostId:(NSString *)postIdString;
-(void)setUpToWriteComment;
-(void)setTarget:(id)delegate andCloseBtnClicked:(SEL)func1;

@end


/*
 #import "FullCommentDisplay.h"

 FullCommentDisplay *display;


 -(void)commentBtnClicked:(id)sender
 {
 if(display==nil)
 {
 doubleTap.enabled=false;
 
 
 display=[[FullCommentDisplay alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
 [display setUpWithPostId:[NSString stringWithFormat:@"%@",dataObj.postId]];
 [self.contentView addSubview:display];
 [display setTarget:self andCloseBtnClicked:@selector(commentFullClosed:)];
 
 
 
 [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
 
 display.frame=self.bounds;
 
 } completion:^(BOOL finished) {
 
 
 
 }];
 
 
 }
 
 }
 -(void)commentFullClosed:(id)sender
 {
 doubleTap.enabled=true;
 display=nil;
 }
 
*/
