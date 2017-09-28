//
//  CommentsPopControl.h
//  MeanWiseUX
//
//  Created by Hardik on 24/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIManager.h"
#import "APIExplorePageManager.h"
#import "SAMTextView.h"
#import "IQKeyboardManager.h"



@interface CommentsPopControl : UIView  <UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
{
    NSMutableArray *commentsData;
    NSString *postId;
    UICollectionView *commentList;
    BOOL refreshForNewPost;
    
    APIExplorePageManager *pageManager;
    APIManager *manager;

    BOOL wasKeyboardManagerEnabled;
   
    UIView *navBar;
    UILabel *navBarTitle;
    UIButton *backBtn;
    id delegate;
    SEL closeBtnClicked;

    
    UIView *chatBox;
    SAMTextView *chatTextView;
    UIButton *chatSendBtn;
    
    float currentKeyBoardHeight;
}
-(void)setUpWithPostId:(NSString *)postIdString;
-(void)setUpToWriteComment;
-(void)setTarget:(id)delegate andCloseBtnClicked:(SEL)func1;

@end


/*

 ++ Comments screen design
 +++ Pagination
 +++ New comment add
 +++ Delete comment
 +++ Suggestion box
 +++ Apply text field design
 +++ Paging
 
*/
 
