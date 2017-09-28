//
//  APIObjects_DiscussionObj.m
//  MeanWiseUX
//
//  Created by Hardik on 10/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "APIObjects_DiscussionObj.h"
#import "Constant.h"

@implementation APIObjects_DiscussionObj

-(void)setUpWithDict:(NSDictionary *)dict
{
    
    
//    @property (nonatomic,strong) NSNumber *post_id;
//    @property (nonatomic,strong) NSNumber *comment_id;
//    
//    
//    @property (nonatomic, strong) NSString* userprofile_first_name;
//    @property (nonatomic, strong) NSString* userprofile_last_name;
//    @property (nonatomic, strong) NSString* userprofile_profile_photo_thumbnail_url;
//    
//    @property (nonatomic, strong) NSString* post_text;
//    @property (nonatomic, strong) NSString* post_image_url;

    self.text=[dict valueForKey:@"text"];
    
    NSString *temp=[dict valueForKey:@"datetime"];
    self.datetime=[self dateTimeSetup:temp];

    self.type=[dict valueForKey:@"type"];

    self.post_id=[NSNumber numberWithInt:[[dict valueForKey:@"post_id"] intValue]];
    self.comment_id=[NSNumber numberWithInt:[[dict valueForKey:@"comment_id"] intValue]];
    
    NSDictionary *userprofile=[dict valueForKey:@"userprofile"];
    NSDictionary *post=[dict valueForKey:@"post"];
    
    self.userprofile_user_id=[NSNumber numberWithInt:[[userprofile valueForKey:@"user_id"] intValue]];
    self.userprofile_first_name=[userprofile valueForKey:@"first_name"];
    self.userprofile_last_name=[userprofile valueForKey:@"last_name"];
    self.userprofile_profile_photo_thumbnail_url=[userprofile valueForKey:@"profile_photo_thumbnail_url"];

    self.post_text=[post valueForKey:@"text"];
    self.post_image_url=[post valueForKey:@"image_url"];


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
