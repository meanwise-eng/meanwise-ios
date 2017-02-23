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

-(void)setUpWithCellRect:(CGRect)rect
{
    [self setUpCellRect:rect];
    containerView.backgroundColor=[UIColor whiteColor];
    self.clipsToBounds=YES;
    
    containerView.clipsToBounds=YES;
    
    profileIMGVIEW=[[UIImageHM alloc] initWithFrame:CGRectZero];
    [containerView addSubview:profileIMGVIEW];
    [profileIMGVIEW setUp:[UserSession getProfilePictureURL]];
    
    profileIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
    profileIMGVIEW.clipsToBounds=YES;
    profileIMGVIEW.frame=CGRectMake(15, 30, 50, 50);
    profileIMGVIEW.layer.cornerRadius=25;
    
    postBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-65,30, 50, 40)];
    [postBtn setTitle:@"Post" forState:UIControlStateNormal];
    [containerView addSubview:postBtn];
    [postBtn setTitleColor:[UIColor colorWithRed:0.00 green:0.76 blue:0.89 alpha:1.00] forState:UIControlStateNormal];
    postBtn.titleLabel.font=[UIFont fontWithName:k_fontRegular size:20];
    [postBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [postBtn addTarget:self action:@selector(postBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    statusView=[[UITextView alloc] initWithFrame:CGRectMake(15, 85, self.frame.size.width-30, 200)];
   // statusView.backgroundColor=[UIColor grayColor];
    [containerView addSubview:statusView];
    statusView.font=[UIFont fontWithName:k_fontRegular size:20];
    statusView.delegate=self;
    
   
    attachedImage=[[PreviewViewComponent alloc] initWithFrame:CGRectMake(15, 85+200, self.frame.size.width/2, 150)];
    [containerView addSubview:attachedImage];
    attachedImage.hidden=true;
    attachedImage.clipsToBounds=YES;
    
    
    
   // attachedImage.center=CGPointMake(self.frame.size.width/2, attachedImage.center.y);
    
    
    
    

    characterCountLBL=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-50, 25, 100,50)];
    [containerView addSubview:characterCountLBL];
    characterCountLBL.font=[UIFont fontWithName:k_fontRegular size:20];
    characterCountLBL.text=@"200";
    characterCountLBL.textAlignment=NSTextAlignmentCenter;
    
    
    
    UIView *seperator1=[[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-170, self.frame.size.width, 1)];
    seperator1.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.1f];
    [containerView addSubview:seperator1];
    
    
    
    replyToLBL=[[UILabel alloc] initWithFrame:CGRectMake(15,self.frame.size.height-170, self.frame.size.width-30,50)];
    [containerView addSubview:replyToLBL];
    replyToLBL.font=[UIFont fontWithName:k_fontRegular size:20];
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
    
    
 
    
    
}
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
    
    [self setGestureEnabled:true];
}
-(void)postBtnClicked:(id)sender
{
    /*
    NSDictionary *dict1=@{
                          @"text":@"Sports, Sea",
                          @"interest":@"1",
                          };
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mag_app_reducedvid" ofType:@"mp4"];
     */
    
    NSString *statusString=statusView.text;
    NSString *mediaPath=[attachedImage getCurrentPath];
    int channelId=[channelSelectionView getSelectedChannelId];
    if(channelId==-1)
    {
        
        [Constant okAlert:@"Alert!" withSubTitle:@"Please select the channel." onView:self andStatus:-1];
        return;
        
    }
    if([statusString isEqualToString:@""])
    {
        [Constant okAlert:@"Alert!" withSubTitle:@"Please enter text to post." onView:self andStatus:-1];
        return;
    }
    
    

    if(mediaPath==nil) mediaPath=@"";
    
    
    NSDictionary *dict=@{
                @"text":statusString,
                @"interest":[NSString stringWithFormat:@"%d",channelId],
                @"media":mediaPath
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

        }];
        
        
        
    }];
    
    
    
}

-(void)textViewDidChange:(UITextView *)textView
{
   
    
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
    
    
   


    for (NSTextCheckingResult *match in matches1) {
        NSRange wordRange = [match rangeAtIndex:0];
        NSString* word = [string substringWithRange:wordRange];
        NSLog(@"Found tag %@", word);
        
        [hogan addAttribute:NSForegroundColorAttributeName
                      value:[UIColor colorWithRed:0.00 green:0.76 blue:0.89 alpha:1.00]
                      range:wordRange];
    }
    
    NSMutableArray *arrayTopic=[[NSMutableArray alloc] init];
    for (NSTextCheckingResult *match in matches2) {
        NSRange wordRange = [match rangeAtIndex:0];
        NSString* word = [string substringWithRange:wordRange];
        NSLog(@"Found tag %@", word);
        
        [hogan addAttribute:NSForegroundColorAttributeName
                      value:[UIColor colorWithRed:0.00 green:0.76 blue:0.89 alpha:1.00]
                      range:wordRange];
        
        [arrayTopic addObject:word];
        

    }
        [self setTopic:arrayTopic];
    
    
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
