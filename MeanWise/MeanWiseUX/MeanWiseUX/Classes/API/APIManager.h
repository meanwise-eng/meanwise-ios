//
//  APIManager.h
//  MeanWiseUX
//
//  Created by Hardik on 09/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIResponseObj.h"
#import "UserSession.h"


@interface APIManager : NSObject
{
    
}
-(NSString *)baseString;




//Profile
//get User's profile
//Search profiles
//Edit profile
//Friendlist ,
//Pending Friendlist
//Accept friendlist
//Send friendslist

//HOME FEED
-(void)sendRequestHomeFeedFor_UserWithdelegate:(id)delegate andSelector:(SEL)selector;
-(void)sendRequestForNotificationsWithdelegate:(id)delegate andSelector:(SEL)selector;
-(void)sendRequestExploreWithInterestsName:(NSString *)string Withdelegate:(id)delegate andSelector:(SEL)selector;


//Edit Profile

-(void)sendRequestForChangePassword:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector;

-(void)sendRequestForEditProfile:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector;
-(void)sendRequestForUpdateCoverPhoto:(NSString *)coverphotoURL delegate:(id)delegate andSelector:(SEL)selector;
-(void)sendRequestForUpdateProfilePhoto:(NSString *)coverphotoURL delegate:(id)delegate andSelector:(SEL)selector;



//Signup API
-(void)sendRequestForSignUp:(NSDictionary *)signupData delegate:(id)delegate andSelector:(SEL)selector;
-(void)sendRequestTocheckIfUserExistWithEmail:(NSString *)email withDelegate:(id)delegate andSelector:(SEL)selector;


//STATIC
-(void)sendRequestForProffesionsWithDelegate:(id)delegate andSelector:(SEL)selector;
-(void)sendRequestForSkillsWithDelegate:(id)delegate andSelector:(SEL)selector;
-(void)sendRequestForInterestWithDelegate:(id)delegate andSelector:(SEL)selector;




//Friends
-(void)sendRequestGettingUsersFriends:(NSString *)userId status:(int)status delegate:(id)delegate andSelector:(SEL)selector;

-(void)sendRequestForUpdateFriendshipStatus:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector;


//LOGIN-SIGNUP

//Login api
-(void)sendRequestForLoginWithData:(NSDictionary *)dict delegate:(id)del andSelector:(SEL)selector;
-(void)sendRequestForUserData:(NSString *)token andUserId:(NSString *)userId delegate:(id)delegate andSelector:(SEL)selector;


//All Users
-(void)sendRequestForAllUserData:(NSString *)token delegate:(id)delegate andSelector:(SEL)selector;

//Search User
-(void)sendRequestForUserSearch:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector;




//POSTS

-(void)sendRequestForAddingNewComment:(NSString *)postId withData:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector;

-(void)sendRequestForNewPostWithMedia:(NSDictionary *)dict WithMediaURL:(NSString *)mediaURL andTypeisVideo:(BOOL)isVideo delegate:(id)delegate andSelector:(SEL)selector;

-(void)sendRequestForDeletePost:(NSString *)postId delegate:(id)delegate andSelector:(SEL)selector;

//Like a Post
-(void)sendRequestForLikeAPostId:(NSString *)postId delegate:(id)delegate andSelector:(SEL)selector andIsLike:(BOOL)flag;




// Delete post, Add New comment, Delete comment
-(void)sendRequestForNewPost:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector;
-(void)sendRequestForComments:(NSString *)postId delegate:(id)delegate andSelector:(SEL)selector;
-(void)sendRequestForChannel:(NSString *)channelName delegate:(id)delegate andSelector:(SEL)selector;



-(void)sendRequestForPostOfUsersId:(NSString *)userId delegate:(id)delegate andSelector:(SEL)selector;











//Login with Facebook


//List of Friend-Request
//List of comments
//Add New Comment
//Delete New comment
//Search Post


/*
 
 
Edit Profile All Together:
 
 curl http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/18/userprofile/ --dump-header - -H "Content-Type: multipart/form-data" -H "Authorization: Token e581fe1f83d40a6de5761d6ce8bbff0e0a0680c6" -X PATCH -F phone="+11234567891" -F dob="1980-10-30" -F cover_photo="@/home/raj/Pictures/mobile/IMG_20140310_195139094.jpg" -F profile_photo="@/home/raj/Pictures/mobile/IMG_20140310_195139094.jpg" -F bio="test bio 11" -F profession=1 -F city="bangalore" -F first_name="newfnameagain" -F last_name="newlnameagain" | more
 
 //phone, dob, cover photo, proffile photo, bio, profession, city, firstname, lastname, 
 
 
 //Phone
 curl http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/18/userprofile/ --dump-header - -H "Content-Type: multipart/form-data" -H "Authorization: Token e581fe1f83d40a6de5761d6ce8bbff0e0a0680c6" -X PATCH -F phone="+11234567891" | more
 
 //dob
 curl http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/18/userprofile/ --dump-header - -H "Content-Type: multipart/form-data" -H "Authorization: Token e581fe1f83d40a6de5761d6ce8bbff0e0a0680c6" -X PATCH -F dob="1980-10-30" | more

//cover photo
 curl http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/18/userprofile/ --dump-header - -H "Content-Type: multipart/form-data" -H "Authorization: Token e581fe1f83d40a6de5761d6ce8bbff0e0a0680c6" -X PATCH -F cover_photo="@/Users/Hardik/Desktop/Research2/9d033fd0788d1a5704f93f20c6df4bfe.jpg" | more
 
 
 
 
 //location - city not returning in result api.
 curl http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/18/userprofile/ --dump-header - -H "Content-Type: multipart/form-data" -H "Authorization: Token e581fe1f83d40a6de5761d6ce8bbff0e0a0680c6" -X PATCH -F city="India" | more
 
 
 
 
*/

/*
 
 - Signup
 
username,email,password,firstname,lastname, proffesion(NR), skills, interests, invite_code, dob,
 - , , , , profile photo, cover photo.
 
 
 curl -X POST http://127.0.0.1:8000/api/v4/custom_auth/user/register/ --dump-header - -H "Content-Type: multipart/form-data"  -X POST -F username="testuser11@test.com" -F email="testuser11@test.com" -F password="testpass123" -F first_name="testfname11" -F last_name="testlname11" -F profession=1 -F skills=[1,2] -F interests=[1,2] -Finvite_code="REALPEOPLE" -F dob="2000-10-10" -F profile_story_title="profile story title 11" -F profile_story_description="profile story description 11" -F cover_photo="@/home/raj/Pictures/6859429-beach-wallpaper.jpg" -F profile_photo="@/home/raj/Pictures/6859429-beach-wallpaper.jpg" | more

 Actual
 //username,email,password,first_name,last_name,dob,cover_photo,profile_photo,skills,interests,

 
curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/custom_auth/user/register/ --dump-header - -H "Content-Type: multipart/form-data"  -X POST -F username="alonehitman" -F email="hardik@test.com" -F password="testpass123" -F first_name="testfname11" -F last_name="testlname11" -F skills=[1,2] -F profession=1 -F interests=[1,2] -Finvite_code="REALPEOPLE" -F dob="2000-10-10" -F cover_photo="@/Users/Hardik/Desktop/Research2/9d033fd0788d1a5704f93f20c6df4bfe.jpg" -F profile_photo="@/Users/Hardik/Github/MeanWiseUX/MeanWiseUX/temp/profile8.jpg" | more
 
 {"error":"","status":"success","results":{"auth_token":"052c5302c725bda9d8a19959dcedf4ca07b30314","user":23,"userprofile":12}}


 /Users/Hardik/Desktop/Research2/9d033fd0788d1a5704f93f20c6df4bfe.jpg
 /Users/Hardik/Github/MeanWiseUX/MeanWiseUX/temp/profile8.jpg
 
 */

@end
