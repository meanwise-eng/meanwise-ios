//
//  TestView.m
//  MeanWiseUX
//
//  Created by Hardik on 01/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "TestView.h"
#import "UIImageHM.h"
#import "SearchComponent.h"
#import "APITesterView.h"
#import "SettingsComponent.h"
#import "SignUpWizardInterestComponent.h"
#import "VideoCacheManager.h"
#import "CGGeometryExtended.h"
#import "HomeScreen.h"
#import "HMVideoPlayer.h"
#import "CommentViewComponent.h"
#import "SnapZoomView.h"
#import "ChatThreadComponent.h"
#import "VideoRecordComponent.h"
#import "ShareComponent.h"
#import "ListView.h"
#import "PreviewViewComponent.h"

#import "PortraitCropComponent.h"

//#import "LoginComponent.h"
//#import "LoginScreenComponent.h"
//#import "ForgetPassComponent.h"
//#import "SignUpWizardNameComponent.h"
//#import "SignUpWizardProfileComponent.h"
//#import "SignUpWizardAppearanceComponent.h"


@implementation TestView

-(void)setUp
{
    
    /*    MaxPlayer *view=[[MaxPlayer alloc] initWithFrame:self.bounds];
     [self addSubview:view];
     [view setUp];
     [view setUpWithURLString:@"https://scontent-cdg2-1.cdninstagram.com/t50.2886-16/14687563_279580865775538_2385905301304901632_n.mp4"];
     */
    
    //    SearchComponent *cmk=[[SearchComponent alloc] initWithFrame:self.bounds];
    //    [cmk setUp];
    //    [self addSubview:cmk];
    
    //    SettingComponent *cmk=[[SettingComponent alloc] initWithFrame:self.bounds];
    //    [cmk setUp];
    //    [self addSubview:cmk];
    //
    
    //    APITesterView *view=[[APITesterView alloc] initWithFrame:self.bounds];
    //    [self addSubview:view];
    //    [view setUp];
    //
    //
    
    
    //   ListView *view=[[ListView alloc] initWithFrame:self.bounds];
    //    [self addSubview:view];
    //    [view setUp];
    //
    
    
    
    //    VideoRecordComponent *t=[[VideoRecordComponent alloc] initWithFrame:self.bounds];
    //    [self addSubview:t];
    //    [t setUp];
    
    //  [self snapChatViewTest];
    
    
    /*  ExploreComponent *ckm=[[ExploreComponent alloc] initWithFrame:self.bounds];
     [ckm setUp];
     [self addSubview:ckm];*/
    
    
    //
    //    ChatThreadComponent *cp=[[ChatThreadComponent alloc] initWithFrame:self.view.bounds];
    //    [self.view addSubview:cp];
    //    [cp setUpFrame:CGRectMake(200, 200, 100, 100) andImage:[UIImage imageNamed:@"profile1.jpg"]];
    //
    //
    //
    /* SignUpWizardInterestComponent *c=[[SignUpWizardInterestComponent alloc] initWithFrame:self.view.bounds];
     [self.view addSubview:c];
     [c setUp];
     */

   
}

-(void)imageTest
{
    
    NSArray *imageURLs=[NSArray arrayWithObjects:
                        @"http://imgsv.imaging.nikon.com/lineup/lens/zoom/normalzoom/af-s_dx_18-140mmf_35-56g_ed_vr/img/sample/sample1_l.jpg",@"http://www.ricoh-imaging.co.jp/english/r_dc/caplio/r7/img/sample_04.jpg",@"http://cdn.gottabemobile.com/wp-content/uploads/2013/04/HTC-One-Photo-Sample-Marbles.jpeg",@"http://imgsv.imaging.nikon.com/lineup/lens/zoom/normalzoom/af-s_nikkor28-300mmf_35-56gd_ed_vr/img/sample/sample4_l.jpg",@"http://petapixel.com/assets/uploads/2012/02/sample1_mini.jpg",@"http://demo.cloudimg.io/s/resize/200/http://sample.li/eiffel.jpg",@"http://imgsv.imaging.nikon.com/lineup/lens/singlefocal/wide/af-s_35mmf_14g/img/sample/sample4_l.jpg",nil];
    
    UIImageHM *hm=[[UIImageHM alloc] init];
    [hm clearImageCache];
    
    for(int i=0;i<[imageURLs count];i++)
    {
        UIImageHM *hm=[[UIImageHM alloc] initWithFrame:CGRectMake(0, i*80, 80, 80)];
        [hm setUp:[imageURLs objectAtIndex:i]];
        [self addSubview:hm];
    }
    
}

#pragma Video Test

-(void)videoTest
{
    videoURLarray=[NSArray arrayWithObjects:
                   @"https://vt.media.tumblr.com/tumblr_oj0m71nxZF1r57o71_480.mp4",
                   @"https://vt.media.tumblr.com/tumblr_oj15owqcRo1s5s7gr.mp4",
                   @"https://vt.media.tumblr.com/tumblr_oj05x8kZBG1ukym19_480.mp4",
                   @"https://vt.media.tumblr.com/tumblr_oiz8jhunbt1r5tm64_480.mp4",
                   @"https://scontent-sin6-1.cdninstagram.com/t50.2886-16/15786218_918767174919977_1730613082868154368_n.mp4",
                   @"https://scontent-sit4-1.cdninstagram.com/t50.2886-16/15819652_703033149871975_9059795892399243264_n.mp4",
                   @"https://scontent-sit4-1.cdninstagram.com/t50.2886-16/15819903_626409450880225_121169926592397312_n.mp4",
                   @"https://scontent-sit4-1.cdninstagram.com/t50.2886-16/15786197_1842546685960185_8973017117565648896_n.mp4",
                   
                   
                   nil];
    
    for(int i=0;i<5;i++)
    {
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(80*i, 20, 80, 30)];
        [button setTitle:@"B" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(VideoTest_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self addSubview:button];
        button.tag=i;
    }
    
    player=[[HMVideoPlayer alloc] initWithFrame:CGRectMake(0, 200,300,300)];
    [self addSubview:player];
    [player setUp];
    [player setURL:[videoURLarray objectAtIndex:arc4random()%(videoURLarray.count)]];
    
    player.center=self.center;
}
-(void)VideoTest_buttonClicked:(UIButton *)sender
{
    if(sender.tag==0)
    {
        [player setURL:[videoURLarray objectAtIndex:arc4random()%(videoURLarray.count)]];
   
    }
    else if(sender.tag==1)
    {
        [player cleanupPlayer];

    }
    else if(sender.tag==2)
    {
        [player cleanupPlayer];
        [player setURL:[videoURLarray objectAtIndex:arc4random()%(videoURLarray.count)]];

    }
    else if (sender.tag==3)
    {
        [player cleanupPlayer];
        [player deletePlayer];

    }
    
    
}

-(void)imageDownload
{
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:imageView];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    
    NSString *imageURL = @"https://wiki.teamfortress.com/w/images/thumb/0/08/Heavy.png/250px-Heavy.png?t=20111118215652";
    
    NSURLSession *session = [self prepareSessionForRequest];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
    [request setHTTPMethod:@"GET"];
    
    [request setCachePolicy:NSURLRequestReloadRevalidatingCacheData];
    
    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    if (cachedResponse.data) {
        
        UIImage *downloadedImage = [UIImage imageWithData:cachedResponse.data];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            imageView.image=downloadedImage;
            
            //cell.thumbnailImageView.image = downloadedImage;
            
        });
    } else {
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                UIImage *downloadedImage = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    imageView.image=downloadedImage;
                    //cell.thumbnailImageView.image = downloadedImage;
                });
            }
        }];
        [dataTask resume];
        
        
    }
    
    
}
-(void)signUpAPI
{
    
    /*
     {
     error = "";
     results =     {
     "auth_token" = e581fe1f83d40a6de5761d6ce8bbff0e0a0680c6;
     user = 18;
     userprofile = 7;
     };
     status = success;
     }
     
     */
    NSURL *url = [NSURL URLWithString:@"http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/custom_auth/user/register/"];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: @"TEST IOS", @"name",
                             @"IOS TYPE", @"typemap",
                             nil];
    
    
    
    NSDictionary *dict=@{
                         @"username":@"max9xs",
                         @"email":@"call.max17@gmail.com",
                         @"password":@"123456",
                         @"first_name":@"Hardik",
                         @"invite_code":@"REALPEOPLE",
                         @"profession":[NSNumber numberWithInt:1],
                         @"skills":[NSArray arrayWithObjects:[NSNumber numberWithInt:1],nil],
                         @"interests":[NSArray arrayWithObjects:[NSNumber numberWithInt:1],nil],
                         };
    
    mapData=@{@"register":dict};
    
    
    
    //{"register":{"username":"abc", "email":"abc@test.com", "password":"testpasst3n","first_name":"Hardik", "profession":1,"skills":[1],"interests":[1], "invite_code":"REALPEOPLE"}}
    
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [urlRequest setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *Jerror = nil;
        
        NSDictionary* json =[NSJSONSerialization
                             JSONObjectWithData:data
                             options:kNilOptions
                             error:&Jerror];
        
        if(Jerror!=nil)
        {
            NSLog(@"json error:%@",Jerror);
        }
        else
        {
            NSLog(@"%@",json);
            
        }
        
    }];
    
    [postDataTask resume];
    
}
-(void)loginAPICall
{
    NSURL *url = [NSURL URLWithString:@"http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/custom_auth/api-token-auth/"];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: @"TEST IOS", @"name",
                             @"IOS TYPE", @"typemap",
                             nil];
    
    
    
    NSDictionary *dict=@{
                         @"username":@"call.max17@gmail.com",
                         @"password":@"123456",
                         };
    
    mapData=dict;
    
    
    
    //{"register":{"username":"abc", "email":"abc@test.com", "password":"testpasst3n","first_name":"Hardik", "profession":1,"skills":[1],"interests":[1], "invite_code":"REALPEOPLE"}}
    
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [urlRequest setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *Jerror = nil;
        
        NSDictionary* json =[NSJSONSerialization
                             JSONObjectWithData:data
                             options:kNilOptions
                             error:&Jerror];
        
        if(Jerror!=nil)
        {
            NSLog(@"json error:%@",Jerror);
        }
        else
        {
            NSLog(@"%@",json);
            
        }
        
    }];
    
    [postDataTask resume];
    
    
}
-(void)listOfFriend
{
    
    /*
     {
     error = "";
     results =     {
     "auth_token" = e581fe1f83d40a6de5761d6ce8bbff0e0a0680c6;
     user = 18;
     userprofile = 7;
     };
     status = success;
     }
     
     */
    
    //    curl -X GET http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/7/friends -H 'Authorization: Token e581fe1f83d40a6de5761d6ce8bbff0e0a0680c6' | more
    
    
    NSURL *url = [NSURL URLWithString:@"http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4//user/7/friends"];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: @"TEST IOS", @"name",
                             @"IOS TYPE", @"typemap",
                             nil];
    
    
    
    NSDictionary *dict=@{
                         @"Authorization: Token":@"e581fe1f83d40a6de5761d6ce8bbff0e0a0680c6",
                         };
    
    mapData=dict;
    
    
    //{"register":{"username":"abc", "email":"abc@test.com", "password":"testpasst3n","first_name":"Hardik", "profession":1,"skills":[1],"interests":[1], "invite_code":"REALPEOPLE"}}
    
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [urlRequest setHTTPBody:postData];
    
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *Jerror = nil;
        
        NSDictionary* json =[NSJSONSerialization
                             JSONObjectWithData:data
                             options:kNilOptions
                             error:&Jerror];
        
        if(Jerror!=nil)
        {
            NSLog(@"json error:%@",Jerror);
        }
        else
        {
            NSLog(@"%@",json);
            
        }
        
    }];
    
    [postDataTask resume];
    
    
}
-(void)sample
{
    
    // [self loadSomething];
    
    // [self loginAPICall];
    
    // [self signUpAPI];
    
    //  [self listOfFriend];
    
    
    
}
-(void)cacheTest
{
    /*
     VideoCacheManager *manager=[[VideoCacheManager alloc] init];
     [manager setUp];
     [manager clearCache];
     
     
     //    [manager addVideoURL:@"https://player.vimeo.com/external/121585331.sd.mp4?s=036507492d370ab1671f367cdf0453ae3c529ebf&profile_id=112&oauth2_token_id=57447761"];
     
     
     
     NSMutableArray *videoURLArray=[[NSMutableArray alloc] init];
     
     [videoURLArray addObject:@"https://player.vimeo.com/external/121377179.hd.mp4?s=383ab10c2c3229be7e818ccf30888ba8dbb59b26&profile_id=119&oauth2_token_id=57447761"];
     
     
     [videoURLArray addObject:@"https://player.vimeo.com/external/121585331.sd.mp4?s=036507492d370ab1671f367cdf0453ae3c529ebf&profile_id=112&oauth2_token_id=57447761"];
     [videoURLArray addObject:@"http:clips.vorwaerts-gmbh.de/VfE_html5.mp4"];
     [videoURLArray addObject:@"http:www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4"];
     
     [videoURLArray addObject:@"https://player.vimeo.com/external/191379671.hd.mp4?s=c515d860259b178b7021876b1a4dc43f7aed056d&profile_id=119&oauth2_token_id=57447761"];
     
     
     for(int i=0;i<[videoURLArray count];i++)
     {
     NSString *output=[manager getCachePathIfExists:[videoURLArray objectAtIndex:i]];
     
     NSLog(@"%@",output);
     
     }
     */
    
}
-(void)snapChatViewTest
{
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:
             CGRectMake(0, 0, self.frame.size.width,self.frame
                        .size.width*1.2)];
    
    [self addSubview:imgView];
    imgView.image=[UIImage imageNamed:@"Portfolio2.jpeg"];
    
    
    NSString *testBundlePath =
    [[NSBundle mainBundle] pathForResource:@"Portfolio2" ofType:@"jpeg"];
    
    
    imgView.image=[UIImage imageWithContentsOfFile:testBundlePath];
    imgView.contentMode=UIViewContentModeScaleAspectFill;
    imgView.center=self.center;
    
    UIButton *button=[[UIButton alloc] initWithFrame:imgView.frame];
    [self addSubview:button];
    
    [button addTarget:self action:@selector(SnapChatViewTestcallBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}
-(void)SnapChatViewTestcallBtn:(UIButton *)btn
{
    
    
    
    
    SnapZoomView *view=[[SnapZoomView alloc] initWithFrame:self.bounds];
    [view setUpCellRect:btn.frame];
    [self addSubview:view];
    
}
-(void)PortraitCropTest
{
    
    NSString *documentsDirectory = [Constant applicationDocumentsDirectoryPath];
    
    NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/vid1.mp4"];
    
    
    // NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    
    PortraitCropComponent *compo=[[PortraitCropComponent alloc] initWithFrame:self.bounds];
    [self addSubview:compo];
    [compo setUpWithPath:tempPath];
    
    [compo allowCancel:false];
    
    
    [compo setTarget:self andDoneBtn:@selector(cropFinishedImage:) andCancelBtn:nil];
    
    
}
-(void)cropFinishedImage:(NSString *)path
{
   // int p=0;
}

-(void)shareController
{
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [button setTitle:@"Share" forState:UIControlStateNormal];
    [self addSubview:button];
    [button addTarget:self action:@selector(shareController) forControlEvents:UIControlEventTouchUpInside];
    
    button.backgroundColor=[UIColor grayColor];
    button.center=self.center;
    ShareComponent *compo=[[ShareComponent alloc] initWithFrame:self.frame];
    [compo setUp];
    [self addSubview:compo];
    
}
-(void)vibrancyEffectTest
{
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:
             CGRectMake(0, 0, self.frame.size.width,self.frame
                        .size.width*1.2)];
    [self addSubview:imgView];
    imgView.image=[UIImage imageNamed:@"Portfolio2.jpeg"];
    
    
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];  // or UIBlurEffectStyleDark
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.clipsToBounds = YES;
    
    // vibrancy
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [blurView addSubview:vibrancyView];
    
    blurView.frame=imgView.bounds;
    vibrancyView.frame=imgView.bounds;
    
    
    /*   // label
     UILabel *label = [[UILabel alloc] initWithFrame:blurView.bounds];
     // text color doesn’t matter when it’s vibrant
     label.text=@"Hello how are you";
     label.font=[UIFont systemFontOfSize:20 weight:300];
     label.textAlignment=NSTextAlignmentCenter;
     label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
     */
    UIImageView *img=[[UIImageView alloc] initWithFrame:
                      CGRectMake(10, 10, 100,100)];
    img.image=[UIImage imageNamed:@"TakePicIcon.png"];
    
    // make sure to add the label to the vibrancy effect view now, not the blur view
    [vibrancyView.contentView addSubview:img];
    
    
    [self addSubview:vibrancyView];
    
}


- (NSURLSession *)prepareSessionForRequest
{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //  [sessionConfiguration setHTTPAdditionalHeaders:@{@"Content-Type": @"application/json", @"Accept": @"application/json"}];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    return session;
}

@end
