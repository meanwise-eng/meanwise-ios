//
//  NewPostVC.m
//  MeanWiseUX
//
//  Created by Mohamed Aas on 4/16/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "NewPostVC.h"
#import "APIManager.h"
#import "APIObjectsParser.h"
#import "DataSession.h"
#import "APIObjects_FeedObj.h"
#import "NewPostStoryCell.h"
#import "FTIndicator.h"
#import "ViewController.h"


@interface NewPostVC ()

@end


@implementation NewPostVC

- (instancetype)initWithSession:(APIObjects_ProfileObj*)session
{
    self = [super init];
    if (self)
    {
        self.sessionMain = session;
    }
    return self;
}

-(void)setTarget:(id)delegate setNewPost:(SEL)func1
{
    mainTarget = delegate;
    newPostFunc = func1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    storyId = @"";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *navBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 65)];
    navBar.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:navBar];
    
    
    UIView *seperator=[[UIView alloc] initWithFrame:CGRectMake(0,65,self.view.bounds.size.width, 1)];
    seperator.backgroundColor=[UIColor colorWithWhite:0.6 alpha:0.1];
    [self.view addSubview:seperator];

    
    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(10,20, 70, 45)];
    [backBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor colorWithRed:0.00 green:0.76 blue:0.89 alpha:1.00] forState:UIControlStateNormal];
    backBtn.titleLabel.font=[UIFont fontWithName:k_fontRegular size:18];
    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(cancelPostBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    postBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-70-10,20, 70, 45)];
    [postBtn setTitle:@"Publish" forState:UIControlStateNormal];
    [self.view addSubview:postBtn];
    [postBtn setTitleColor:[UIColor colorWithRed:0.00 green:0.76 blue:0.89 alpha:1.00] forState:UIControlStateNormal];
    postBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:18];
    [postBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [postBtn addTarget:self action:@selector(postBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    profileIMGVIEW=[[UIImageHM alloc] initWithFrame:CGRectMake(15, 65+10, 50, 50)];
    [self.view addSubview:profileIMGVIEW];
    [profileIMGVIEW setUp:[UserSession getProfilePictureURL]];
    profileIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
    profileIMGVIEW.clipsToBounds=YES;
    profileIMGVIEW.layer.cornerRadius=25;
    
    
    statusView=[[UITextView alloc] initWithFrame:CGRectMake(15, 65+70, self.view.bounds.size.width-40, 42)];
    [self.view addSubview:statusView];
    statusView.font=[UIFont fontWithName:k_fontLight size:20];
    statusView.placeholder = @"Say something ...";
    statusView.placeholderColor = [UIColor lightGrayColor];
    statusView.delegate=self;
    
    int height=self.view.frame.size.height-statusView.frame.origin.y-statusView.frame.size.height-170;
    
    imagePreview=[[NewPostImagePreview alloc] initWithFrame:CGRectMake(0, statusView.frame.origin.y+statusView.frame.size.height, self.view.frame.size.width, height)];
    imagePreview.backgroundColor=[UIColor grayColor];
    [self.view addSubview:imagePreview];
    imagePreview.hidden=true;
    imagePreview.clipsToBounds=YES;
    [imagePreview setTarget:self showFullScreenCallBack:@selector(mediaManupulatorOpen:) andShowThumbCallBack:@selector(mediaManupulatorClose:)];
    
    videoPreview=[[NewPostVideoPreview alloc] initWithFrame:CGRectMake(0, statusView.frame.origin.y+statusView.frame.size.height, self.view.frame.size.width, height)];
    videoPreview.backgroundColor=[UIColor grayColor];
    [self.view addSubview:videoPreview];
    videoPreview.hidden=true;
    videoPreview.clipsToBounds=YES;
    [videoPreview setTarget:self showFullScreenCallBack:@selector(mediaManupulatorOpen:) andShowThumbCallBack:@selector(mediaManupulatorClose:)];
    
    
    characterCountLBL=[[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-50, 65+10, 100,50)];
    [self.view addSubview:characterCountLBL];
    characterCountLBL.font=[UIFont fontWithName:k_fontLight size:24];
    characterCountLBL.text=@"200";
    characterCountLBL.textColor=[UIColor colorWithRed:144/255.0 green:164/255.0 blue:174/255.0 alpha:1.0];
    characterCountLBL.textAlignment=NSTextAlignmentCenter;
    
    
    UIView *seperator1=[[UIView alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height-205, self.view.bounds.size.width, 1)];
    seperator1.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.1f];
    seperator1.alpha = 0;
    [self.view addSubview:seperator1];
    
    
    replyToLBL=[[UILabel alloc] initWithFrame:CGRectMake(10,self.view.bounds.size.height-205, self.view.bounds.size.width-30,50)];
    [self.view addSubview:replyToLBL];
    replyToLBL.font=[UIFont fontWithName:k_fontRegular size:16];
    replyToLBL.text=@"@designerNews";
    replyToLBL.textAlignment=NSTextAlignmentLeft;
    replyToLBL.textColor=[UIColor colorWithRed:0.77 green:0.26 blue:0.78 alpha:1.00];
    replyToLBL.text=@"@topic";
    replyToLBL.textColor=[UIColor lightGrayColor];
    replyToLBL.alpha = 0;
    
    
    UIView *seperator2=[[UIView alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height-158, self.view.bounds.size.width, 1)];
    seperator2.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.1f];
    [self.view addSubview:seperator2];
    
    
    UIView *seperator3=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-52, self.view.bounds.size.width, 1)];
    seperator3.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.1f];
    [self.view addSubview:seperator3];
    
    
    CGRect collectionViewFrame = CGRectMake(0, self.view.bounds.size.height-155, self.view.bounds.size.width, 100);
    
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    
    feedList = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    feedList.delegate = self;
    feedList.dataSource = self;
    feedList.showsHorizontalScrollIndicator = NO;
    feedList.backgroundColor=[UIColor clearColor];
    [feedList registerClass:[NewPostStoryCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    feedList.alwaysBounceHorizontal=YES;
    feedList.allowsMultipleSelection=NO;
    feedList.bounces=true;
    [self.view addSubview:feedList];
    
    
    channelSelectionView=[[ChannelSearchView alloc] initWithFrame:self.view.bounds];
    [channelSelectionView setUp];
    [self.view addSubview:channelSelectionView];
    [channelSelectionView setState1Frame:CGRectMake(10, self.view.bounds.size.height-55, self.view.bounds.size.width, 50)];
    
    
    cameraView = [[CameraView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:cameraView];
    [cameraView setTarget:self andSel1:@selector(cancelBtnClicked:) andSel2:@selector(showImagePreview:) andSel3:@selector(showVideoPreview:)];
    [cameraView setUp:0];
    
    [self manuallyRefresh];
    
}

-(void)mediaManupulatorOpen:(id)sender
{
    
}

-(void)mediaManupulatorClose:(id)sender
{
    
}

-(void)cancelBtnClicked:(id)sender
{
    
}

-(void)showImagePreview:(UIImage *)image
{
    imagePreview.hidden=false;
    
    CGRect frame = imagePreview.frame;
    [imagePreview cleanUp];
    [imagePreview setImage:image andRect:frame];
    [imagePreview openFullMode:nil];
}

-(void)showVideoPreview:(SCRecordSession *)session
{
    videoPreview.hidden=false;
    
    CGRect frame = videoPreview.frame;
    [videoPreview cleanUp];
    [videoPreview setSession:session andRect:frame];
    [videoPreview openFullMode:nil];
}

-(void)manuallyRefresh
{

    [Constant setStatusBarColorWhite:false];
    
    manager=[[APIManager alloc] init];
    
    [manager sendRequestForPostOfUsersId:[NSString stringWithFormat:@"%@",[UserSession getUserId]] delegate:self andSelector:@selector(UserPostReceived:)];

}


-(void)UserPostReceived:(APIResponseObj *)responseObj
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *responseArray=[NSMutableArray arrayWithArray:(NSArray *)responseObj.response];
        
        APIObjectsParser *parser=[[APIObjectsParser alloc] init];
        
        dataRecords=[NSMutableArray arrayWithArray:[parser parseObjects_FEEDPOST:responseArray]];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [feedList reloadData];
            
        });
        
        
    });

    
}


-(void)cancelPostBtnClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)postBtnClicked:(id)sender
{
    
    NSString *statusString=statusView.text;
    
    int channelId=[channelSelectionView getSelectedChannelId];
    if(channelId==-1)
    {
        
        [FTIndicator setIndicatorStyle:UIBlurEffectStyleDark];
        [FTIndicator showToastMessage:@"Please select the channel"];
        return;
        
    }
    else{
        channelIDVal = channelId;
    }
    
    if([statusString isEqualToString:@""])
    {
        [FTIndicator setIndicatorStyle:UIBlurEffectStyleDark];
        [FTIndicator showToastMessage:@"Please enter text to post."];
        
        
        return;
    }
    else{
        statusTextVal = statusString;
    }
    
    
    
    if(isProgressing){
        isProgressing = NO;
        postMedia = nil;
        postMediaType = nil;
        [autoTimer invalidate];
    }
    else{
       [FTProgressIndicator showProgressWithmessage:@"Preparing post" userInteractionEnable:NO];
       autoTimer = [NSTimer scheduledTimerWithTimeInterval:(0.5)
                                                     target:self
                                                   selector:@selector(fetchPostMedia)
                                                   userInfo:nil 
                                                    repeats:YES];
    }
    
    
    
}


-(void)fetchPostMedia
{
    
    if(postMedia == nil){
            if([videoPreview isHidden] && ![imagePreview isHidden]){
                postMedia = [imagePreview getImageData];
                postMediaType = @"image";
            }
            else if([imagePreview isHidden] && ![videoPreview isHidden]){
                postMedia = [videoPreview getVideoData];
                postMediaType = @"video";
            }
            else
            {
                postMedia = [[NSData alloc] init];
                postMediaType = @"none";
            }
        
    }
    else{
    
        [autoTimer invalidate];
        
        
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
                                 @"text":statusTextVal,
                                 @"interest":[NSString stringWithFormat:@"%d",channelIDVal],
                                 @"media":postMedia,
                                 @"type":postMediaType,
                                 @"topic_names":topicValue,
                                 @"tags":hashTagValue
                                 };
            
            
            [mainTarget performSelector:newPostFunc withObject:dict afterDelay:0.5];
            
            [statusView resignFirstResponder];
            
            
            [FTProgressIndicator dismiss];
            
            
            [UIView animateWithDuration:0.1 animations:^{
                
                
            } completion:^(BOOL finished) {
                
                [videoPreview cleanUp];
                [imagePreview cleanUp];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
                
                
            }];
        
    }
    
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
    
    int heightAttached=self.view.frame.size.height-statusView.frame.origin.y-statusView.frame.size.height-170;
    
    imagePreview.frame=CGRectMake(0, statusView.frame.origin.y+statusView.frame.size.height, self.view.frame.size.width, heightAttached);
    videoPreview.frame=CGRectMake(0, statusView.frame.origin.y+statusView.frame.size.height, self.view.frame.size.width, heightAttached);
    
    
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


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
        NewPostStoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];

        APIObjects_FeedObj *obj = [dataRecords objectAtIndex:indexPath.row];
    
        if(cell)
        {
            [cell setDataObj:obj];
        }
    
        return cell;

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return dataRecords.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(70,90);

}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    APIObjects_FeedObj *obj = [dataRecords objectAtIndex:indexPath.row];
    storyId = obj.postId;
    
}

-(void)setTarget:(id)targetReceived onCloseEvent:(SEL)func1
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
