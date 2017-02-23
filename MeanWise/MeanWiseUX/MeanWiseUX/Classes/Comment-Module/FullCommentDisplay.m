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

@implementation FullCommentDisplay
-(void)setTarget:(id)target andCloseBtnClicked:(SEL)func1;
{
    delegate=target;
    closeBtnClicked=func1;
}

-(void)setUpWithPostId:(NSString *)postIdString;
{
    postId=postIdString;
    
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
    
    
    chatMessages=[[NSMutableArray alloc] init];
    
    /*
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
        
        
        
    }*/
    
    
    self.clipsToBounds=YES;
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
   
    
    
    commentList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 65, self.frame.size.width, self.frame.size.height-65-kk_chatBoxTextViewHeight) collectionViewLayout:layout];
    commentList.delegate = self;
    commentList.dataSource = self;
    commentList.pagingEnabled = YES;
    commentList.showsHorizontalScrollIndicator = false;
    
    commentList.backgroundColor=[UIColor clearColor];
    [commentList registerClass:[CommentCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:commentList];
    
    commentList.pagingEnabled=true;
    
    
    emptyView=[[EmptyView alloc] initWithFrame:commentList.frame];
    [self addSubview:emptyView];
    [emptyView setUIForBlack];
    emptyView.hidden=true;
    [emptyView setDelegate:self onReload:@selector(manuallyRefresh)];

    newChatBox=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-kk_chatBoxTextViewHeight, self.frame.size.width, kk_chatBoxTextViewHeight)];
    [self addSubview:newChatBox];
    newChatBox.backgroundColor=[UIColor colorWithWhite:0 alpha:0.7f];
    
    
    newChatMessageBox=[[UITextView alloc] initWithFrame:CGRectMake(10, self.frame.size.height-(kk_chatBoxTextViewHeight-1), self.frame.size.width-20-50, (kk_chatBoxTextViewHeight-1))];
    [self addSubview:newChatMessageBox];
    newChatMessageBox.font=kk_chatFont;
    newChatMessageBox.returnKeyType=UIReturnKeySend;
    newChatMessageBox.editable=true;
    newChatMessageBox.backgroundColor=[UIColor clearColor];
    newChatMessageBox.textColor=[UIColor whiteColor];
    
    
    newChatMessageBox.keyboardAppearance=UIKeyboardAppearanceDark;
    
    newChatBox.hidden=false;
    newChatMessageBox.hidden=false;
    
    newChatMessageBox.delegate=self;
    

    
    
    sendBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-10-50, self.frame.size.height-(kk_chatBoxTextViewHeight-1), 50, kk_chatBoxTextViewHeight-1)];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setBackgroundColor:[UIColor clearColor]];
    [sendBtn setTitle:@"Send" forState:UIControlStateNormal];
    sendBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:14];
    [self addSubview:sendBtn];
    [sendBtn addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    



    refreshControl=[[UIRefreshControl alloc] init];
    [commentList addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    
    commentList.backgroundColor=[UIColor clearColor];
    refreshControl.backgroundColor=[UIColor clearColor];

    commentList.alwaysBounceVertical=YES;
    
    wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
  //  [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [newChatBox becomeFirstResponder];

    
    

    
    

   
    [self manuallyRefresh];

    
    
}
-(void)manuallyRefresh
{
    emptyView.hidden=true;
    
    
    [UIView animateWithDuration:0.25 delay:0.02 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        
        commentList.contentOffset = CGPointMake(0, -100);
        
    } completion:^(BOOL finished){
        
        
        [refreshControl beginRefreshing];
        [self refreshAction];
        
    }];
    
    
}
-(void)refreshAction
{
    emptyView.hidden=true;

    manager=[[APIManager alloc] init];
    [manager sendRequestForComments:postId delegate:self andSelector:@selector(commentListReceived:)];
    [commentList setContentOffset:CGPointMake(0, commentList.contentOffset.y-commentList.frame.size.height/2) animated:YES];

}
-(void)commentListReceived:(APIResponseObj *)responseObj
{
    NSArray *responseArray=[NSMutableArray arrayWithArray:(NSArray *)responseObj.response];
    APIObjectsParser *parser=[[APIObjectsParser alloc] init];
    
    
    
    NSArray *array=[parser parseObjects_COMMENTS:responseArray];
    array = [[array reverseObjectEnumerator] allObjects];

    chatMessages=[NSMutableArray arrayWithArray:array];
    

    
    
    if(chatMessages.count==0)
    {
        emptyView.hidden=false;

    }
    
    [commentList reloadData];
    
    
    
    [refreshControl endRefreshing];
    refreshControl.attributedTitle = nil;

    [self scrollToLastItem:false];


    
}
-(void)dealloc
{
    [[IQKeyboardManager sharedManager] setEnable:wasKeyboardManagerEnabled];
   // [[IQKeyboardManager sharedManager] setEnableAutoToolbar:wasKeyboardManagerEnabled];


}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self animateTextView: YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextView:NO];
}
-(void) animateTextView:(BOOL) up
{
    if(up==false)
    {

        [UIView animateWithDuration:0.2 animations:^{
            
            newChatMessageBox.frame=CGRectMake(10, self.frame.size.height-(kk_chatBoxTextViewHeight-1), self.frame.size.width-20-50, (kk_chatBoxTextViewHeight-1));
            
            sendBtn.frame=CGRectMake(self.frame.size.width-10-50, self.frame.size.height-(kk_chatBoxTextViewHeight-1), 50, kk_chatBoxTextViewHeight-1);

            
            newChatBox.frame=CGRectMake(0, self.frame.size.height-kk_chatBoxTextViewHeight, self.frame.size.width, kk_chatBoxTextViewHeight);
            
        }];
        
        
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{

            
            newChatMessageBox.frame=CGRectMake(10, self.frame.size.height-(kk_chatBoxTextViewHeight+300), self.frame.size.width-20-50, (kk_chatBoxTextViewHeight-1));
            
            sendBtn.frame=CGRectMake(self.frame.size.width-10-50, self.frame.size.height-(kk_chatBoxTextViewHeight+300), 50, kk_chatBoxTextViewHeight-1);

        newChatBox.frame=CGRectMake(0, self.frame.size.height-kk_chatBoxTextViewHeight-300, self.frame.size.width, kk_chatBoxTextViewHeight);
        }];

    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    
//    CGFloat fixedWidth = textView.frame.size.width;
//    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
//    CGRect newFrame = textView.frame;
//    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
//    
//    if(newFrame.size.height<kk_chatBoxTextViewHeight)
//    {
//        newFrame.size.height=kk_chatBoxTextViewHeight;
//    }
//    newFrame=CGRectMake(newFrame.origin.x, self.frame.size.height-newFrame.size.height, newFrame.size.width, newFrame.size.height);
//    
//    
//    
//    commentList.frame=CGRectMake(0, 65, self.frame.size.width, self.frame.size.height-(100+35+newFrame.size.height-kk_chatBoxTextViewHeight));
//    
//    
//    newChatBox.frame=CGRectMake(0, newFrame.origin.y-1, self.frame.size.width, 1);
//    
//    [commentList scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:chatMessages.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:false];
//    
//    textView.frame = newFrame;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        
//        CGRect collectionViewFrame = CGRectMake(0, 100-35, self.frame.size.width, self.frame.size.height-100-kk_chatBoxTextViewHeight+35);
//        
//        
//        [UIView animateWithDuration:0.3f animations:^(void){
//            
//            commentList.frame=collectionViewFrame;
//            
//            newChatBox.frame=CGRectMake(0, self.frame.size.height-kk_chatBoxTextViewHeight, self.frame.size.width, 1);
//            newChatMessageBox.frame=CGRectMake(10, self.frame.size.height-(kk_chatBoxTextViewHeight-1), self.frame.size.width-20, (kk_chatBoxTextViewHeight-1));
//            
//        }];
        
        [self sendBtnClicked:nil];
        
        
        
        return NO;
    }
    
    return YES;
}
-(void)sendBtnClicked:(id)sender
{
    [newChatMessageBox resignFirstResponder];

    NSString *msg=newChatMessageBox.text;
    
    newChatMessageBox.text=@"";
//    
//    NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:msg,@"msg",
//                        [NSNumber numberWithInt:arc4random()%2],@"sender",
//                        nil];
//    
//    [chatMessages addObject:dict];
//    
//    

    
    
    NSDictionary *dict1=@{
                          @"comment_text":msg,
                          @"commented_by":[UserSession getUserId],
                          };
    
    manager=nil;
    manager=[[APIManager alloc] init];
    [manager sendRequestForAddingNewComment:postId withData:dict1 delegate:self andSelector:@selector(newCommentSent:)];

    
    //[chatThreadCollectionView reloadData];
    
    
  
    
    //  chatMessages
}
-(void)newCommentSent:(APIResponseObj *)obj
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [refreshControl beginRefreshing];

        [self refreshAction];
    });

    
   /* [commentList performBatchUpdates:^{
        [commentList reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } completion:nil];
    
    
    [commentList scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:chatMessages.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:false];
    */
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor clearColor];
    
    
    
    APIObjects_CommentObj *obj=[chatMessages objectAtIndex:indexPath.row];
    
   
    [cell setNameLBLText:obj.comment_text];
    
    cell.personNameLBL.text=[NSString stringWithFormat:@"%@ %@",obj.user_first_name,obj.user_last_name];
    
    [cell setProfileImageURLString:obj.user_profile_photo_small];

    cell.timeLBL.text=obj.timeString;
    
   // [cell setNameLBLText:[[chatMessages objectAtIndex:indexPath.row] valueForKey:@"msg"]];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return chatMessages.count;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self sizingForRowAtIndexPath:indexPath];
    
}
- (CGSize)sizingForRowAtIndexPath:(NSIndexPath *)indexPath
{
    APIObjects_CommentObj *obj=[chatMessages objectAtIndex:indexPath.row];

    return [self calculateText:obj.comment_text];
    
    
}
-(CGSize )calculateText:(NSString *)string
{
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width*0.6, 100)];
    
    
    label.textAlignment=NSTextAlignmentLeft;
    label.font=[UIFont fontWithName:k_fontRegular size:13];
    label.numberOfLines=0;
    
    label.text=string;
    
    CGFloat fixedWidth = label.frame.size.width;
    CGSize newSize = [label sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    
    CGRect newFrame = label.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height+10);
    
    
    //label.frame = newFrame;
    //label.backgroundColor=[UIColor greenColor];
    
    int height=kk_CommentHeadMinHeight;
    if(newFrame.size.height>height)
    {
        height=newFrame.size.height;
    }
    
    return CGSizeMake(self.frame.size.width, height+35);
    
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
    
    
    
    
//    NSInteger section = [commentList numberOfSections] - 1;
//    NSInteger item = [commentList numberOfItemsInSection:section] - 1;
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
//    
//    if(chatMessages.count>3)
//    {
//    [commentList scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionBottom) animated:animated];
//    }
    
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


@end