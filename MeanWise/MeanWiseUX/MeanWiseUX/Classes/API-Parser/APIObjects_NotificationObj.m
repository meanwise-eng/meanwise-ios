//
//  APIObjects_NotificationObj.m
//  MeanWiseUX
//
//  Created by Hardik on 02/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "APIObjects_NotificationObj.h"

@implementation APIObjects_NotificationObj

-(void)setUpWithDict:(NSDictionary *)dict
{
    /*
     
     
     @property (nonatomic, strong) NSString* postId;
     @property (nonatomic, strong) NSString* postThumbURL;
     @property (nonatomic, strong) NSString* postType;
     
     */
    
    self.notificationIdNo=[NSNumber numberWithInt:[[dict valueForKey:@"id"] intValue]];
    
    self.notificationId=[dict valueForKey:@"id"];
    self.notification_type=[dict valueForKey:@"notification_type"];
    
    self.notificationReceiverUserName=[NSString stringWithFormat:@"%@",[[[dict valueForKey:@"receiver"] valueForKey:@"userprofile"] valueForKey:@"username"] ];

    NSString *temp=[dict valueForKey:@"created_on"];
    self.created_on=[self dateTimeSetup:temp];

    
    if([self.notification_type isEqualToString:@"LikedPost"] || [self.notification_type isEqualToString:@"CommentedPost"])
    {
        self.postId=[[dict valueForKey:@"post"] valueForKey:@"id"];
        
        NSString *VideoThumbURL=[[dict valueForKey:@"post"] valueForKey:@"video_thumb_url"];
        NSString *PhotoThumbURL=[[dict valueForKey:@"post"] valueForKey:@"image_url"];
        
        if(VideoThumbURL!=nil && ![VideoThumbURL isEqualToString:@""])
        {
            self.postThumbURL=VideoThumbURL;
            self.postType=@"3";
        }
        else if(PhotoThumbURL!=nil && ![PhotoThumbURL isEqualToString:@""])
        {
            self.postType=@"2";
            self.postThumbURL=PhotoThumbURL;
        }
        else
        {
            self.postType=@"1";
        }
        
        
    }
    if([self.notification_type isEqualToString:@"LikedPost"] || [self.notification_type isEqualToString:@"CommentedPost"])
    {
        self.postFeedObj=[dict valueForKey:@"post"];
        
    }
    
    
    if([self.notification_type isEqualToString:@"CommentedPost"])
    {
        self.commentId=[[dict valueForKey:@"comment"] valueForKey:@"id"];
        self.commentText=[[dict valueForKey:@"comment"] valueForKey:@"comment_text"];

        self.notifier_userId=[[dict valueForKey:@"comment"] valueForKey:@"user_id"];
        self.notifier_userUserName=[[dict valueForKey:@"comment"] valueForKey:@"user_username"];
        self.notifier_userFirstName=[[dict valueForKey:@"comment"] valueForKey:@"user_first_name"];
        self.notifier_userLastName=[[dict valueForKey:@"comment"] valueForKey:@"user_last_name"];
        self.notifier_userThumbURL=[[dict valueForKey:@"comment"] valueForKey:@"user_profile_photo_small"];
        self.notifier_userCoverURL=[[dict valueForKey:@"comment"] valueForKey:@"cover_photo"];

        
        
        //self.commentText=[dict valueForKey:@"commentText"];

    }
    
    if([self.notification_type isEqualToString:@"LikedPost"])
    {
        
        self.notifier_userId=[[dict valueForKey:@"post_liked_by"] valueForKey:@"id"];
        
        self.notifier_userUserName=[[[dict valueForKey:@"post_liked_by"] valueForKey:@"userprofile"] valueForKey:@"username"];
        
        self.notifier_userFirstName=[[[dict valueForKey:@"post_liked_by"] valueForKey:@"userprofile"] valueForKey:@"first_name"];
        self.notifier_userLastName=[[[dict valueForKey:@"post_liked_by"] valueForKey:@"userprofile"] valueForKey:@"last_name"];

        self.notifier_userThumbURL=[[[dict valueForKey:@"post_liked_by"] valueForKey:@"userprofile"] valueForKey:@"profile_photo_small"];

        self.notifier_userCoverURL=[[[dict valueForKey:@"post_liked_by"] valueForKey:@"userprofile"] valueForKey:@"cover_photo"];

    }


    if([self.notification_type isEqualToString:@"FriendRequestAccepted"] || [self.notification_type isEqualToString:@"FriendRequestReceived"])
    {
        
        NSString *notificationFromUser=@"friend";
        
        if([self.notification_type isEqualToString:@"FriendRequestAccepted"])
        {
            notificationFromUser=@"user";
        }
        else
        {
            notificationFromUser=@"friend";

        }
        
            self.notifier_userId=[[[dict valueForKey:@"user_friend"] valueForKey:notificationFromUser] valueForKey:@"id"];
            
            self.notifier_userUserName=[[[[dict valueForKey:@"user_friend"] valueForKey:notificationFromUser] valueForKey:@"userprofile"] valueForKey:@"username"];
            
            self.notifier_userFirstName=[[[[dict valueForKey:@"user_friend"] valueForKey:notificationFromUser] valueForKey:@"userprofile"] valueForKey:@"first_name"];
            
            self.notifier_userLastName=
            [[[[dict valueForKey:@"user_friend"] valueForKey:notificationFromUser] valueForKey:@"userprofile"] valueForKey:@"last_name"];
            
            self.notifier_userThumbURL=
            [[[[dict valueForKey:@"user_friend"] valueForKey:notificationFromUser] valueForKey:@"userprofile"] valueForKey:@"profile_photo_small"];

        self.notifier_userCoverURL=
        [[[[dict valueForKey:@"user_friend"] valueForKey:notificationFromUser] valueForKey:@"userprofile"] valueForKey:@"cover_photo"];

       
        
        
    }

    
    if([self.notification_type isEqualToString:@"LikedPost"])
    {
      self.msgText=@"liked your post!";
        self.notification_typeNo=[NSNumber numberWithInt:1];
        
        
    }
    if([self.notification_type isEqualToString:@"CommentedPost"])
    {
      self.msgText=[NSString stringWithFormat:@"Commented: %@",self.commentText];
        self.notification_typeNo=[NSNumber numberWithInt:2];
        
    }
    if([self.notification_type isEqualToString:@"FriendRequestAccepted"])
    {
        self.msgText=@"Accepted your friend request!";
        self.notification_typeNo=[NSNumber numberWithInt:3];
        
    }
    if([self.notification_type isEqualToString:@"FriendRequestReceived"])
    {
        self.msgText=@"Added you as a friend!";
        self.notification_typeNo=[NSNumber numberWithInt:4];

    }
    
    int p=0;

    

    
    
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.notificationId forKey:@"notificationId"];
    [encoder encodeObject:self.notification_type forKey:@"notification_type"];
    [encoder encodeObject:self.created_on forKey:@"created_on"];
    [encoder encodeObject:self.notifier_userId forKey:@"notifier_userId"];
    [encoder encodeObject:self.notifier_userFirstName forKey:@"notifier_userFirstName"];
    [encoder encodeObject:self.notifier_userLastName forKey:@"notifier_userLastName"];

    [encoder encodeObject:self.notifier_userUserName forKey:@"notifier_userUserName"];
    [encoder encodeObject:self.notifier_userThumbURL forKey:@"notifier_userThumbURL"];
    [encoder encodeObject:self.notifier_userCoverURL forKey:@"notifier_userCoverURL"];

    [encoder encodeObject:self.commentId forKey:@"commentId"];
    [encoder encodeObject:self.commentText forKey:@"commentText"];

    [encoder encodeObject:self.postId forKey:@"postId"];
    [encoder encodeObject:self.postThumbURL forKey:@"postThumbURL"];
    [encoder encodeObject:self.postType forKey:@"postType"];

    [encoder encodeObject:self.msgText forKey:@"msgText"];

    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        //decode properties, other class vars
        
        self.notificationId = [decoder decodeObjectForKey:@"notificationId"];
        self.notification_type = [decoder decodeObjectForKey:@"notification_type"];
        self.created_on = [decoder decodeObjectForKey:@"created_on"];
        self.notifier_userId = [decoder decodeObjectForKey:@"notifier_userId"];
        self.notifier_userFirstName = [decoder decodeObjectForKey:@"notifier_userFirstName"];
        self.notifier_userLastName = [decoder decodeObjectForKey:@"notifier_userLastName"];

        self.notifier_userUserName = [decoder decodeObjectForKey:@"notifier_userUserName"];
        self.notifier_userThumbURL = [decoder decodeObjectForKey:@"notifier_userThumbURL"];
        self.notifier_userCoverURL = [decoder decodeObjectForKey:@"notifier_userCoverURL"];

        
        self.commentId = [decoder decodeObjectForKey:@"commentId"];
        self.commentText = [decoder decodeObjectForKey:@"commentText"];

        self.postId = [decoder decodeObjectForKey:@"postId"];
        self.postThumbURL = [decoder decodeObjectForKey:@"postThumbURL"];
        self.postType = [decoder decodeObjectForKey:@"postType"];
        self.msgText = [decoder decodeObjectForKey:@"msgText"];

        
    }
    return self;
}
-(NSString *)dateTimeSetup:(NSString *)dateString
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    
    // NSString *stringDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *time=[self relativeDateStringForDate:dateFromString];
    
    return time;
}
- (NSString *)relativeDateStringForDate:(NSDate *)date
{
    NSDictionary *timeScale = @{@"s"  :@1,
                                @"m"  :@60,
                                @"hr"   :@3600,
                                @"d"  :@86400,
                                @"w" :@605800,
                                @"mo":@2629743,
                                @"y" :@31556926};
    NSString *scale;
    
    int timeAgo = 0-(int)[date timeIntervalSinceNow];
    if (timeAgo < 60) {
        scale = @"s";
    } else if (timeAgo < 3600) {
        scale = @"m";
    } else if (timeAgo < 86400) {
        scale = @"hr";
    } else if (timeAgo < 605800) {
        scale = @"d";
    } else if (timeAgo < 2629743) {
        scale = @"w";
    } else if (timeAgo < 31556926) {
        scale = @"mo";
    } else {
        scale = @"y";
    }
    
    timeAgo = timeAgo/[[timeScale objectForKey:scale] integerValue];
    NSString *s = @"";
    if (timeAgo > 1) {
        s = @"";
    }
    
    return [NSString stringWithFormat:@"%d %@%@", timeAgo, scale, s];
}

@end
