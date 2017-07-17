//
//  APITesterView.m
//  MeanWiseUX
//
//  Created by Hardik on 09/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "APITesterView.h"
#import "APIObjectsParser.h"


@implementation APITesterView

-(void)setUp
{
    
    [self sendForgetPassword];
    
  //  [self trendingTopicsForChannel];
    
   // [self ExploreSearchViaInterestsAPI];
    
    //[self UserNotificationAPI];
    
    //[self homeFeedAPI];
    
//    [self updateCoverPhoto];
 
   // [self ListOfCommentsForThePost];
   // [self addingNewComment];
//    [self deletePost];
   // [self addNewPost];
  //[self getUsersPost];
    
  //  [self getUsersFriends];

    //[self getUsersPost];
    
   // [self getUsersFriends];//
    
   // [self getLikeAPost];
}
-(void)sendForgetPassword
{
   // manager=[[APIManager alloc] init];
  //  [manager sendRequestForForgetPasswordWithDelegate:self andSelector:@selector(forgetPasswordCallBack:)];
    
}
-(void)forgetPasswordCallBack:(APIResponseObj *)responseObj
{
    
}
-(void)autoCompleteAPIForTag
{
    manager=[[APIManager alloc] init];
   
    
    NSDictionary *dict=@{@"topic":@"to"};
 //   NSDictionary *dict=@{@"tag":@"t"};
    
    
    [manager sendRequestExploreAutoCompleteAPI:dict Withdelegate:self andSelector:@selector(autoCompleteAPIForTagReceived:)];
    
    
}
-(void)trendingTopicsForChannel
{
    manager=[[APIManager alloc] init];
    [manager sendRequestExploreTopTrendingTopicsForChannel:@"2" Withdelegate:self andSelector:@selector(autoCompleteAPIForTagReceived:)];
    

}
-(void)autoCompleteAPIForTagReceived:(APIResponseObj *)responseObj
{
    NSLog(@"%@",responseObj.response);

}

-(void)ExploreSearchViaInterestsAPI
{
    manager=[[APIManager alloc] init];
    [manager sendRequestExploreFeedWithKey:nil Withdelegate:self andSelector:@selector(homeFeedAPIReceived)];
    
    //[manager sendRequestExploreWithInterestsName:@"Sports" Withdelegate:self andSelector:@selector(homeFeedAPIReceived:)];
//    [manager sendRequestExploreWithInterestsName:self andSelector:@selector(homeFeedAPIReceived:)];
}
-(void)UserNotificationAPI
{
    manager=[[APIManager alloc] init];
    [manager sendRequestForMyNotificationsWithdelegate:self andSelector:@selector(UserNotificationAPIReceived:)];

}
-(void)UserNotificationAPIReceived:(APIResponseObj *)responseObj
{
    NSLog(@"%@",responseObj.response);
    
    
    if([responseObj.response isKindOfClass:[NSArray class]])
    {
        NSArray *array=(NSArray *)responseObj.response;
        APIObjectsParser *parser=[[APIObjectsParser alloc] init];
        NSArray *result=[parser parseObjects_NOTIFICATIONS:array];
        
//        NotificationScreen *screen=[[NotificationScreen alloc] initWithFrame:self.frame];
//        [self addSubview:screen];
//        [screen setUp:result];
//        
        int p=0;
        
    }
    

    

    

}

-(void)homeFeedAPI
{
    manager=[[APIManager alloc] init];
    [manager sendRequestHomeFeedFor_UserWithdelegate:self andSelector:@selector(homeFeedAPIReceived:)];
    
}
-(void)UserExistsAPI
{
    manager=[[APIManager alloc] init];
    [manager sendRequestTocheckIfUserExistWithEmail:@"call.max17@gmail.com" withDelegate:self andSelector:@selector(UserExistsAPIReceived:)];
    
}
-(void)UserExistsAPIReceived:(APIResponseObj *)responseObj;
{
    NSLog(@"%@",[responseObj.response valueForKey:@"exists"]);
    
    NSString *string=[responseObj.response valueForKey:@"exists"];
    if([[string lowercaseString] isEqualToString:@"true"])
    {
        NSLog(@"User Already Exists");
    }
    else
    {
        NSLog(@"User does not exists");
    }
    
}
-(void)homeFeedAPIReceived:(APIResponseObj *)responseObj
{
    
}
-(void)signupAPI
{
   /*
    raj@raj-ThinkPad-X1-Carbon:/work/meanwise/meanwise-server$ curl -X POST http://127.0.0.1:8000/api/v4/custom_auth/user/register/ --dump-header - -H "Content-Type: multipart/form-data"  -X POST -F username="testuser11@test.com" -F email="testuser11@test.com" -F password="testpass123" -F first_name="testfname11" -F last_name="testlname11" -F profession=1 -F skills=[1,2] -F interests=[1,2] -Finvite_code="REALPEOPLE" -F dob="2000-10-10" -F profile_story_title="profile story title 11" -F profile_story_description="profile story description 11" -F cover_photo="@/home/raj/Pictures/6859429-beach-wallpaper.jpg" -F profile_photo="@/home/raj/Pictures/6859429-beach-wallpaper.jpg" | more
    
    
   --dump-header - -H "Content-Type: multipart/form-data" 
    -X POST 
    
    -F username="testuser11@test.com" 
    -F email="testuser11@test.com" 
    -F password="testpass123" 
    -F first_name="testfname11" 
    -F last_name="testlname11" 
    -F dob="2000-10-10"
    -F interests=[1,2]
    -F skills=[1,2]
    -F cover_photo="@/home/raj/Pictures/6859429-beach-wallpaper.jpg"
    -F profile_photo="@/home/raj/Pictures/6859429-beach-wallpaper.jpg"
    -F invite_code="REALPEOPLE"

    
    -F profession=1 
    -F profile_story_title="profile story title 11"
    -F profile_story_description="profile story description 11" 
    
    
*/
    NSString *profile = [[NSBundle mainBundle] pathForResource:@"profile3" ofType:@"jpg"];
    NSString *cover = [[NSBundle mainBundle] pathForResource:@"CoverPhoto" ofType:@"jpg"];

    
    NSDictionary *dict1=@{
                          @"username":@"alonehitman1",
                          @"email":@"hardik1@gmail.com",
                          @"password":@"pass123456",
                          @"first_name":@"Max123",
                          @"last_name":@"Yobhau",
                          @"dob":@"2000-10-10",
                          @"interest":@"[1,2]",
                          @"skills":@"[1,2]",
                          @"profile_photo":profile,
                          @"cover_photo":cover,
                          @"invite_code":@"REALPEOPLE",
                          @"profession":@"1"
                          
                          };

    
    manager=[[APIManager alloc] init];
    [manager sendRequestForSignUp:dict1 delegate:self andSelector:@selector(signupAPIReceived:)];

}
-(void)signupAPIReceived:(APIResponseObj *)responseObj
{
    NSLog(@"%@",responseObj.message);
    NSLog(@"%ld",responseObj.statusCode);
    NSLog(@"%@",responseObj.response);


}
-(void)updateCoverPhoto
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"profile3" ofType:@"jpg"];

 
    manager=[[APIManager alloc] init];
    [manager sendRequestForUpdateCoverPhoto:path delegate:self andSelector:@selector(editProfileReceived:)];
    
}
-(void)getEditProfile
{
    NSDictionary *dict1=@{
                          @"first_name":@"Max123",
                          @"last_name":@"Yobhau",
                          @"dob":@"1982-10-12",
                          @"phone":@"+919537707770",
                          @"bio":@"Food ninja. Unapologetic tv fan. Music maven.Thinker.",
                          };
    
    manager=[[APIManager alloc] init];
    [manager sendRequestForEditProfile:dict1 delegate:self andSelector:@selector(editProfileReceived:)];
}


-(void)editProfileReceived:(APIResponseObj *)responseObj
{
    NSLog(@"%@",responseObj.response);
}
-(void)getLikeAPost
{
    manager=[[APIManager alloc] init];
    
    [manager sendRequestForLikeAPostId:@"2" delegate:self andSelector:@selector(likeActionFinished:) andIsLike:YES];

    

}
-(void)likeActionFinished:(APIResponseObj *)responseObj
{
}

-(void)getUsersFriends
{
    manager=[[APIManager alloc] init];
    [manager sendRequestGettingUsersFriends:[UserSession getUserId] status:1 delegate:self andSelector:@selector(userFriendsReceived:)];
    
}
-(void)usersFriendReceived:(APIResponseObj *)responseObj
{
    NSLog(@"%@",responseObj.response);
 
    if([responseObj.response isKindOfClass:[NSArray class]])
    {
        NSArray *array=(NSArray *)responseObj.response;
        APIObjectsParser *parser=[[APIObjectsParser alloc] init];
       NSArray *result=[parser parseObjects_PROFILES:array];
     
        int p=0;
        
    }
}


#pragma mark - Coment Add

-(void)addingNewComment
{
    
    //curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/posts/2/comments/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token 638b5d5a3b8d83b28fdd580d25c717cf574a4710" -X POST --data '{"comment_text":"test comment one", "commented_by":10}'
    
    NSDictionary *dict1=@{
                          @"comment_text":@"Comment by max9xs",
                          @"commented_by":[NSNumber numberWithInt:18],
                          };

    manager=[[APIManager alloc] init];
    [manager sendRequestForAddingNewComment:@"2" withData:dict1 delegate:self andSelector:@selector(addingNewComment:)];
    
}
-(void)addingNewComment:(APIResponseObj *)responseObj
{
    
}
-(void)ListOfCommentsForThePost
{
    manager=[[APIManager alloc] init];
    [manager sendRequestForComments:@"2" delegate:self andSelector:@selector(ListOfCommentsForThePostResponse:)];


}
-(void)ListOfCommentsForThePostResponse:(APIResponseObj *)responseObj
{
    NSLog(@"%@",responseObj.response);

    if([responseObj.response isKindOfClass:[NSArray class]])
    {
        NSArray *array=(NSArray *)responseObj.response;
        APIObjectsParser *parser=[[APIObjectsParser alloc] init];
        NSArray *result=[parser parseObjects_COMMENTS:array];
        
        int p=0;
        
    }
    
}


#pragma mark - New Posts/Delete Post

-(void)addNewPost
{
    manager=[[APIManager alloc] init];

 /*
    NSDictionary *dict1=@{
                          @"text":@"Anyone who stops learning is old, whether at twenty or eighty. Anyone who keeps learning stays young. The greatest thing in life is to keep your mind young.",
                          @"interest":@"1",
                          };
    
    [manager sendRequestForNewPost:dict1 withUserId:@"18" delegate:self andSelector:@selector(addNewPostResponse:)];
    */
    
    
    
    NSDictionary *dict1=@{
                          @"text":@"Sports, Sea",
                          @"interest":@"1",
                          };
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mag_app_reducedvid" ofType:@"mp4"];
    
    
    
    [manager sendRequestForNewPostWithMedia:dict1 WithMediaURL:path andTypeisVideo:YES delegate:self andSelector:@selector(addNewPostResponse:)];

    
}
-(void)addNewPostResponse:(APIResponseObj *)responseObj
{
    
}

-(void)deletePost
{
    manager=[[APIManager alloc] init];
    
    [manager sendRequestForDeletePost:@"3" delegate:self andSelector:@selector(deletePostId:)];
    
    
}
-(void)deletePostId:(APIResponseObj *)responseObj
{
    
}

#pragma mark - User's Feed Post
-(void)getPostByInterestName
{
    
    manager=[[APIManager alloc] init];
    [manager sendRequestForChannel:@"sports" delegate:self andSelector:@selector(getPostByInterestName:)];

}
-(void)getPostByInterestName:(APIResponseObj *)responseObj
{
    NSLog(@"%@",responseObj.response);
   
}
-(void)getUsersPost
{

    manager=[[APIManager alloc] init];
    [manager sendRequestForPostOfUsersId:@"18" delegate:self andSelector:@selector(UsersPostReceived:)];

}
-(void)UsersPostReceived:(APIResponseObj *)responseObj
{
   // NSLog(@"%@",responseObj.response);
    
    if([responseObj.response isKindOfClass:[NSArray class]])
    {
        NSArray *array=(NSArray *)responseObj.response;
        APIObjectsParser *parser=[[APIObjectsParser alloc] init];
        NSArray *result=[parser parseObjects_FEEDPOST:array];
        
        int p=0;
        
    }
}

#pragma mark - Static
-(void)ProffesionCall
{
    manager=[[APIManager alloc] init];
    [manager sendRequestForProffesionsWithDelegate:self andSelector:@selector(proffesionDataReceived:)];

}
-(void)proffesionDataReceived:(APIResponseObj *)responseObj
{
    NSLog(@"--------- Professtions");
    NSLog(@"%@",responseObj.response);
}
-(void)SkillCall
{
    manager=[[APIManager alloc] init];
    [manager sendRequestForSkillsWithDelegate:self andSelector:@selector(SkillDataReceived:)];
    
}
-(void)SkillDataReceived:(APIResponseObj *)responseObj
{
        NSLog(@"--------- Skills");
    NSLog(@"%@",responseObj.response);
}
-(void)InterestCall
{
    manager=[[APIManager alloc] init];
    [manager sendRequestForInterestWithDelegate:self andSelector:@selector(InterestDataReceived:)];
    
}
-(void)InterestDataReceived:(APIResponseObj *)responseObj
{
    NSLog(@"--------- Interest");

    NSLog(@"%@",responseObj.response);
}


#pragma mark - Login Request

-(void)loginRequestSend
{
    NSDictionary *dict1=@{
                          @"username":@"max9xs",
                          @"password":@"pass123456",
                          };
    
    manager=[[APIManager alloc] init];
    [manager sendRequestForLoginWithData:dict1 delegate:self andSelector:@selector(loginResponse:)];

}

-(void)loginResponse:(APIResponseObj *)responseObj
{
    
        if(responseObj.statusCode!=200)
        {
            [Constant okAlert:[NSString stringWithFormat:@"%ld",responseObj.statusCode] withSubTitle:responseObj.message onView:self andStatus:-1];
        }
        else
        {
            NSLog(@"%@",responseObj.response);
        }
    responseObj=nil;
    manager=nil;
    
}


@end
