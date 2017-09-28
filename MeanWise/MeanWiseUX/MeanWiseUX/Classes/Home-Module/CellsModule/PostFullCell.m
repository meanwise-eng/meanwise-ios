//
//  PostFullCell.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "PostFullCell.h"
#import "FullCommentDisplay.h"
#import "DataSession.h"
#import "HMPlayerManager.h"
#import "ProfileWindowControl.h"

@implementation PostFullCell

-(void)shareBtnClicked:(id)sender
{


    [target performSelector:shareBtnClickedFunc withObject:dataObj.postId afterDelay:0.2];
    
}
-(void)setPlayerRefreshIdentifier:(NSNumber *)number
{
    [player setUpRefreshIdentifier:number];
    
}
-(void)setPlayerScreenIdeantifier:(NSString *)string
{
    screenIdentifier=string;
    [player setPlayerScreenIdeantifier:string];
    
    if([string isEqualToString:@"PROFILE"])
    {
        if([[NSString stringWithFormat:@"%@",dataObj.user_id] isEqualToString:[NSString stringWithFormat:@"%@",[UserSession getUserId]]])
        {
            self.deleteBtn.hidden=false;
            self.deleteBtn.userInteractionEnabled=true;
            
        }
        else
        {
            self.deleteBtn.hidden=true;
            self.deleteBtn.userInteractionEnabled=false;
        }
    }
    else
    {
        self.deleteBtn.hidden=true;
        self.deleteBtn.userInteractionEnabled=false;

    }
    
    
//    player.screenIdentifier=string;
}
-(void)commentWriteBtnClicked:(id)sender
{
    [target performSelector:commentWriteBtnClickedFunc withObject:dataObj.postId afterDelay:0.2];
    
}

-(void)commentBtnClicked:(id)sender
{
    

    [target performSelector:commentBtnClickedFunc withObject:dataObj.postId afterDelay:0.2];
    
}
-(void)UpdateCommentCountIfRequired
{
    int count=[[DataSession sharedInstance] getUpdatedCommentCountForPostId:dataObj.postId];
    
    if(count!=-1)
    {
        self.commentCountLBL.text=[NSString stringWithFormat:@"%d",count];

    }
    int p=0;
    
}
- (void)setImageOffset:(CGPoint)imageOffset
{
    _imageOffset = imageOffset;
    
    CGRect frame = self.postIMGVIEW.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    self.postIMGVIEW.frame = offsetFrame;
    player.frame = offsetFrame;
    
}
-(void)hideShowControl:(BOOL)flag
{
    isfullMode=flag;
    
    
    
    float opacity=flag?0.0f:1.0f;

    
    [UIView animateWithDuration:0.2 animations:^{
        
                self.timeLBL.alpha=opacity;
                self.shareBtn.alpha=opacity;
                self.commentBtn.alpha=opacity;
                self.commentCountLBL.alpha=opacity;
                self.likeBtn.alpha=opacity;
                self.likeCountLBL.alpha=opacity;
        
                self.tagName.alpha=opacity;
        
                self.profileIMGVIEW.alpha=opacity;
                self.nameLBL.alpha=opacity;
                self.profLBL.alpha=opacity;

                self.topicListLBL.alpha=opacity;
                if(mediaType!=0)
                {
                    self.statusLBL.alpha=opacity;
            
                }
                if(self.shouldHideCommentWriteBtn==false)
                {
                            self.commentWriteBtn.alpha=opacity;
                }
        
    }];
    
    
//        self.timeLBL.hidden=flag;
//        self.shareBtn.hidden=flag;
//        self.commentBtn.hidden=flag;
//        self.commentCountLBL.hidden=flag;
//        self.likeBtn.hidden=flag;
//        self.likeCountLBL.hidden=flag;
//
//        self.tagName.hidden=flag;
//
//        self.profileIMGVIEW.hidden=flag;
//        self.nameLBL.hidden=flag;
//        self.profLBL.hidden=flag;
    
    
    
//    if(mediaType!=0)
//    {
//        self.statusLBL.hidden=flag;
//
//    }
//    
//    if(self.shouldHideCommentWriteBtn==false)
//    {
//                self.commentWriteBtn.hidden=flag;
//
//    }
    
    
    
    
}


-(void)onDeleteEvent:(SEL)func3;
{
    onDeleteClickedFunc=func3;
}
-(void)setTarget:(id)delegate shareBtnFunc:(SEL)func1 andCommentBtnFunc:(SEL)func2
{
     target=delegate;
     commentBtnClickedFunc=func2;
     shareBtnClickedFunc=func1;
}
-(void)setCallBackForCommentWrite:(SEL)func3
{
    commentWriteBtnClickedFunc=func3;
}



-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.clipsToBounds=YES;
//        
        self.postIMGVIEW=[[UIImageHM alloc] initWithFrame:self.bounds];
        
        [self.postIMGVIEW clearImageAll];
        
       // self.postIMGVIEW.image=[UIImage imageNamed:@"post_3.jpeg"];
        self.postIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.postIMGVIEW];
        self.postIMGVIEW.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;

        
        player=[[HMPlayer alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:player];
        [player setUp];

        
        self.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;

        
       

        self.shadowImage=[[UIImageView alloc] initWithFrame:self.bounds];
         self.shadowImage.image=[UIImage imageNamed:@"fullpostshadow.png"];
         self.shadowImage.contentMode=UIViewContentModeScaleAspectFill;
         [self.contentView addSubview:self.shadowImage];
         self.shadowImage.alpha=0.2;
        
        
        self.contentView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        self.postIMGVIEW.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;

        self.shadowImage.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;

        self.shadowImage.clipsToBounds=YES;
        
        
        self.nameLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        [self.contentView addSubview:self.nameLBL];
        self.nameLBL.text=@"Marry Lee";
        self.nameLBL.textColor=[UIColor whiteColor];
        self.nameLBL.textAlignment=NSTextAlignmentLeft;
        self.nameLBL.font=[UIFont fontWithName:k_fontSemiBold size:16];
        
        
        self.profLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        [self.contentView addSubview:self.profLBL];
        self.profLBL.text=@"Photographer";
        self.profLBL.textColor=[UIColor whiteColor];
        self.profLBL.textAlignment=NSTextAlignmentLeft;
        self.profLBL.font=[UIFont fontWithName:k_fontRegular size:16];
        self.profLBL.numberOfLines=2;
        self.profLBL.adjustsFontSizeToFitWidth=YES;
        
        
        ////
        
        
        
        self.statusLBL=[[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.statusLBL];
        self.statusLBL.text=@"Lorem Ipsum dummy text of the printing and typesettings industry.";
        self.statusLBL.textColor=[UIColor whiteColor];
        self.statusLBL.textAlignment=NSTextAlignmentLeft;
        self.statusLBL.font=[UIFont fontWithName:k_fontRegular size:17];
        self.statusLBL.numberOfLines=0;
        
        self.topicListLBL=[[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.topicListLBL];
        self.topicListLBL.textAlignment=NSTextAlignmentLeft;
        self.topicListLBL.font=[UIFont fontWithName:k_fontRegular size:14];
        self.topicListLBL.textColor=[UIColor whiteColor];

        
        self.tagName=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
        [self.contentView addSubview:self.tagName];
        self.tagName.text=@"Wild Life";
        self.tagName.textColor=[UIColor whiteColor];
        self.tagName.textAlignment=NSTextAlignmentLeft;
        self.tagName.font=[UIFont fontWithName:k_fontSemiBold size:14];
        
        
        self.timeLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
        [self.contentView addSubview:self.timeLBL];
        self.timeLBL.text=@"2 hrs";
        self.timeLBL.textColor=[UIColor whiteColor];
        self.timeLBL.textAlignment=NSTextAlignmentRight;
        self.timeLBL.font=[UIFont fontWithName:k_fontBold size:14];
        
        self.profileIMGVIEW=[[UIImageHM alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [self.contentView addSubview:self.profileIMGVIEW];
        self.profileIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
        self.profileIMGVIEW.clipsToBounds=YES;
        
        
        
        
        self.likeCountLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
        [self.contentView addSubview:self.likeCountLBL];
        self.likeCountLBL.text=@"12";
        self.likeCountLBL.textColor=[UIColor whiteColor];
        self.likeCountLBL.textAlignment=NSTextAlignmentCenter;
        self.likeCountLBL.font=[UIFont fontWithName:k_fontSemiBold size:15];
        
        
        self.commentCountLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
        [self.contentView addSubview:self.commentCountLBL];
        self.commentCountLBL.text=@"3";
        self.commentCountLBL.textColor=[UIColor whiteColor];
        self.commentCountLBL.textAlignment=NSTextAlignmentCenter;
        self.commentCountLBL.font=[UIFont fontWithName:k_fontSemiBold size:15];
        
        
        self.likeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.likeBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.likeBtn];
        
        self.commentBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.commentBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.commentBtn setBackgroundImage:[UIImage imageNamed:@"comments.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.commentBtn];
        
        self.shareBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.shareBtn];
        
        
        self.commentWriteBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 40)];
        [self.contentView addSubview:self.commentWriteBtn];
        self.commentWriteBtn.titleLabel.font=[UIFont fontWithName:k_fontRegular size:17];
        self.commentWriteBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [self.commentWriteBtn setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.7f] forState:UIControlStateNormal];
        [self.commentWriteBtn setTitle:@"Leave a comment ..." forState:UIControlStateNormal];
        [self.commentWriteBtn addTarget:self action:@selector(commentWriteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.commentWriteBtn.hidden=true;
        self.shouldHideCommentWriteBtn=true;
        
        self.deleteBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"trashBtn.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.deleteBtn];
        self.deleteBtn.hidden=true;
        self.deleteBtn.userInteractionEnabled=false;


        doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeBtnClicked:)];
        doubleTap.numberOfTapsRequired = 2;
        [self.contentView addGestureRecognizer:doubleTap];
        doubleTap.delegate=self;
  

        [self setShadowsCustom];
        
        [self setFrameX:frame];
        
        UILongPressGestureRecognizer *gesture=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapPressed:)];
        gesture.numberOfTouchesRequired=1;
        gesture.minimumPressDuration=0.3;
        [self.contentView addGestureRecognizer:gesture];
        

    }
    return self;
}
-(void)longTapPressed:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state==UIGestureRecognizerStateBegan)
    {
    [self hideShowControl:true];
    }
    else if(gesture.state==UIGestureRecognizerStateEnded)
    {
        [self hideShowControl:false];

    }
}
-(void)setShadowsCustom
{
//    self.statusLBL.shadowOffset=CGSizeMake(0, 0);
//    self.profLBL.shadowOffset=CGSizeMake(0, 0);
//    self.nameLBL.shadowOffset=CGSizeMake(0,0);
//    self.tagName.shadowOffset=CGSizeMake(0,0);
    
    
    self.profLBL.layer.shadowOffset=CGSizeMake(0, 0);
    self.profLBL.layer.shadowColor=[UIColor blackColor].CGColor;
    self.profLBL.layer.shadowOpacity=0.5;
    self.profLBL.layer.shadowRadius=1;

    self.nameLBL.layer.shadowOffset=CGSizeMake(0, 0);
    self.nameLBL.layer.shadowColor=[UIColor blackColor].CGColor;
    self.nameLBL.layer.shadowOpacity=0.5;
    self.nameLBL.layer.shadowRadius=1;

    self.tagName.layer.shadowOffset=CGSizeMake(0, 0);
    self.tagName.layer.shadowColor=[UIColor blackColor].CGColor;
    self.tagName.layer.shadowOpacity=0.5;
    self.tagName.layer.shadowRadius=1;
    
    self.timeLBL.layer.shadowOffset=CGSizeMake(0, 0);
    self.timeLBL.layer.shadowColor=[UIColor blackColor].CGColor;
    self.timeLBL.layer.shadowOpacity=0.5;
    self.timeLBL.layer.shadowRadius=1;
 
    self.topicListLBL.layer.shadowOffset=CGSizeMake(0, 0);
    self.topicListLBL.layer.shadowColor=[UIColor blackColor].CGColor;
    self.topicListLBL.layer.shadowOpacity=0.5;
    self.topicListLBL.layer.shadowRadius=1;

    
    
}
-(void)deleteBtnClicked:(id)sender
{
    [HMPlayerManager sharedInstance].All_isPaused=YES;
    
    FCAlertView *alert = [[FCAlertView alloc] init];
    //alert.blurBackground = YES;
    [alert showAlertWithTitle:@"Delete post"
                 withSubtitle:@"Are you sure want to delete?"
              withCustomImage:nil
          withDoneButtonTitle:@"Cancel"
                   andButtons:nil];
    [alert addButton:@"Delete" withActionBlock:^{
        
        [HMPlayerManager sharedInstance].All_isPaused=false;
        
        [target performSelector:onDeleteClickedFunc withObject:dataObj afterDelay:0.01];
        NSLog(@"delete");

        // Put your action here
    }];
    [alert doneActionBlock:^{
        
        [HMPlayerManager sharedInstance].All_isPaused=false;
        
        NSLog(@"done");
        
    }];
    alert.titleColor=[UIColor redColor];
    alert.firstButtonTitleColor = [UIColor redColor];

}
-(NSDictionary *)userDictFromPostDetail:(APIObjects_FeedObj *)feedData
{
    NSDictionary *dict=@{@"cover_photo":feedData.user_cover_photo,@"user_id":feedData.user_id};


    
    return dict;
}

    

-(void)setDataObj:(APIObjects_FeedObj *)dict;
{
    dataObj=dict;
    liked=dict.is_liked.intValue;
    
    
    

    [self.profileIMGVIEW setUp:dict.user_profile_photo_small];
    
    [self.profileIMGVIEW setTarget:self OnClickFunc:@selector(profileBtnClicked:) WithObj:[self userDictFromPostDetail:dict]];
    
    
    
    if(dict.mediaType.intValue!=0)
    {
        [self.postIMGVIEW setUp:dict.image_url];
    }
    else
    {
        [self.postIMGVIEW clearImageAll];
    }
    
    if(dict.topicLists.count>0)
    {
        self.topicListLBL.text=[NSString stringWithFormat:@"@%@",[dict.topicLists componentsJoinedByString:@" @"]];
    }
    else
    {
        self.topicListLBL.text=@"";
    }
    [self setUpMediaType:dict.mediaType.intValue andColorNumber:dict.colorNumber.intValue];
    
    self.nameLBL.text=[NSString stringWithFormat:@"%@ %@",dict.user_firstname,dict.user_lastname];
    self.profLBL.text=dict.user_profession;
    self.likeCountLBL.text=[NSString stringWithFormat:@"%d",dict.num_likes.intValue];
    self.commentCountLBL.text=[NSString stringWithFormat:@"%d",dict.num_comments.intValue];
    self.tagName.text=dict.interest_name;
    self.statusLBL.text=dict.text;
    self.timeLBL.text=dict.timeString;
    

    if(liked==1)
    {
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"Unlike.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
    }
   
    if(dict.mediaType.intValue==2)
    {
        
        [player setURL:dict.video_url];
        player.hidden=false;
        
        
    }
    else
    {
        [player setURL:nil];
        player.hidden=true;

    }
    
    
    self.statusLBL.text=dict.text;
    [self setHighLightMentions];
    
    if(dict.mediaType.intValue!=0)
    {
        

        int height=[self getLabelHeight:self.statusLBL];
        self.statusLBL.frame=CGRectMake(15,  self.frame.size.height-heightBottom-30-height-10-30, self.frame.size.width-70,height);
        
        self.profileIMGVIEW.frame=CGRectMake(15, self.frame.size.height-heightBottom-30-height-10-50-30, 40, 40);
        self.profileIMGVIEW.layer.cornerRadius=20;
        
        self.nameLBL.frame=CGRectMake(15+40+10, self.frame.size.height-heightBottom-30-height-10-50-30, 200, 25);
        self.profLBL.frame=CGRectMake(15+40+10, self.frame.size.height-heightBottom-30-height-10-50+20-30, 200, 25);

        
    }
    else
    {
        
        
        int height=0;
        self.statusLBL.adjustsFontSizeToFitWidth=YES;

        self.profileIMGVIEW.frame=CGRectMake(15, self.frame.size.height-heightBottom-30-height-50-30, 40, 40);
        self.profileIMGVIEW.layer.cornerRadius=20;
        
        self.nameLBL.frame=CGRectMake(15+40+10, self.frame.size.height-heightBottom-30-height-50-30, 200, 25);
        self.profLBL.frame=CGRectMake(15+40+10, self.frame.size.height-heightBottom-30-height-50+20-30, 200, 25);
        

        
    }
    
    

 
    
    
}
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    if([url.absoluteString hasPrefix:@"USER://"])
    {
        
        NSString *userId=[[url.absoluteString componentsSeparatedByString:@"//"] lastObject];
    
    NSDictionary *userDict=@{
                         @"user_firstname":@"",
                         @"user_lastname":@"",
                         @"user_profile_photo_small":@"",
                         @"user_profession":@"",
                         @"user_id":userId,
                         @"user_cover_photo":@"",
                         };
    
    
        if(![screenIdentifier isEqualToString:@"DEEPLINKPOST"] && ![screenIdentifier isEqualToString:@"NOTIFICATIONPOST"])
        {
            if([screenIdentifier isEqualToString:@"EXPLORE"])
            {
                [HMPlayerManager sharedInstance].Explore_isPaused=true;
            }
            else if([screenIdentifier isEqualToString:@"HOME"])
            {
                [HMPlayerManager sharedInstance].Home_isPaused=true;
            }
        
        //    [HMPlayerManager sharedInstance].All_isPaused=true;
        
            CGRect rect=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height/3);
            [[HMPlayerManager sharedInstance] MX_setLastPlayerPaused:TRUE];

        
            NSDictionary *dict=@{@"cover_photo":@"",@"user_id":userId};
            ProfileWindowControl *control=[[ProfileWindowControl alloc] init];
            [control setUp:dict andSourceFrame:rect];
            [control setTarget:self onClose:@selector(ProfilecloseBtnClicked:)];
        
        NSLog(@"%@",userDict);
        }
    }
    
    
}
-(void)ProfilecloseBtnClicked:(id)sender
{
    if([screenIdentifier isEqualToString:@"EXPLORE"])
    {
        [HMPlayerManager sharedInstance].Explore_isPaused=false;
    }
    else if([screenIdentifier isEqualToString:@"HOME"])
    {
        [HMPlayerManager sharedInstance].Home_isPaused=false;
    }
    
    [HMPlayerManager sharedInstance].HM_isPaused=false;

    [[HMPlayerManager sharedInstance] MX_setLastPlayerPaused:FALSE];
    //    [HMPlayerManager sharedInstance].All_isPaused=false;
    
    NSLog(@"closed");
    
}
-(void)profileBtnClicked:(NSDictionary *)userDict
{
    if(RX_isiPhone4Res)
    {
        return;
    }
    
    if(![screenIdentifier isEqualToString:@"PROFILE"] && ![screenIdentifier isEqualToString:@"DEEPLINKPOST"] && ![screenIdentifier isEqualToString:@"NOTIFICATIONPOST"])
    {
        if([screenIdentifier isEqualToString:@"EXPLORE"])
        {
            [HMPlayerManager sharedInstance].Explore_isPaused=true;
        }
        else if([screenIdentifier isEqualToString:@"HOME"])
        {
            [HMPlayerManager sharedInstance].Home_isPaused=true;
        }

        [HMPlayerManager sharedInstance].HM_isPaused=true;
        //    [HMPlayerManager sharedInstance].All_isPaused=true;
        
        [[HMPlayerManager sharedInstance] MX_setLastPlayerPaused:TRUE];
        
        

        ProfileWindowControl *control=[[ProfileWindowControl alloc] init];
        [control setUp:userDict andSourceFrame:self.profileIMGVIEW.frame];
        [control setTarget:self onClose:@selector(ProfilecloseBtnClicked:)];
        
        NSLog(@"%@",userDict);
    }
}

-(void)setHighLightMentions
{
    
    self.statusLBL.delegate=self;
    self.statusLBL.text=dataObj.text;
    self.statusLBL.linkAttributes=@{NSUnderlineStyleAttributeName:@1,NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    BOOL enableLink=[Constant isAppDebugModeOn];
    
    if(enableLink)
    {
        for(int i=0;i<dataObj.mentioned_users.count;i++)
        {
        id dict=[dataObj.mentioned_users objectAtIndex:i];
        if([dict isKindOfClass:[NSDictionary class]])
        {
            NSString *userOne=[[[dataObj.mentioned_users objectAtIndex:i] valueForKey:@"username"] lowercaseString];
            userOne=[NSString stringWithFormat:@"@%@",userOne];
            NSLog(@"%@",userOne);
            NSRange range=[dataObj.text rangeOfString:userOne];
            
            [self.statusLBL addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:@"USER://%d",[[[dataObj.mentioned_users objectAtIndex:i] valueForKey:@"id"] intValue]]] withRange:range];
        }
        }
    }
    
    
    
}

- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}


/*- (BOOL)gestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if(touch.view==commmentComp)
    {
        
        if(touch.tapCount==1)
        {
            [self commentBtnClicked:nil];
            return false;

        }
        else
        {
            return false;
        }
    }
    else
    {
        if(touch.tapCount==2)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    

}
*/
-(void)setImage:(NSString *)string;
{
    self.postIMGVIEW.image=[UIImage imageNamed:string];
    
}

-(void)likeBtnClicked:(id)sender
{
    if(liked==0)
    {
        liked=1;
        [self callLikeAPI];
        [[DataSession sharedInstance] postLiked:dataObj.postId];
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"Unlike.png"] forState:UIControlStateNormal];
        [self likeBtnAnimation];
        self.likeCountLBL.text=[NSString stringWithFormat:@"%d",dataObj.num_likes.intValue];

    }
    else
    {
        liked=0;
        [self callLikeAPI];
        [[DataSession sharedInstance] postUnliked:dataObj.postId];
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        self.likeCountLBL.text=[NSString stringWithFormat:@"%d",dataObj.num_likes.intValue];

    }
    
}
-(void)callLikeAPI
{
    if(liked==1)
    {
        
        
    }
    else
    {
        
        
    }
    APIManager *manager=[[APIManager alloc] init];
    
    [manager sendRequestForLikeAPostId:dataObj.postId delegate:self andSelector:@selector(likeActionFinished:) andIsLike:liked];
    
    
    
    
    
    
}
-(void)likeActionFinished:(APIResponseObj *)responseObj
{
    NSLog(@"%@",responseObj.message);
}
-(void)likeBtnAnimation
{
    
    UIImageView *imageView1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    imageView1.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self.contentView addSubview:imageView1];
    imageView1.image=[UIImage imageNamed:@"Unlike.png"];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView1.transform=CGAffineTransformMakeScale(20, 20);
        imageView1.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [imageView1 removeFromSuperview];
        
    }];
    
    
    
    
}
-(void)setFrameX:(CGRect)frame;
{
   // self.postIMGVIEW.frame=frame;
    //self.shadowImage.frame=frame;
    
    isfullMode=false;

    self.timeLBL.frame=CGRectMake(15, frame.size.height-110, frame.size.width-30, 30);
    
    
    
    self.likeCountLBL.frame=CGRectMake(15, frame.size.height-70, 50, 20);
    self.commentCountLBL.frame=CGRectMake(frame.size.width/2-25, frame.size.height-70, 50, 20);
    
    self.likeBtn.frame=CGRectMake(15, frame.size.height-60, 50, 50);
    
    self.commentBtn.frame=CGRectMake(frame.size.width/2-25, frame.size.height-60, 50, 50);
    

    heightBottom=70;
   
    ////////////////////////

    self.deleteBtn.frame=CGRectMake(frame.size.width-60, frame.size.height-195-heightBottom-70, 50, 50);
    
    self.timeLBL.frame=CGRectMake(frame.size.width-60, self.frame.size.height-heightBottom-30, 50, 30);
    self.shareBtn.frame=CGRectMake(frame.size.width-60, frame.size.height-heightBottom-90, 50, 50);
    self.commentBtn.frame=CGRectMake(frame.size.width-60, frame.size.height-140-heightBottom, 50, 50);
    self.commentCountLBL.frame=CGRectMake(frame.size.width-60, frame.size.height-155-heightBottom, 50, 30);
    self.likeBtn.frame=CGRectMake(frame.size.width-60, frame.size.height-195-heightBottom, 50, 50);
    self.likeCountLBL.frame=CGRectMake(frame.size.width-60, frame.size.height-210-heightBottom, 50, 30);

    
    self.tagName.frame=CGRectMake(15, frame.size.height-heightBottom-30, frame.size.width-70, 30);
    self.topicListLBL.frame=CGRectMake(15, frame.size.height-heightBottom-30-30, frame.size.width-70, 30);

    self.statusLBL.frame=CGRectMake(15,  self.frame.size.height-heightBottom-30-80-30, self.frame.size.width-70,70);

    self.profileIMGVIEW.frame=CGRectMake(15, self.frame.size.height-heightBottom-30-90-60-30, 40, 40);
    self.profileIMGVIEW.layer.cornerRadius=20;

    self.nameLBL.frame=CGRectMake(15+40+10, self.frame.size.height-heightBottom-30-90-60-30, 200, 25);
    self.profLBL.frame=CGRectMake(15+40+10, self.frame.size.height-heightBottom-30-90-60+20-30, 200, 25);


   
     self.commentWriteBtn.frame=CGRectMake(15, self.frame.size.height-heightBottom, self.frame.size.width-30, heightBottom-20);

    
}
-(void)setUpMediaType:(int)number andColorNumber:(int)Cnumber;
{
  
  //  [commmentComp removeFromSuperview];
  //  commmentComp=nil;
    
   
    
//    commmentComp=[[FlyCommentComponent alloc] initWithFrame:CGRectMake(0, self.frame.size.height-250-70, self.frame.size.width, 140)];
 //   [self.contentView addSubview:commmentComp];
    
   // [commmentComp setUp];

    [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];

    mediaType=number;
    
    if(mediaType==0)
    {
        
        [self.postIMGVIEW clearImageAll];
        
        self.backgroundColor=[Constant colorGlobal:Cnumber];
        self.statusLBL.frame=CGRectMake(50, 10, self.frame.size.width-100, self.frame.size.height*0.32);
        self.statusLBL.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        self.statusLBL.font=[UIFont fontWithName:k_fontSemiBold size:20];
        self.statusLBL.numberOfLines=0;
        self.statusLBL.adjustsFontSizeToFitWidth=YES;
        
        self.statusLBL.layer.shadowOffset=CGSizeMake(0, 0);
        self.statusLBL.layer.shadowColor=[UIColor blackColor].CGColor;
        self.statusLBL.layer.shadowOpacity=0;

    //    commmentComp.frame=CGRectMake(0, self.frame.size.height-250, self.frame.size.width, 140);
        
        self.shadowImage.hidden=true;
        
    }
    else
    {
     //   self.statusLBL.frame=CGRectMake(15,  self.frame.size.height-250+70, self.frame.size.width-30,70);
    //    commmentComp.frame=CGRectMake(0, self.frame.size.height-250-70, self.frame.size.width, 140);
        self.statusLBL.frame=CGRectMake(15,  self.frame.size.height-50-30-90, self.frame.size.width-70,400);

        self.backgroundColor=[UIColor whiteColor];
        self.statusLBL.font=[UIFont fontWithName:k_fontRegular size:15];
        self.statusLBL.numberOfLines=0;
        self.statusLBL.adjustsFontSizeToFitWidth=false;

        self.statusLBL.layer.shadowOffset=CGSizeMake(0, 0);
        self.statusLBL.layer.shadowColor=[UIColor blackColor].CGColor;
        self.statusLBL.layer.shadowOpacity=0.5;
        self.statusLBL.layer.shadowRadius=1;

        
        self.shadowImage.hidden=false;
        
        
    }
  
    
    
    
}

-(void)playVideoIfAvaialble
{
    
    [player playerPlay];
    
    
}
-(void)dealloc
{
    
}

@end
