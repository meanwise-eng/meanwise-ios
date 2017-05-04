//
//  APIObjects_CommentObj.m
//  MeanWiseUX
//
//  Created by Hardik on 23/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "APIObjects_CommentObj.h"

@implementation APIObjects_CommentObj

-(void)setUpWithDict:(NSDictionary *)dict
{
    self.commentId=[dict valueForKey:@"id"];
    self.post_id=[dict valueForKey:@"post_id"];
    self.user_first_name=[dict valueForKey:@"user_first_name"];
    self.user_last_name=[dict valueForKey:@"user_last_name"];

    self.user_profile_photo=[dict valueForKey:@"user_profile_photo"];
    self.user_profile_photo_small=[dict valueForKey:@"user_profile_photo_small"];
    self.user_username=[dict valueForKey:@"user_username"];
    self.comment_text=[dict valueForKey:@"comment_text"];
    self.user_id=[dict valueForKey:@"user_id"];

    NSString *temp=[dict valueForKey:@"created_on"];
    self.timeString=[self dateTimeSetup:temp];

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
