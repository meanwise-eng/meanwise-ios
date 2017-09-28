//
//  FullCommentDisplay.m
//  MeanWiseUX
//
//  Created by Hardik on 24/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "FullCommentDisplay.h"
#import "CommentCell.h"
#import "APIObjects_CommentObj.h"
#import "APIObjectsParser.h"
#import "FTIndicator.h"
#import "DataSession.h"
#import "UITextViewSuggestionHelper.h"
#import "UIColor+Hexadecimal.h"
#import "ResolutionVersion.h"

@interface FullCommentDisplay()
{
UITextViewSuggestionsBox *suggestionView;
UITextViewAutoSuggestionsDataSource *acHelper;
}

@end

@implementation FullCommentDisplay



-(void)setUpWithPostId:(NSString *)postIdString;
{
    currentKeyboardHeight=0;
    pageManager=[[APIExplorePageManager alloc] init];

    postId=postIdString;
    
    refreshForNewPost=false;
    newCommentBoxTextViewHeight=kk_chatHeadMinHeight;
    [AnalyticsMXManager PushAnalyticsEventAction:@"Comment Screen General"];

    wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    commentsData=[[NSMutableArray alloc] init];
    
  
    [self setUpBasicUI];

    


    newCommentBox=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-newCommentBoxTextViewHeight, self.frame.size.width, newCommentBoxTextViewHeight)];
    [self addSubview:newCommentBox];
    newCommentBox.backgroundColor=[UIColor colorWithWhite:1 alpha:0.2];

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = newCommentBox.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [newCommentBox addSubview:blurEffectView];
    
    
    newCommentTextView=[[SAMTextView alloc] initWithFrame:CGRectMake(newCommentBox.frame.origin.x, newCommentBox.frame.origin.y+5, newCommentBox.frame.size.width-60, newCommentBox.frame.size.height-10)];
    newCommentTextView.font=kk_chatFont;
    newCommentTextView.returnKeyType=UIReturnKeySend;
    newCommentTextView.editable=true;
    newCommentTextView.backgroundColor=[UIColor clearColor];
    newCommentTextView.textColor=[UIColor blackColor];
    newCommentTextView.placeholder=@"Leave a comment";
    newCommentTextView.delegate=self;
    newCommentTextView.inputAccessoryView=[[UIView alloc] init];
    [self addSubview:newCommentTextView];
    newCommentTextView.scrollEnabled=false;
    

    
    
    sendBtn=[[UIButton alloc] initWithFrame:CGRectMake(newCommentBox.frame.size.width-60, newCommentBox.frame.origin.y, 60,60)];
    [sendBtn setTitleColor:[UIColor colorWithHexString:@"66ccff"] forState:UIControlStateNormal];
    sendBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    [sendBtn setTitle:@"Post" forState:UIControlStateNormal];
    sendBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:14];
    [sendBtn addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendBtn];

    newCommentBoxBottomOrigin=newCommentTextView.frame.origin.y+newCommentTextView.frame.size.height;

    
    
    
    
    suggestionView=[[UITextViewSuggestionsBox alloc] initWithFrame:CGRectMake(-5, 0, self.frame.size.width+10, 0)];
    suggestionView.backgroundColor=[UIColor grayColor];
    [self addSubview:suggestionView];
    [suggestionView setUp];
    [suggestionView setPotisionUp:YES andThemeDark:false];
    [suggestionView setTarget:self onSelect:@selector(suggestionSelected:)];
    
    acHelper=[[UITextViewAutoSuggestionsDataSource alloc] init];

    [acHelper setTextView:newCommentTextView];
    [acHelper setSuggestionView:suggestionView];
    [acHelper setUp];
    [acHelper setShouldDisableHashTags:true];

    
    
    [self manuallyRefresh];
    [self textViewDidChange:newCommentTextView];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];


}


#pragma mark - TextView

- (void)textViewDidBeginEditing:(UITextView *)textView
{
//    [self animateTextViewToUpFlag: YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
//    [self animateTextViewToUpFlag:NO];
    [acHelper cancelSearch];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateKeyboardPosition];
        [acHelper textViewDidChange:textView];

    
}
-(void)updateKeyboardPosition
{
    CGSize size = [newCommentTextView sizeThatFits:CGSizeMake(newCommentTextView.frame.size.width, FLT_MAX)];
    float height=size.height;
    
    if(height<kk_chatHeadMinHeight)
    {
        height=kk_chatHeadMinHeight;
    }
    
    //
    
  
    
    newCommentBoxTextViewHeight=height;
    newCommentBoxTextViewHeight=newCommentBoxTextViewHeight+20;

    newCommentBox.frame=CGRectMake(0, self.frame.size.height-newCommentBoxTextViewHeight-currentKeyboardHeight, self.frame.size.width, newCommentBoxTextViewHeight);
    
    newCommentTextView.frame=CGRectMake(0, self.frame.size.height-newCommentBoxTextViewHeight-currentKeyboardHeight+5, self.frame.size.width-60, newCommentBoxTextViewHeight-10);
    
    
    sendBtn.frame=CGRectMake(sendBtn.frame.origin.x, self.frame.size.height-newCommentBoxTextViewHeight-currentKeyboardHeight, sendBtn.frame.size.width, newCommentBoxTextViewHeight);

    
    CGFloat topCorrect = ([newCommentTextView bounds].size.height - [newCommentTextView contentSize].height * [newCommentTextView zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    [newCommentTextView setContentInset:UIEdgeInsetsMake(topCorrect,0,0,0)];
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
    BOOL flag= [acHelper textView:textView shouldChangeTextInRange:range replacementText:text];

    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        
        
        [self sendBtnClicked:nil];
        
        
        
        return NO;
    }
    
    return textView.text.length + (text.length - range.length) <= 195;

    
}
-(void) animateTextViewToUpFlag:(BOOL) up
{
    int baseHeight=self.frame.size.height-newCommentBoxTextViewHeight;
    
    int height=0;
    
    if(up==false)
    {
        height=baseHeight;
    }
    else
    {
        height=baseHeight-currentKeyboardHeight;
    }
    
    CGRect boxRect=CGRectMake(0, height, self.frame.size.width, newCommentBoxTextViewHeight);

    
    [UIView animateWithDuration:0.1 animations:^{
        
        newCommentTextView.alpha=0.5;
        newCommentBox.alpha=0.5;
        sendBtn.alpha=0.5;
        
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            newCommentTextView.alpha=1.0f;
            newCommentBox.alpha=1.0f;
            sendBtn.alpha=1.0f;
            
            newCommentBox.frame=boxRect;
            newCommentTextView.frame=CGRectMake(0, boxRect.origin.y+5, boxRect.size.width-60, boxRect.size.height);
            sendBtn.frame=CGRectMake(boxRect.size.width-60, boxRect.origin.y, 60, sendBtn.frame.size.height);
            
        }];

        
    }];
    
    

}

#pragma mark - API calls

-(void)refreshAction
{
    
    
    emptyView.hidden=true;
    
    [pageManager reset];
    
    manager=[[APIManager alloc] init];
    [manager sendRequestForComments:postId delegate:self andSelector:@selector(commentListReceived:)];
    //[commentList setContentOffset:CGPointMake(0, commentList.contentOffset.y-commentList.frame.size.height/2) animated:YES];
    
}

-(void)manuallyRefresh
{
    emptyView.hidden=true;
    
    [AnalyticsMXManager PushAnalyticsEventAction:@"Comment Screen Refresh"];
    

    [self refreshAction];
        
    
}
-(void)commentListReceived:(APIResponseObj *)responseObj
{
    commentList.userInteractionEnabled=true;
    
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async( dispatch_get_main_queue(), ^{
            
            
            if(responseObj.statusCode==200)
            {
                NSArray *response;
                if([responseObj.response isKindOfClass:[NSArray class]])
                {
                    response=[NSMutableArray arrayWithArray:(NSArray *)responseObj.response];
                }
                else
                {
                    
                    response=[NSMutableArray arrayWithArray:[(NSArray *)responseObj.response valueForKey:@"data"]];
                }
                
                [pageManager setOutPutParameters:responseObj];
                
                
                APIObjectsParser *parser=[[APIObjectsParser alloc] init];
                NSMutableArray *responseArray=[NSMutableArray arrayWithArray:[parser parseObjects_COMMENTS:response]];
                
                
                if(refreshForNewPost==true)
                {
                    commentsData=[[NSMutableArray alloc] init];
                    [commentList reloadData];
                    refreshForNewPost=false;

                }
                
                UICollectionView *collectionView=(UICollectionView *)commentList;
                
                
                
                [collectionView performBatchUpdates:^{
                    
                    NSMutableArray *newIndexs=[[NSMutableArray alloc] init];
                    
                    
                    for(int i=0;i<responseArray.count;i++)
                    {
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                        [newIndexs addObject:indexPath];
                    }
                    
                    
                    [collectionView insertItemsAtIndexPaths:newIndexs];
                    
                    NSMutableArray *arrayTemp=[NSMutableArray arrayWithArray:commentsData];
                    commentsData=[NSMutableArray arrayWithArray:responseArray];
                    [commentsData addObjectsFromArray:arrayTemp];
                    
                    

                    
                    
                } completion:^(BOOL finished) {
                    
                        [self scrollToLastItem:false];
                }];
                
                
                
                
                
                ////
                if(commentsData.count==0)
                {
                    emptyView.hidden=false;
                    emptyView.msgLBL.text=@"No Comments";
                    
                }
                else
                {
                    emptyView.hidden=true;
                }
                
                
                
                
            }
            
            
        });
    });

}

-(void)callPreviousData
{
    
    NSString *backURL=pageManager.previousRecordURLstr;
    
    manager=[[APIManager alloc] init];
    [manager sendRequestExploreFeedWithURL:backURL Withdelegate:self andSelector:@selector(commentListReceived:)];
    
    
}

#pragma mark - Comment Post
-(void)sendBtnClicked:(id)sender
{
    [AnalyticsMXManager PushAnalyticsEventAction:@"Comment Post"];
    
    [newCommentTextView resignFirstResponder];
    
    NSString *msg=newCommentTextView.text;
    
    newCommentTextView.text=@"";
    [self textViewDidChange:newCommentTextView];
    
    
    
    NSDictionary *dict1=@{
                          @"comment_text":msg,
                          @"commented_by":[UserSession getUserId],
                          @"mentioned_users":[acHelper getAllUniqueUserMentionsIds]
                          };
    
    manager=nil;
    manager=[[APIManager alloc] init];
    [manager sendRequestForAddingNewComment:postId withData:dict1 delegate:self andSelector:@selector(newCommentSent:)];
    
    
    
    
    
    
    //  chatMessages
}
-(void)newCommentSent:(APIResponseObj *)obj
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        refreshForNewPost=true;
        [self refreshAction];
    });
    
    
    
}

#pragma mark - Comment Delete
-(void)onCommentDeleteBtnClicked:(NSString *)commentId
{
    
    [AnalyticsMXManager PushAnalyticsEventAction:@"Comment Delete"];
    
    APIManager  *manager1=[[APIManager alloc] init];
    [manager1 sendRequestForDeleteComment:commentId postId:[NSString stringWithFormat:@"%@",postId] delegate:self andSelector:@selector(commnentDeleteResponse:)];
    
}
-(void)commnentDeleteResponse:(NSArray *)array
{
    APIResponseObj *obj=[array objectAtIndex:0];
    NSString *coId=[array objectAtIndex:1];
    
    if(obj.statusCode==200)
    {
        
        
        int index=-1;
        for(int i=0;i<[commentsData count];i++)
        {
            APIObjects_CommentObj *object=[commentsData objectAtIndex:i];
            
            if([[NSString stringWithFormat:@"%@",coId] isEqualToString:[NSString stringWithFormat:@"%@",object.commentId]])
            {
                index=i;
            }
            
        }
        
        
        if(index!=-1)
        {
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForItem:index inSection:0];
            
            [commentList performBatchUpdates:^{
                
                NSArray *selectedItemsIndexPaths = @[indexPath];
                
                // Delete the items from the data source.
                [commentsData removeObjectAtIndex:indexPath.row];
                
                // Now delete the items from the collection view.
                [commentList deleteItemsAtIndexPaths:selectedItemsIndexPaths];
                
            } completion:^(BOOL finished) {
                
                if(commentsData.count==0)
                {
                    [self manuallyRefresh];
                }
                
            }];
        }
        
        [FTIndicator showToastMessage:@"Deleted"];
        
    }
    else
    {
        [FTIndicator showToastMessage:@"Something went wrong"];
        
    }
    
}
#pragma mark - Flow
-(void)backBtnClicked:(id)sender
{
 
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.frame=CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [delegate performSelector:closeBtnClicked withObject:nil afterDelay:0.01f];
        [self removeFromSuperview];
        
    }];

}
-(void)setTarget:(id)target andCloseBtnClicked:(SEL)func1;
{
    delegate=target;
    closeBtnClicked=func1;
}
-(void)setUpToWriteComment;
{
    [self performSelector:@selector(openUpKeyboard) withObject:nil afterDelay:1.0f];
}
-(void)openUpKeyboard
{
    
    [newCommentTextView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
    
}
#pragma mark - UI
-(void)setUpBasicUI
{
    self.backgroundColor=[UIColor clearColor];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:blurEffectView];
    
    
    
    navBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 65)];
    [self addSubview:navBar];
    navBar.backgroundColor=[UIColor clearColor];
    
    navBarTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 65-20)];
    [navBar addSubview:navBarTitle];
    navBarTitle.text=@"Replies";
    navBarTitle.textColor=[UIColor whiteColor];
    navBarTitle.textAlignment=NSTextAlignmentCenter;
    navBarTitle.font=[UIFont fontWithName:k_fontSemiBold size:18];
    
    backBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 60, 40, 40)];
    [backBtn setShowsTouchWhenHighlighted:YES];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    backBtn.center=CGPointMake(self.frame.size.width-10-25/2, 20+65/2-10);
    
    self.clipsToBounds=YES;
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 5;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    commentList = [[UICollectionView alloc] initWithFrame:CGRectMake(12, 65, self.frame.size.width-24, self.frame.size.height-65-newCommentBoxTextViewHeight) collectionViewLayout:layout];
    commentList.delegate = self;
    commentList.dataSource = self;
    commentList.pagingEnabled = false;
    commentList.showsHorizontalScrollIndicator = false;
    commentList.backgroundColor=[UIColor clearColor];
    [commentList registerClass:[CommentCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:commentList];
    commentList.pagingEnabled=true;
    commentList.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    commentList.backgroundColor=[UIColor clearColor];
    commentList.alwaysBounceVertical=YES;
    
    
    emptyView=[[EmptyView alloc] initWithFrame:commentList.frame];
    [self addSubview:emptyView];
    [emptyView setUIForBlack];
    emptyView.hidden=true;
    emptyView.reloadBtn.hidden=true;
    [emptyView setDelegate:self onReload:@selector(manuallyRefresh)];
    
    
    
    
}
- (void)keyboardWillHide:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    //CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    // Write code to adjust views accordingly using kbSize.height
    currentKeyboardHeight = 0.0f;
    [self updateKeyboardPosition];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //  CGFloat deltaHeight = kbSize.height - currentKeyboardHeight;
    // Write code to adjust views accordingly using deltaHeight
    currentKeyboardHeight = kbSize.height;
    
    if(RX_isiPhone5Res)
    {
        currentKeyboardHeight=currentKeyboardHeight+45;
    }
     [self updateKeyboardPosition];
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    [[IQKeyboardManager sharedManager] setEnable:wasKeyboardManagerEnabled];
    // [[IQKeyboardManager sharedManager] setEnableAutoToolbar:wasKeyboardManagerEnabled];
    
    
}

#pragma mark - CollectionView
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    
    
    APIObjects_CommentObj *obj=[commentsData objectAtIndex:indexPath.row];
    
    cell.commentId=[NSString stringWithFormat:@"%@",obj.commentId];
    [cell setTarget:self andOnDelete:@selector(onCommentDeleteBtnClicked:)];
    
    
    
    cell.personNameLBL.text=[NSString stringWithFormat:@"%@ %@",obj.user_first_name,obj.user_last_name];
    
    [cell setProfileImageURLString:obj.user_profile_photo_small];
    
    
    [cell setNameLBLText:obj];
    
    
    cell.timeLBL.text=obj.timeString;
    
    if([[NSString stringWithFormat:@"%@",obj.user_id] isEqualToString:[NSString stringWithFormat:@"%@",[UserSession getUserId]]])
    {
        cell.customDeleteBtn.hidden=false;
        cell.customDeleteBtn.enabled=true;
    }
    else
    {
        cell.customDeleteBtn.hidden=true;
        cell.customDeleteBtn.enabled=false;
    }
    
    // [cell setNameLBLText:[[chatMessages objectAtIndex:indexPath.row] valueForKey:@"msg"]];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return commentsData.count;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self sizingForRowAtIndexPath:indexPath];
    
}
- (CGSize)sizingForRowAtIndexPath:(NSIndexPath *)indexPath
{
    APIObjects_CommentObj *obj=[commentsData objectAtIndex:indexPath.row];
    
    return [self calculateText:obj.comment_text];
    
    
}
-(CGSize )calculateText:(NSString *)string
{
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, commentList.frame.size.width-80, 100)];
    
    
    label.textAlignment=NSTextAlignmentLeft;
    label.font=[UIFont fontWithName:k_fontRegular size:11];
    label.numberOfLines=0;
    
    label.text=string;
    
    CGFloat fixedWidth = label.frame.size.width;
    CGSize newSize = [label sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    
    CGRect newFrame = label.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height+10);
    
    int height=kk_CommentHeadMinHeight;
    if(newFrame.size.height>height)
    {
        height=newFrame.size.height;
    }
    
    return CGSizeMake(commentList.frame.size.width, height+11+30);
    
}
#pragma mark - Suggestions
-(void)suggestionSelected:(id)selectedItem
{
    [acHelper suggestionSelected:selectedItem];
}

#pragma mark - Other
-(void)commentListReceived1:(APIResponseObj *)responseObj
{
    NSArray *responseArray=[NSMutableArray arrayWithArray:[(NSArray *)responseObj.response valueForKey:@"data"]];
    APIObjectsParser *parser=[[APIObjectsParser alloc] init];
    
    NSArray *array=[parser parseObjects_COMMENTS:responseArray];
    array = [[array reverseObjectEnumerator] allObjects];
    
    commentsData=[NSMutableArray arrayWithArray:array];
    
    [pageManager setOutPutParameters:responseObj];
    
    
    [[DataSession sharedInstance] updateCommentCountForPostId:postId andCommentCount:(int)commentsData.count];
    
    if(commentsData.count==0)
    {
        emptyView.hidden=false;
    }
    [commentList reloadData];
    
    [self scrollToLastItem:false];
    
    
    
}
#pragma mark - Scroll
-(void)scrollToLastItem:(BOOL)animated
{
    
    [UIView animateWithDuration:0.5 delay:2.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        
    } completion:^(BOOL finished) {
        
        CGFloat collectionViewContentHeight = commentList.contentSize.height;
        CGFloat collectionViewFrameHeightAfterInserts = commentList.frame.size.height - (commentList.contentInset.top + commentList.contentInset.bottom);
        
        if(collectionViewContentHeight > collectionViewFrameHeightAfterInserts) {
            [commentList setContentOffset:CGPointMake(0, commentList.contentSize.height - commentList.frame.size.height) animated:NO];
        }
        
        
    }];
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //    if(scrollView.contentOffset.y<0)
    //    {
    //        [self callPreviousData];
    //    }
    
    //            if([pageManager ifNewCallRequired:scrollView inY:0])
    //            {
    //                [self callPreviousData];
    //            }
    //            else
    //            {
    //                int p=0;
    //            }
    
}
@end
