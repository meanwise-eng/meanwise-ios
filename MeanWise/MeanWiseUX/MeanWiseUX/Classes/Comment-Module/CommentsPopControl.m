//
//  CommentsPopControl.m
//  MeanWiseUX
//
//  Created by Hardik on 24/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "CommentsPopControl.h"
#import "CommentCell.h"
#import "APIObjectsParser.h"
#import "FTIndicator.h"
#import "UIColor+Hexadecimal.h"

@interface CommentsPopControl()
{
    
}

@end

@implementation CommentsPopControl

-(void)setUpWithPostId:(NSString *)postIdString
{
    wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];

    postId=postIdString;
    
    commentsData=[[NSMutableArray alloc] init];
    pageManager=[[APIExplorePageManager alloc] init];

    
  
    
    [self setUpBasicUI];
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    commentList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 65, self.frame.size.width, self.frame.size.height-65-40) collectionViewLayout:layout];
    commentList.delegate = self;
    commentList.dataSource = self;
    commentList.pagingEnabled = YES;
    commentList.showsHorizontalScrollIndicator = false;
    commentList.backgroundColor=[UIColor clearColor];
    [commentList registerClass:[CommentCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:commentList];
    commentList.pagingEnabled=true;
    commentList.backgroundColor=[UIColor clearColor];
    commentList.alwaysBounceVertical=YES;
   // commentList.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    commentList.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    
    chatBox=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 40)];
    [self addSubview:chatBox];
    chatBox.backgroundColor=[UIColor clearColor];
    
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = chatBox.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [chatBox addSubview:blurEffectView];

    
    chatTextView=[[SAMTextView alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width-50, 40)];
    [chatBox addSubview:chatTextView];
    chatTextView.returnKeyType=UIReturnKeySend;
    chatTextView.font=kk_chatFont;
    chatTextView.placeholder=@"Leave a comment";

    
    chatTextView.delegate=self;
    chatTextView.backgroundColor=[UIColor clearColor];
    chatTextView.scrollEnabled=false;
    chatTextView.inputAccessoryView=[[UIView alloc] init];
    
    chatSendBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-45, 0, 45, 40)];
    [chatBox addSubview:chatSendBtn];
    
    [chatSendBtn setTitle:@"Post" forState:UIControlStateNormal];
    [chatSendBtn setTitleColor:[UIColor colorWithHexString:@"66ccff"] forState:UIControlStateNormal];
    chatSendBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:14];


    
    [self setChatBoxAtPosY:self.frame.size.height];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self featchAllComments];
}
- (void)textViewDidChange:(UITextView *)textView
{
    [self setChatBoxAtPosY:currentKeyBoardHeight];
    
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   
    return textView.text.length + (text.length - range.length) <= 195;
}

-(void)setChatBoxAtPosY:(float)posY
{
    
    
    
    CGSize size = [chatTextView sizeThatFits:CGSizeMake(chatTextView.frame.size.width, FLT_MAX)];
    float height=size.height;

    if(height<40)
    {
        height=40;
    }
    
    chatBox.frame=CGRectMake(0, posY-height, self.frame.size.width, height);
    chatTextView.frame=CGRectMake(5, 0, self.frame.size.width-50, height);
    chatSendBtn.frame=CGRectMake(self.frame.size.width-45, 0, 45, height);
    
    
}
-(void)featchAllComments
{
    
    
    refreshForNewPost=true;
    [pageManager reset];
    
    manager=[[APIManager alloc] init];
    [manager sendRequestForComments:postId delegate:self andSelector:@selector(firstCommentsReceived:)];
    //[commentList setContentOffset:CGPointMake(0, commentList.contentOffset.y-commentList.frame.size.height/2) animated:YES];
    
}
-(void)firstCommentsReceived:(APIResponseObj *)responseObj
{
    
    
    
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
                   //D emptyView.hidden=false;
                  //D  emptyView.msgLBL.text=@"No Comments";
                    
                }
                else
                {
                   //D emptyView.hidden=true;
                }
                
                
                
                
            }
            
            
        });
    });
    
   
}
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
    
   
}
#pragma mark - Keyboard up down
- (void)keyboardWillHide:(NSNotification*)notification {
   
    NSDictionary *info = [notification userInfo];
    
    //CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    // Write code to adjust views accordingly using kbSize.height
    float temp = self.frame.size.height-0.0f;
    currentKeyBoardHeight=temp;
    [self setChatBoxAtPosY:currentKeyBoardHeight];

}

- (void)keyboardWillShow:(NSNotification*)notification {
   
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //  CGFloat deltaHeight = kbSize.height - currentKeyboardHeight;
    // Write code to adjust views accordingly using deltaHeight
   float temp = kbSize.height;
     currentKeyBoardHeight = self.frame.size.height-temp;

    [self setChatBoxAtPosY:currentKeyBoardHeight];
    
}
#pragma mark - CollectionView

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor clearColor];
    
    
    
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
                    [self featchAllComments];
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
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, commentList.frame.size.width*0.6, 100)];
    
    
    label.textAlignment=NSTextAlignmentLeft;
    label.font=[UIFont fontWithName:k_fontRegular size:13];
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
    
    return CGSizeMake(self.frame.size.width, height+35);
    
}

#pragma mark - Helper
-(void)setUpToWriteComment
{
    [self performSelector:@selector(openUpKeyboard) withObject:nil afterDelay:1.0f];

}
-(void)openUpKeyboard
{
    
    //[newCommentTextView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
    
}

-(void)setTarget:(id)target andCloseBtnClicked:(SEL)func1
{
    delegate=target;
    closeBtnClicked=func1;

    
}
-(void)backBtnClicked:(id)sender
{
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.frame=CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [delegate performSelector:closeBtnClicked withObject:nil afterDelay:0.01f];
        [self removeFromSuperview];
        
    }];
    
}
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
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    [[IQKeyboardManager sharedManager] setEnable:wasKeyboardManagerEnabled];

}

@end
