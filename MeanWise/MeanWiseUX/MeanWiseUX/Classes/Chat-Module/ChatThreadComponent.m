//
//  ChatThreadComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "ChatThreadComponent.h"
#import "ChatLineCell.h"

@implementation ChatThreadComponent

-(void)setUpFrame:(CGRect)rect andImage:(UIImage *)image
{
    kk_chatBoxTextViewHeight=60;
    chatMessages=[[NSMutableArray alloc] init];
    
    
    NSArray *randomMessages=[[NSArray alloc] initWithObjects:@"This basically says do whatever you please with this software except remove this notice or take advantage of the University's (or the flex authors') name.This basically says do whatever you please with this software except remove this notice or take advantage of the University's (or the flex authors') name.",@"You are free to do whatever you please with scanners generated using flex.",@"Hey How are you?",@"I'm fine.",@"So where are you now?",@"for them, you are not even bound by the above copyright.", nil];
    
    for(int i=0;i<20;i++)
    {
        

        NSString *msg=[randomMessages objectAtIndex:arc4random()%(randomMessages.count)];
        

        NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:msg,@"msg",
                            [NSNumber numberWithInt:arc4random()%2],@"sender",
                            nil];
        
        [chatMessages addObject:dict];
        
        
        
    }
    
    
    
    self.backgroundColor=[UIColor clearColor];
 
    bgView=[[UIView alloc] initWithFrame:CGRectMake(rect.origin.x+15, rect.origin.y+15, 50, 50)];
    [self addSubview:bgView];
    bgView.backgroundColor=[UIColor whiteColor];
    bgView.layer.cornerRadius=25;
    bgView.clipsToBounds=YES;
    
    Oldframe=bgView.frame;

    UIView *navBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 65)];
    [self addSubview:navBar];
    navBar.backgroundColor=[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
    
    UILabel *navBarTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 65-20)];
    [navBar addSubview:navBarTitle];
    navBarTitle.text=@"John";
    navBarTitle.textColor=[UIColor colorWithRed:0.59 green:0.11 blue:1.00 alpha:1.00];
    navBarTitle.textAlignment=NSTextAlignmentCenter;
    navBarTitle.font=[UIFont fontWithName:k_fontSemiBold size:18];

    
    profileView=[[UIImageView alloc] initWithFrame:bgView.frame];
    [self addSubview:profileView];
    profileView.image=image;
    profileView.layer.cornerRadius=25;
    profileView.clipsToBounds=YES;
 
    

    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    

    
    CGRect collectionViewFrame = CGRectMake(0, 100-35, self.frame.size.width, self.frame.size.height-100-kk_chatBoxTextViewHeight+35);
    chatThreadCollectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    chatThreadCollectionView.delegate = self;
    chatThreadCollectionView.dataSource = self;
    //  chatThreadCollectionView.pagingEnabled = YES;
    chatThreadCollectionView.showsHorizontalScrollIndicator = NO;
    chatThreadCollectionView.backgroundColor=[UIColor clearColor];
    [chatThreadCollectionView registerClass:[ChatLineCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:chatThreadCollectionView];
    
   /* backBtn=[[UIButton alloc] initWithFrame:CGRectMake(5,50,100,50)];
    [backBtn setTitle:@"All Messages" forState:UIControlStateNormal];
    [self addSubview:backBtn];
    backBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:14];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    */
    
    backBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 60, 25, 25)];
    [backBtn setShowsTouchWhenHighlighted:YES];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackPlainForNav.png"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    
    backBtn.center=CGPointMake(10+25/2, 20+65/2-10);
    
    
    chatThreadCollectionView.alpha=0;
    backBtn.alpha=0;
    
    newChatBox=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-kk_chatBoxTextViewHeight, self.frame.size.width, 1)];
    [self addSubview:newChatBox];
    newChatBox.backgroundColor=[UIColor colorWithWhite:0.5f alpha:0.2f];
   
    newChatMessageBox=[[UITextView alloc] initWithFrame:CGRectMake(10, self.frame.size.height-(kk_chatBoxTextViewHeight-1), self.frame.size.width-20, (kk_chatBoxTextViewHeight-1))];
    [self addSubview:newChatMessageBox];
    newChatMessageBox.font=kk_chatFont;
    newChatMessageBox.returnKeyType=UIReturnKeySend;
    newChatMessageBox.delegate=self;
  
    
    //newChatBox.frame=CGRectMake(0, self.frame.size.height-80+200, self.frame.size.width, 1);
    //newChatMessageBox.frame=CGRectMake(0, self.frame.size.height-79+200, self.frame.size.width-79, 79);
    
    

    
    [chatThreadCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:chatMessages.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:false];

    
    [UIView animateWithDuration:0.5 animations:^{
        
      
        self.backgroundColor=[UIColor blackColor];
        
        bgView.transform=CGAffineTransformMakeScale(50,50);
        
        profileView.frame=CGRectMake(self.frame.size.width-60, 20, 50, 50);
        
        newChatBox.frame=CGRectMake(0, self.frame.size.height-kk_chatBoxTextViewHeight, self.frame.size.width, 1);
        newChatMessageBox.frame=CGRectMake(10, self.frame.size.height-(kk_chatBoxTextViewHeight-1), self.frame.size.width-20, (kk_chatBoxTextViewHeight-1));
        

        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:0.5 animations:^{
            
            
            chatThreadCollectionView.alpha=1;
            backBtn.alpha=1;
            
            
        } completion:^(BOOL finished) {
            
            

            
        }];
        
        
    }];

  
    self.clipsToBounds=true;
    
}


-(void)sendBtnClicked:(id)sender
{
    

    NSString *msg=newChatMessageBox.text;
    
    newChatMessageBox.text=@"";
    
    NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:msg,@"msg",
                        [NSNumber numberWithInt:arc4random()%2],@"sender",
                        nil];
    
    [chatMessages addObject:dict];
    
    
        //[chatThreadCollectionView reloadData];

    
    [chatThreadCollectionView performBatchUpdates:^{
        [chatThreadCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } completion:nil];

    
    [chatThreadCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:chatMessages.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:false];


  //  chatMessages
}
- (void)textViewDidChange:(UITextView *)textView
{

    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    
    if(newFrame.size.height<kk_chatBoxTextViewHeight)
    {
        newFrame.size.height=kk_chatBoxTextViewHeight;
    }
    newFrame=CGRectMake(newFrame.origin.x, self.frame.size.height-newFrame.size.height, newFrame.size.width, newFrame.size.height);
    
   
    
    chatThreadCollectionView.frame=CGRectMake(0, 100-35, self.frame.size.width, self.frame.size.height-(100+35+newFrame.size.height-kk_chatBoxTextViewHeight));
    
    
    newChatBox.frame=CGRectMake(0, newFrame.origin.y-1, self.frame.size.width, 1);

    [chatThreadCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:chatMessages.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:false];

    textView.frame = newFrame;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        
        CGRect collectionViewFrame = CGRectMake(0, 100-35, self.frame.size.width, self.frame.size.height-100-kk_chatBoxTextViewHeight+35);

        
        [UIView animateWithDuration:0.3f animations:^(void){
            
            chatThreadCollectionView.frame=collectionViewFrame;
            
            newChatBox.frame=CGRectMake(0, self.frame.size.height-kk_chatBoxTextViewHeight, self.frame.size.width, 1);
            newChatMessageBox.frame=CGRectMake(10, self.frame.size.height-(kk_chatBoxTextViewHeight-1), self.frame.size.width-20, (kk_chatBoxTextViewHeight-1));
            
        }];

        [self sendBtnClicked:nil];


        
        return NO;
    }
    
    return YES;
}


-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell.alpha=0;
    
    [UIView animateWithDuration:0.3f animations:^(void){
        cell.alpha=1;
    }];
    
    
  
    
}

-(void)backBtnClicked:(id)sender
{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        
        chatThreadCollectionView.alpha=0;
        backBtn.alpha=0;
        
        newChatBox.frame=CGRectMake(0, self.frame.size.height-kk_chatBoxTextViewHeight+200, self.frame.size.width, 1);
        newChatMessageBox.frame=CGRectMake(10, self.frame.size.height-(kk_chatBoxTextViewHeight-1)+200, self.frame.size.width-20, (kk_chatBoxTextViewHeight-1));
        
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:0.5 animations:^{
            
            
            self.backgroundColor=[UIColor clearColor];
            
            bgView.transform=CGAffineTransformMakeScale(1,1);
            
            profileView.frame=Oldframe;
        
            
            
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];

            
            
        }];
        
        
    }];
    
    
    
    
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChatLineCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];

    [cell setSenderValue:[[[chatMessages objectAtIndex:indexPath.row] valueForKey:@"sender"] intValue]];

    [cell setNameLBLText:[[chatMessages objectAtIndex:indexPath.row] valueForKey:@"msg"]];
    
    
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
    return [self calculateText:[[chatMessages objectAtIndex:indexPath.row] valueForKey:@"msg"]];
    
    
}
-(CGSize )calculateText:(NSString *)string
{
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width*0.6, 100)];
    
    
    label.textAlignment=NSTextAlignmentLeft;
    label.font=kk_chatFont;
    label.numberOfLines=0;

    label.text=string;
    
    CGFloat fixedWidth = label.frame.size.width;
    CGSize newSize = [label sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    
    CGRect newFrame = label.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height+20);
    
    
    //label.frame = newFrame;
    //label.backgroundColor=[UIColor greenColor];

    int height=kk_chatHeadMinHeight;
    if(newFrame.size.height>height)
    {
        height=newFrame.size.height+height/2;
    }
    
    return CGSizeMake(self.frame.size.width, height);
    
}

@end
