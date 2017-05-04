//
//  NewPostComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 27/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "NewPostComponent.h"
#import "ChannelSearchView.h"
#import "ViewController.h"
#import "UserSession.h"
#import "UITextView+Placeholder.h"

@implementation NewPostComponent

-(void)setTarget:(id)targetReceived onCloseEvent:(SEL)func1;
{
    target=targetReceived;
    closeCallBackfunc=func1;
    
}
-(void)zoomDownOut
{
    [target performSelector:closeCallBackfunc withObject:nil afterDelay:0.01];
}
-(void)setUpWithCellRect:(CGRect)rect
{
    [self setUpCellRect:rect];
    containerView.backgroundColor=[UIColor whiteColor];
    self.clipsToBounds=YES;
    
    containerView.clipsToBounds=YES;
    
    
    
    
    
    
    UIView *navBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 65)];
    [containerView addSubview:navBar];
    navBar.backgroundColor=[UIColor whiteColor];
    
    UIView *seperator=[[UIView alloc] initWithFrame:CGRectMake(0,65,self.frame.size.width, 1)];
    [containerView addSubview:seperator];
    seperator.backgroundColor=[UIColor colorWithWhite:0.6 alpha:0.1];
    
   

    
//    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 60, 25, 25)];
//    [backBtn setShowsTouchWhenHighlighted:YES];
//    //[backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackPlainForNav.png"] forState:UIControlStateNormal];
//    [containerView addSubview:backBtn];
//    
//    backBtn.center=CGPointMake(10+25/2, 20+65/2-10);
//    
    
    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(10,20, 70, 45)];
    [backBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [containerView addSubview:backBtn];
    [backBtn setTitleColor:[UIColor colorWithRed:0.00 green:0.76 blue:0.89 alpha:1.00] forState:UIControlStateNormal];
    backBtn.titleLabel.font=[UIFont fontWithName:k_fontRegular size:18];
    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(cancelPostBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    postBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-70-10,20, 70, 45)];
    [postBtn setTitle:@"Publish" forState:UIControlStateNormal];
    [containerView addSubview:postBtn];
    [postBtn setTitleColor:[UIColor colorWithRed:0.00 green:0.76 blue:0.89 alpha:1.00] forState:UIControlStateNormal];
    postBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:18];
    [postBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [postBtn addTarget:self action:@selector(postBtnClicked:) forControlEvents:UIControlEventTouchUpInside];


    
    profileIMGVIEW=[[UIImageHM alloc] initWithFrame:CGRectMake(15, 65+10, 50, 50)];
    [containerView addSubview:profileIMGVIEW];
    [profileIMGVIEW setUp:[UserSession getProfilePictureURL]];
    
    profileIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
    profileIMGVIEW.clipsToBounds=YES;
    profileIMGVIEW.layer.cornerRadius=25;
    

    
    
    statusView=[[UITextView alloc] initWithFrame:CGRectMake(15, 65+70, self.frame.size.width-40, 42)];
    [containerView addSubview:statusView];
    statusView.font=[UIFont fontWithName:k_fontLight size:20];
    statusView.placeholder = @"Say something";
    statusView.delegate=self;

   
    
    int height=self.frame.size.height-statusView.frame.origin.y-statusView.frame.size.height-170;
    
    attachedImage=[[PreviewViewComponent alloc] initWithFrame:CGRectMake(0, statusView.frame.origin.y+statusView.frame.size.height, self.frame.size.width, height)];
    attachedImage.backgroundColor=[UIColor grayColor];
    [containerView addSubview:attachedImage];
    attachedImage.hidden=true;
    attachedImage.clipsToBounds=YES;
    
    [attachedImage setTarget:self showFullScreenCallBack:@selector(mediaManupulatorOpen:) andShowThumbCallBack:@selector(mediaManupulatorClose:)];
    
    
   // attachedImage.center=CGPointMake(self.frame.size.width/2, attachedImage.center.y);
    
    
    
    

    characterCountLBL=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-50, 65+10, 100,50)];
    [containerView addSubview:characterCountLBL];
    characterCountLBL.font=[UIFont fontWithName:k_fontLight size:24];
    characterCountLBL.text=@"200";
    characterCountLBL.textColor=[UIColor colorWithRed:144/255.0 green:164/255.0 blue:174/255.0 alpha:1.0];
    characterCountLBL.textAlignment=NSTextAlignmentCenter;
    
    
    
    UIView *seperator1=[[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-170, self.frame.size.width, 1)];
    seperator1.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.1f];
    [containerView addSubview:seperator1];
    
    
    
    replyToLBL=[[UILabel alloc] initWithFrame:CGRectMake(15,self.frame.size.height-170, self.frame.size.width-30,50)];
    [containerView addSubview:replyToLBL];
    replyToLBL.font=[UIFont fontWithName:k_fontRegular size:16];
    replyToLBL.text=@"@designerNews";
    replyToLBL.textAlignment=NSTextAlignmentLeft;
    replyToLBL.textColor=[UIColor colorWithRed:0.77 green:0.26 blue:0.78 alpha:1.00];
    replyToLBL.text=@"@topic";
    replyToLBL.textColor=[UIColor lightGrayColor];
    
    
    UIView *seperator2=[[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-115, self.frame.size.width, 1)];
    seperator2.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.1f];
    [containerView addSubview:seperator2];

  /*  ChannelSearchView *view=[[ChannelSearchView alloc] initWithFrame:self.bounds];
    [self addSubview:view];
    [view setUp];*/
    
    
    
    UIView *seperator3=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-55, self.frame.size.width, 1)];
    seperator3.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.1f];
    [containerView addSubview:seperator3];
    
    
    
 
    
    photoControllerBtns=[[PhotosBtnController alloc] initWithFrame:CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 50)];
    [containerView addSubview:photoControllerBtns];
    [photoControllerBtns setUp];
    [photoControllerBtns setTarget:self andSel1:@selector(gallerySelect:) andSel2:@selector(cameraSelect:)];
    

    channelSelectionView=[[ChannelSearchView alloc] initWithFrame:self.bounds];
    [channelSelectionView setUp];
    [containerView addSubview:channelSelectionView];
    [channelSelectionView setState1Frame:CGRectMake(20, self.frame.size.height-115, self.frame.size.width, 50)];

    
    
//    
//    gallery=[[PhotoGallery alloc] initWithFrame:CGRectMake(0, 160+85+200, self.frame.size.width, self.frame.size.height- (160+85+200))];
//    [containerView addSubview:gallery];
//    [gallery setUp];
//
    
    
    [self cameraSelect:nil];
    
    
}

-(void)mediaManupulatorOpen:(id)sender
{
    NSLog(@"openFull");
    [self setGestureEnabled:false];

}
-(void)mediaManupulatorClose:(id)sender
{
    NSLog(@"openSmall");
    [self setGestureEnabled:true];

}

-(void)gallerySelect:(id)sender
{
    [self setGestureEnabled:false];
    photoGallery=[[PhotoGallery alloc] initWithFrame:self.bounds];
    [containerView addSubview:photoGallery];
    [photoGallery setTarget:self andSel1:@selector(cancelBtnClicked:) andSel2:@selector(showAttachImage:)];
    [photoGallery setUp:0];
    
}
-(void)cameraSelect:(id)sender
{
    [self setGestureEnabled:false];
    photoGallery=[[PhotoGallery alloc] initWithFrame:self.bounds];
    [containerView addSubview:photoGallery];
    [photoGallery setTarget:self andSel1:@selector(cancelBtnClicked:) andSel2:@selector(showAttachImage:)];
    [photoGallery setUp:1];
    
}
-(void)cancelBtnClicked:(id)sender
{
    [self setGestureEnabled:true];

}
-(void)attachmentRemove:(id)sender
{
    [attachedImage cleanUp];

    attachedImage.hidden=true;

}
-(void)mediaSelected:(NSString *)path
{


    cropperControl=[[MediaCropper alloc] initWithFrame:self.bounds];
    [cropperControl setUpWithPath:path];
    [cropperControl setTarget:self andDoneBtn:@selector(showAttachImage:) andCancelBtn:nil];
    [self addSubview:cropperControl];
   
}
-(void)showAttachImage:(NSString *)path
{
    attachedImage.hidden=false;
    
    CGRect frame=attachedImage.frame;
    [attachedImage cleanUp];
    [attachedImage setUp:path andRect:frame];
    [attachedImage openFullMode:nil];
    
}

-(void)cancelPostBtnClicked:(id)sender
{
    
    [statusView resignFirstResponder];

    FCAlertView *alert = [[FCAlertView alloc] init];
    
    [alert showAlertInView:self
                 withTitle:@""
              withSubtitle:@"Are you sure you want to cancel this post?"
           withCustomImage:nil
       withDoneButtonTitle:@"Yes"
                andButtons:nil];
    
    
    [alert addButton:@"Cancel" withActionBlock:^{
        // Put your action here
    }];


    [alert doneActionBlock:^{
        
        [FTIndicator setIndicatorStyle:UIBlurEffectStyleDark];
      //  [FTIndicator showToastMessage:@"Post Cancelled"];
        
        [UIView animateWithDuration:0.1 animations:^{
            // statusLabel.alpha=0;
            // galleryView.alpha=0;
            // label.alpha=0;
            
            
        } completion:^(BOOL finished) {
            
            
            [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                containerView.frame=CGRectMake(0,self.frame.size.height, self.frame.size.width, 0);
                self.backgroundColor=[UIColor clearColor];
                
                
                
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                [target performSelector:closeCallBackfunc withObject:nil afterDelay:0.01];

            }];
            
            
            
        }];
    }];


   

}
-(void)postBtnClicked:(id)sender
{
    
    NSString *statusString=statusView.text;
    NSString *mediaPath=[attachedImage getCurrentPath];
    int channelId=[channelSelectionView getSelectedChannelId];
    if(channelId==-1)
    {
        
        [FTIndicator setIndicatorStyle:UIBlurEffectStyleDark];
        [FTIndicator showToastMessage:@"Please select the channel"];
        return;
        
    }
    if([statusString isEqualToString:@""])
    {
        [FTIndicator setIndicatorStyle:UIBlurEffectStyleDark];
        [FTIndicator showToastMessage:@"Please enter text to post."];
        

        return;
    }
    
    
    
    

    if(mediaPath==nil) {
     
        mediaPath=@"";
    }
    else
    {
        
        NSString *ext = [mediaPath pathExtension];
        
        
        
        if([ext.lowercaseString isEqualToString:@"png"])
        {
            mediaPath=[Constant getCompressedPathFromImagePath:mediaPath];
        }
        
        
       // NSData *data=[NSData dataWithContentsOfFile:mediaPath];
        
       // [FTIndicator showToastMessage:[NSString stringWithFormat:@"final %d kb",(int)data.length/1024]];


    }
    
    
    NSString *topicValue=@"";
    
    if(topicArray.count==0)
    {
        topicValue = @"none";
    }
    else if(topicArray.count==1)
    {
        topicValue = [topicArray objectAtIndex:0];
    }
    else
    {
        topicValue=[topicArray componentsJoinedByString: @","];
    }
    
    NSString *hashTagValue=@"[]";
    if(hashTagArray.count==0)
    {
        
    }
    else if(hashTagArray.count==1)
    {
        hashTagValue=[hashTagArray objectAtIndex:0];
        hashTagValue=[NSString stringWithFormat:@"[\"%@\"]",hashTagValue];
    }
    else
    {
        hashTagValue=[hashTagArray componentsJoinedByString: @"\",\""];
        hashTagValue=[NSString stringWithFormat:@"[\"%@\"]",hashTagValue];
        
    }
    
    NSDictionary *dict=@{
                @"text":statusString,
                @"interest":[NSString stringWithFormat:@"%d",channelId],
                @"media":mediaPath,
                @"topic_names":topicValue,
                @"tags":hashTagValue
                };
   
    UINavigationController *vc=(UINavigationController *)[Constant topMostController];
    ViewController *t=(ViewController *)vc.topViewController;
    [t newPostSubmit:dict];

    [statusView resignFirstResponder];
    
    
    [UIView animateWithDuration:0.1 animations:^{
        // statusLabel.alpha=0;
        // galleryView.alpha=0;
        // label.alpha=0;
        
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            containerView.frame=CGRectMake(0,-self.frame.size.height, self.frame.size.width, 0);
            self.backgroundColor=[UIColor clearColor];

            
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [target performSelector:closeCallBackfunc withObject:nil afterDelay:0.01];

        }];
        
        
        
    }];
    
    
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    CGSize size = [textView sizeThatFits:CGSizeMake(statusView.frame.size.width, FLT_MAX)];
    float height=size.height;
    
    if(height<42)
    {
        height=42;
    }
        
    statusView.frame=CGRectMake(statusView.frame.origin.x, statusView.frame.origin.y, statusView.frame.size.width, height);

    
    int heightAttached=self.frame.size.height-statusView.frame.origin.y-statusView.frame.size.height-170;

    attachedImage.frame=CGRectMake(0, statusView.frame.origin.y+statusView.frame.size.height, self.frame.size.width, heightAttached);


    
    int len =(int)statusView.text.length;
    characterCountLBL.text=[NSString stringWithFormat:@"%i",200-len];
    
    
    
    NSString *string=textView.text;
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:string];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:k_fontRegular size:20]
                  range:NSMakeRange(0, string.length)];
    
    [hogan addAttribute:NSForegroundColorAttributeName
                  value:[UIColor colorWithRed:0.53 green:0.62 blue:0.66 alpha:1.00]
                  range:NSMakeRange(0, string.length)];
    
    NSError *error1 = nil;
        NSError *error2 = nil;
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error1];
    NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:&error2];

    NSArray *matches1 = [regex1 matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    NSArray *matches2 = [regex2 matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    
   

    topicArray=[[NSMutableArray alloc] init];
    hashTagArray=[[NSMutableArray alloc] init];


    for (NSTextCheckingResult *match in matches1)
    {
        NSRange wordRange = [match rangeAtIndex:0];
        NSString* word = [string substringWithRange:wordRange];
        NSLog(@"Found tag %@", word);
        
        [hogan addAttribute:NSForegroundColorAttributeName
                      value:[UIColor colorWithRed:0.00 green:0.76 blue:0.89 alpha:1.00]
                      range:wordRange];
        
        NSRange hashTagRange = [match rangeAtIndex:1];
        NSString* hashTag = [string substringWithRange:hashTagRange];

        [hashTagArray addObject:hashTag];
        
    }
    
    
    for (NSTextCheckingResult *match in matches2) {
        NSRange wordRange = [match rangeAtIndex:0];
        NSString* word = [string substringWithRange:wordRange];
        NSLog(@"Found tag %@", word);
        
        [hogan addAttribute:NSForegroundColorAttributeName
                      value:[UIColor colorWithRed:0.00 green:0.76 blue:0.89 alpha:1.00]
                      range:wordRange];
        
        NSRange topicRange = [match rangeAtIndex:1];
        NSString* topicName = [string substringWithRange:topicRange];

        [topicArray addObject:topicName];
        

    }
        [self setTopic:topicArray];
    
    
    textView.attributedText=hogan;
   
    

}
-(void)setTopic:(NSArray *)array
{
    if(array.count==0)
    {
    replyToLBL.text=@"@topic";
    replyToLBL.textColor=[UIColor lightGrayColor];
    }
    else
    {
        replyToLBL.text=[array componentsJoinedByString: @" "];

        replyToLBL.textColor=[UIColor colorWithRed:0.00 green:0.76 blue:0.89 alpha:1.00];

    }

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            return YES;
        }
    }
    else if([[textView text] length] > 199)
    {
        return NO;
    }
    return YES;
}


@end
