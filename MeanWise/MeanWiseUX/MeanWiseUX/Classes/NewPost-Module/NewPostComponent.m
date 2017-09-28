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

@implementation NewPostComponent


-(void)setUpNavBar
{
    UIView *navBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 65)];
    [containerView addSubview:navBar];
    navBar.backgroundColor=[UIColor whiteColor];
    
    UIView *seperator=[[UIView alloc] initWithFrame:CGRectMake(0,65,self.frame.size.width, 1)];
    [containerView addSubview:seperator];
    seperator.backgroundColor=[UIColor colorWithWhite:0.6 alpha:0.1];
    
    
    
    
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
    
    

}
-(void)setUpWithCellRect:(CGRect)rect
{
    [self setUpCellRect:rect];
    containerView.backgroundColor=[UIColor whiteColor];
    self.clipsToBounds=YES;
    isPostHasAttachment=false;
    containerView.clipsToBounds=YES;

    
    [AnalyticsMXManager PushAnalyticsEventAction:@"NewPost-In"];

    
    [self setUpNavBar];
    
    
    topicArray=[[NSMutableArray alloc] init];
    
    
    profileIMGVIEW=[[UIImageHM alloc] initWithFrame:CGRectMake(15, 65+10, 50, 50)];
    [containerView addSubview:profileIMGVIEW];
    [profileIMGVIEW setUp:[UserSession getProfilePictureURL]];
    
    profileIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
    profileIMGVIEW.clipsToBounds=YES;
    profileIMGVIEW.layer.cornerRadius=25;
    
    
    
    statusView=[[SAMTextView alloc] initWithFrame:CGRectMake(15, 65+70, self.frame.size.width-40, 42*2)];
    [containerView addSubview:statusView];
    statusView.font=[UIFont fontWithName:k_fontRegular size:20];
    statusView.delegate=self;
    statusView.keyboardType=UIKeyboardTypeTwitter;
    statusView.scrollEnabled=false;
    statusView.placeholder=@"Write a caption here use '@' to mention users and '#' for hashtags";
   
    
    int height=self.frame.size.height-statusView.frame.origin.y-statusView.frame.size.height-170;
    
    mediaAttachComponent=[[PreviewMaxScreen alloc] initWithFrame:CGRectMake(0, statusView.frame.origin.y+statusView.frame.size.height, self.frame.size.width, height)];
    mediaAttachComponent.backgroundColor=[UIColor grayColor];
    [containerView addSubview:mediaAttachComponent];
    mediaAttachComponent.hidden=true;
    mediaAttachComponent.clipsToBounds=YES;
    [mediaAttachComponent setTarget:self showFullScreenCallBack:@selector(mediaManupulatorOpen:) andShowThumbCallBack:@selector(mediaManupulatorClose:)];

    [mediaAttachComponent setAttachmentRemoveCallBack:@selector(attachmentRemove:)];


    characterCountLBL=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-50, 65+10, 100,50)];
    [containerView addSubview:characterCountLBL];
    characterCountLBL.font=[UIFont fontWithName:k_fontRegular size:20];
    characterCountLBL.text=@"200";
    characterCountLBL.textColor=[UIColor grayColor];
    characterCountLBL.textAlignment=NSTextAlignmentCenter;
    
    locationBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-15-50, 65+10,50, 50)];
    [containerView addSubview:locationBtn];
    [locationBtn setBackgroundColor:[UIColor clearColor]];
    [locationBtn setBackgroundImage:[UIImage imageNamed:@"post_location_on.png"] forState:UIControlStateSelected];
    [locationBtn setBackgroundImage:[UIImage imageNamed:@"post_location_off.png"] forState:UIControlStateNormal];
    
    locationBtn.layer.cornerRadius=50/2;
    locationBtn.clipsToBounds=YES;
    [locationBtn addTarget:self action:@selector(locationToggleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    
    UIView *seperator1=[[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-170, self.frame.size.width, 1)];
    seperator1.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.1f];
    [containerView addSubview:seperator1];
    
    topicListBtn=[[UIButton alloc] initWithFrame:CGRectMake(15,self.frame.size.height-170, self.frame.size.width-30,50)];
    [containerView addSubview:topicListBtn];
    topicListBtn.titleLabel.font=[UIFont fontWithName:k_fontRegular size:20];
    topicListBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [topicListBtn setTitleColor:[UIColor colorWithRed:0.77 green:0.26 blue:0.78 alpha:1.00] forState:UIControlStateNormal];
    [topicListBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];;
    [topicListBtn setTitle:@"+topic" forState:UIControlStateNormal];
    [topicListBtn addTarget:self action:@selector(topicListBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *seperator2=[[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-115, self.frame.size.width, 1)];
    seperator2.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.1f];
    [containerView addSubview:seperator2];

    
    UIView *seperator3=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-55, self.frame.size.width, 1)];
    seperator3.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.1f];
    [containerView addSubview:seperator3];
    
    
    photoControllerBtns=[[PhotosBtnController alloc] initWithFrame:CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 50)];
    [containerView addSubview:photoControllerBtns];
    [photoControllerBtns setUp];
    [photoControllerBtns setTarget:self andSel1:@selector(cameraSelect:) andSel2:@selector(gallerySelect:)];
    

    channelSelectionView=[[ChannelSearchView alloc] initWithFrame:self.bounds];
    [channelSelectionView setUp];
    [containerView addSubview:channelSelectionView];
    [channelSelectionView setState1Frame:CGRectMake(20, self.frame.size.height-115, self.frame.size.width, 50)];

 
    
     geo_location_lat=0.00;
     geo_location_lng=0.00;

    
    [self cameraSelect:nil];
    
    suggestionView=[[UITextViewSuggestionsBox alloc] initWithFrame:CGRectMake(-5, 0, self.frame.size.width+10, 0)];
    suggestionView.backgroundColor=[UIColor grayColor];
    [self addSubview:suggestionView];
    
    [suggestionView setUp];
    [suggestionView setPotisionUp:false andThemeDark:FALSE];
    
    [suggestionView setTarget:self onSelect:@selector(suggestionSelected:)];
    
    acHelper=[[UITextViewAutoSuggestionsDataSource alloc] init];
    [acHelper setTextView:statusView];
    [acHelper setSuggestionView:suggestionView];
    [acHelper setUp];
}

-(void)suggestionSelected:(id)selectedItem
{
    [acHelper suggestionSelected:selectedItem];
}
-(void)locationToggleBtnClicked:(id)sender
{
    locationBtn.selected=!locationBtn.selected;
    
    if(locationBtn.selected==false)
    {
        geo_location_lat=0.00;
        geo_location_lng=0.00;
     
    }
    else
    {
        blockc=[[LocationManagerBlock alloc] init];
        [blockc setUp];
        [blockc updateCurrentLocation:^(CLLocation *currentLocation)
         {
             if(currentLocation==nil)
             {
                 geo_location_lat=0.00;
                 geo_location_lng=0.00;
                 locationBtn.selected=false;
                 [FTIndicator showToastMessage:@"Sorry couldn't able to locate you."];
             }
             else
             {
                 geo_location_lat=currentLocation.coordinate.latitude;
                 geo_location_lng=currentLocation.coordinate.longitude;
                 


                 
             }
             blockc=nil;

         }];
        
    }
    
}
-(void)topicListBtnClicked:(id)sender
{
    if(topicControl==nil)
    {
        
        [self setGestureEnabled:false];


    topicControl=[[TopicAutoCompleteControl alloc] initWithFrame:CGRectMake(0,self.frame.size.height+5, self.frame.size.width,50)];
    [containerView addSubview:topicControl];
    [topicControl setUp:self.bounds withData:topicArray];
    [topicControl setTarget:self onCloseFunc:@selector(onTopicControlClose:)];
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            topicListBtn.frame=CGRectMake(-self.frame.size.width-15,self.frame.size.height-170, self.frame.size.width-30,50);

        } completion:^(BOOL finished) {
            
        }];
        
    }
}
-(void)onTopicControlClose:(NSMutableArray *)array
{
    [topicControl removeFromSuperview];
    topicControl=nil;
    
    if(array!=nil)
    {
    [self setTopic:[NSArray arrayWithArray:array]];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        topicListBtn.frame=CGRectMake(15,self.frame.size.height-170, self.frame.size.width-30,50);
        
    } completion:^(BOOL finished) {
        [self setGestureEnabled:true];

    }];
    
}
-(void)showTutorial
{
    
    if([Constant isNewPostTutorialFinished]==false)
    {
        [FTIndicator showToastMessage:@"The post can include topics and hashtags to make it easier to be found. To create a topic type the topic name followed by the @symbol. To create hashtags use the #symbol."];
        
    }

    
   
}

#pragma mark - Item Setup

-(void)gallerySelect:(id)sender
{

    [self setGestureEnabled:false];
    photoGallery=[[PhotoGallery alloc] initWithFrame:self.bounds];
    [containerView addSubview:photoGallery];
    [photoGallery setTarget:self andSel1:@selector(cancelBtnClicked:) andSel2:@selector(mediaSelected:)];
    [photoGallery setUp:0];
    
}
-(void)cameraSelect:(id)sender
{

    [self setGestureEnabled:false];
    photoGallery=[[PhotoGallery alloc] initWithFrame:self.bounds];
    [containerView addSubview:photoGallery];
    [photoGallery setTarget:self andSel1:@selector(cancelBtnClicked:) andSel2:@selector(mediaSelected:)];
    [photoGallery setUp:1];
    
}
-(void)RepickAnother:(id)sender
{
    [self gallerySelect:nil];
    
}
-(void)mediaSelected:(NSDictionary *)dict
{

    NSString *path=[dict valueForKey:@"path"];
    BOOL isSourceCamera=[[dict valueForKey:@"isSourceCamera"] boolValue];
    

    
    cropperControl=[[MediaCropper alloc] initWithFrame:self.bounds];
    [cropperControl setUpWithPath:path];
    [cropperControl setTarget:self andDoneBtn:@selector(showAttachImage:) andCancelBtn:@selector(RepickAnother:)];
    
    [self addSubview:cropperControl];

    if(isSourceCamera==true)
    {
        [AnalyticsMXManager PushAnalyticsEventAction:@"NewPost-From Camera attached"];

        [cropperControl setDirectCrop];

    }
    else
    {
        [AnalyticsMXManager PushAnalyticsEventAction:@"NewPost-From Gallery attached"];

    }

}
-(void)showAttachImage:(NSString *)path
{
    

    mediaAttachComponent.hidden=false;
    CGRect frame=mediaAttachComponent.frame;
    [mediaAttachComponent cleanUp];
    [mediaAttachComponent seUpBasics:frame];
    [mediaAttachComponent setUpPath:path];
    [mediaAttachComponent openFullScreen:nil];
    
    isPostHasAttachment=true;
    

    
}
#pragma mark - Post Actions

-(void)attachmentRemove:(id)sender
{
    [AnalyticsMXManager PushAnalyticsEventAction:@"NewPost-Attachment Remove"];

        [mediaAttachComponent cleanUp];
        mediaAttachComponent.hidden=true;

    isPostHasAttachment=false;

}


-(void)cancelBtnClicked:(id)sender
{
    [self showTutorial];
    [self setGestureEnabled:true];
    
}

-(void)cancelPostBtnClicked:(id)sender
{
    [AnalyticsMXManager PushAnalyticsEventAction:@"NewPost-Cancel Post"];

    
    [statusView resignFirstResponder];

    FCAlertView *alert = [[FCAlertView alloc] init];
    
    [alert showAlertInView:self
                 withTitle:@""
              withSubtitle:@"Are you sure want to cancel this post?"
           withCustomImage:nil
       withDoneButtonTitle:@"Yes"
                andButtons:nil];
    
    
    [alert addButton:@"Cancel" withActionBlock:^{
        // Put your action here
    }];


    [alert doneActionBlock:^{
        
        [mediaAttachComponent cleanUp];

        [FTIndicator setIndicatorStyle:UIBlurEffectStyleDark];
        [FTIndicator showToastMessage:@"Post Cancelled"];
        
        [UIView animateWithDuration:0.1 animations:^{
            
            
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
    [AnalyticsMXManager PushAnalyticsEventAction:@"NewPost-Post Button Clicked"];


    NSString *statusString=statusView.text;
    
    
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
    
    
    //If validation is correct

    
    //Retriving Topic and Hashtags
    NSString *topicValue=@"";
    if(topicArray.count==0)
    {
        
    }
    else if(topicArray.count==1)
    {
        topicValue=[topicArray objectAtIndex:0];
    }
    else
    {
        topicValue=[topicArray componentsJoinedByString: @","];
    }
    
    
    
    NSMutableArray *hashTagArray=[acHelper getAllHashTagWords];
    NSArray *mentioned_users=[acHelper getAllUniqueUserMentionsIds];
    

    
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
    


  
    UINavigationController *vc=(UINavigationController *)[Constant topMostController];
    ViewController *t=(ViewController *)vc.topViewController;

    
    if(isPostHasAttachment==true && [mediaAttachComponent isMediaTypeVideo]==false)
    {
        NSString *mediaPath=[mediaAttachComponent getFinalOutPutPath];
        
        if(mediaPath==nil)
        {
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
          //  [FTIndicator showToastMessage:[NSString stringWithFormat:@"final %d kb",(int)data.length/1024]];
            
        }
        
        [AnalyticsMXManager PushAnalyticsEventAction:@"NewPost-Post Image Posted"];

        
    
        
        NSDictionary *dict=@{
                             @"text":statusString,
                             @"interest":[NSString stringWithFormat:@"%d",channelId],
                             @"media":mediaPath,
                             @"topic_names":topicValue,
                             @"tags":hashTagValue,
                             @"mentioned_users":mentioned_users,
                             @"geo_location_lat":[NSNumber numberWithDouble:geo_location_lat],
                             @"geo_location_lng":[NSNumber numberWithDouble:geo_location_lng],
                             
                             };
        [t newPostSubmit:[[NSDictionary alloc] initWithDictionary:dict]];

        
    }
    else if(isPostHasAttachment==false)
    {
        [AnalyticsMXManager PushAnalyticsEventAction:@"NewPost-Post Text Posted"];

        NSDictionary *dict=@{
                             @"text":statusString,
                             @"interest":[NSString stringWithFormat:@"%d",channelId],
                             @"media":@"",
                             @"topic_names":topicValue,
                             @"tags":hashTagValue,
                             @"mentioned_users":mentioned_users,
                             @"geo_location_lat":[NSNumber numberWithDouble:geo_location_lat],
                             @"geo_location_lng":[NSNumber numberWithDouble:geo_location_lng],
                             

                             };
        [t newPostSubmit:[[NSDictionary alloc] initWithDictionary:dict]];

        
    }
    else if(isPostHasAttachment==true && [mediaAttachComponent isMediaTypeVideo]==true)
    {
        
        [AnalyticsMXManager PushAnalyticsEventAction:@"NewPost-Post Video Posted"];

        
        NSString *mediaPath=[mediaAttachComponent getCroppedVideoPath];
        
        UIImage *image=[mediaAttachComponent getOverLayVideoImage];
        
        NSDictionary *metaData=[mediaAttachComponent getMetaDataOptions];
        
        NSDictionary *dict=@{
                             @"text":statusString,
                             @"interest":[NSString stringWithFormat:@"%d",channelId],
                             @"topic_names":topicValue,
                             @"tags":hashTagValue,
                             @"metaData":metaData,
                             @"mentioned_users":mentioned_users,
                             @"geo_location_lat":[NSNumber numberWithDouble:geo_location_lat],
                             @"geo_location_lng":[NSNumber numberWithDouble:geo_location_lng],

                             };
        
        [t renderVideoAndPost:[[NSDictionary alloc] initWithDictionary:dict] witPath:mediaPath overlayImage:image];
        
    }
    
    
    
    
    
    
    
    
    [statusView resignFirstResponder];
    [mediaAttachComponent cleanUp];
    
    [UIView animateWithDuration:0.1 animations:^{
    
        
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



#pragma mark - Helper
-(void)setTopic:(NSArray *)array
{
    topicArray=[NSMutableArray arrayWithArray:array];;
    
    if(array.count==0)
    {
        
        [topicListBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];;
        [topicListBtn setTitle:@"+topic" forState:UIControlStateNormal];
        topicListBtn.titleLabel.font=[UIFont fontWithName:k_fontRegular size:20];

    }
    else
    {
        
        NSString *string=[NSString stringWithFormat:@"%@",[array componentsJoinedByString: @", "]];
        
        
        topicListBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:20];

        [topicListBtn setTitleColor:[UIColor colorWithRed:0.00 green:0.76 blue:0.89 alpha:1.00] forState:UIControlStateNormal];;
        [topicListBtn setTitle:string forState:UIControlStateNormal];
        topicListBtn.titleLabel.adjustsFontSizeToFitWidth=YES;

    }
    
}
-(void)setTarget:(id)targetReceived onCloseEvent:(SEL)func1;
{
    target=targetReceived;
    closeCallBackfunc=func1;
    
}

-(void)mediaManupulatorOpen:(id)sender
{
    [statusView resignFirstResponder];
    
    [containerView bringSubviewToFront:mediaAttachComponent];
    
    NSLog(@"openFull");
    [self setGestureEnabled:false];
    
}
-(void)mediaManupulatorClose:(id)sender
{
        [self showTutorial];
    NSLog(@"openSmall");
    [self setGestureEnabled:true];
    
}

-(void)zoomDownOut
{
    [target performSelector:closeCallBackfunc withObject:nil afterDelay:0.01];
}

#pragma mark - Text Methods
- (void)textViewDidEndEditing:(UITextView *)textView;
{
    [acHelper cancelSearch];
}
-(void)textViewDidChange:(UITextView *)textView
{
    
    CGSize size = [textView sizeThatFits:CGSizeMake(statusView.frame.size.width, FLT_MAX)];
    float height=size.height;
    
    if(height<42*2)
    {
        height=42*2;
    }
    
    statusView.frame=CGRectMake(statusView.frame.origin.x, statusView.frame.origin.y, statusView.frame.size.width, height);
    
    
    int heightAttached=self.frame.size.height-statusView.frame.origin.y-statusView.frame.size.height-170;
    
    
    mediaAttachComponent.frame=CGRectMake(0, statusView.frame.origin.y+statusView.frame.size.height, self.frame.size.width, heightAttached);

    
    
    
    int len =(int)statusView.text.length;
    characterCountLBL.text=[NSString stringWithFormat:@"%i",200-len];
    
    
  
    
    [acHelper textViewDidChange:textView];

    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL flag= [acHelper textView:textView shouldChangeTextInRange:range replacementText:text];

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
