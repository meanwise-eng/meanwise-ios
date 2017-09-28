//
//  APIObjects_FeedObj.m
//  MeanWiseUX
//
//  Created by Hardik on 22/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "APIObjects_FeedObj.h"

@implementation APIObjects_FeedObj

-(void)setUpWithDict:(NSDictionary *)dict
{
    
   
    self.postId=[dict valueForKey:@"id"];
    
    if(self.postId.class==[NSNull class])
    {
        return;
    }
    int len=(int)[NSString stringWithFormat:@"%@",self.postId].intValue;
    
    self.postId=[NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];


    self.colorNumber=[NSNumber numberWithInt:len%13];
                      
    self.text=[dict valueForKey:@"text"];
    self.user_firstname=[dict valueForKey:@"user_firstname"];
    self.user_lastname=[dict valueForKey:@"user_lastname"];
    self.user_profile_photo_small=[dict valueForKey:@"user_profile_photo_small"];
    self.user_cover_photo=[dict valueForKey:@"user_cover_photo"];
    
    self.video_url=[dict valueForKey:@"video_url"];
    self.video_thumb_url=[dict valueForKey:@"video_thumb_url"];
    self.image_url=[dict valueForKey:@"image_url"];
    self.user_id=[dict valueForKey:@"user_id"];
    
    self.topicLists=[dict valueForKey:@"topics"];
    
   // self.user_profession=[[dict valueForKey:@"user_profession"] valueForKey:@"name"];

    
    if([dict valueForKey:@"user_profession_text"]==nil)
    {
        self.user_profession=@"";
    }
    else
    {
        self.user_profession=[dict valueForKey:@"user_profession_text"];
        
    }
    
    self.mentioned_users=[dict valueForKey:@"mentioned_users"];
    
    
    
    NSString *temp=[dict valueForKey:@"created_on"];
    self.timeString=[self dateTimeSetup:temp];

    
    int interest_id=[[dict valueForKey:@"interest_id"] intValue];

    self.interest_name=[Constant static_getInterstFromId:interest_id];
    
    self.num_comments=[dict valueForKey:@"num_comments"];
    self.num_likes=[dict valueForKey:@"num_likes"];
    
    
    if(![self.video_url isKindOfClass:[NSNull class]] && self.video_url!=nil &&![self.video_url isEqualToString:@""])
    {
        if([self.video_url isEqualToString:@"https://api.meanwise.com/media/post_videos/1856.mp4"])
        {
        self.video_url=@"https://d8d913s460fub.cloudfront.net/krpanocloud/video/airpano/video-1920x960a.mp4";
        self.isPanoromaVideo=@(true);
        }
        
        self.mediaType=[NSNumber numberWithInt:2];
        
        self.image_url=[dict valueForKey:@"video_thumb_url"];
        
        if([self.image_url isKindOfClass:[NSNull class]])
        {
            self.image_url=@"";
        }
        if(self.image_url==nil)
        {
            int p=0;
        }

    }
    else if(![self.image_url isKindOfClass:[NSNull class]] && ![self.image_url isEqualToString:@""])
    {
        self.video_url=@"";
        self.mediaType=[NSNumber numberWithInt:1];
    }
    else
    {
        self.video_url=@"";
        self.mediaType=[NSNumber numberWithInt:0];
    }
    
    int flag=[[dict valueForKey:@"is_liked"] intValue];

    
    if(flag==1)
    {
        self.is_liked=[NSNumber numberWithInt:1];

    }
    else
    {
        self.is_liked=[NSNumber numberWithInt:0];

    }
    
    /*NSArray *likedBy=[dict valueForKey:@"liked_by"];
    
    
    
    if(likedBy!=0)
    {
    int userId=[UserSession getUserId].intValue;
        
        if([likedBy containsObject:[NSNumber numberWithInt:userId]])
        {
            self.IsUserLiked=[NSNumber numberWithInt:1];
        }
        else
        {
            self.IsUserLiked=[NSNumber numberWithInt:0];
        }
        
    }
*/
    
    
    
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
