//
//  APIObjects_ProfileObj.m
//  MeanWiseUX
//
//  Created by Hardik on 23/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "APIObjects_ProfileObj.h"

@implementation APIObjects_ProfileObj

-(void)setUpWithDict:(NSDictionary *)dict
{

    self.userId=[dict valueForKey:@"user_id"];
    self.idDetail=[dict valueForKey:@"id"];
    self.cover_photo=[dict valueForKey:@"cover_photo"];
    self.bio=[dict valueForKey:@"bio"];
    self.email=[dict valueForKey:@"email"];
    self.first_name=[dict valueForKey:@"first_name"];
    self.last_name=[dict valueForKey:@"last_name"];
    self.profession=[[dict valueForKey:@"user_profession"] valueForKey:@"name"];
    self.profile_photo_small=[dict valueForKey:@"profile_photo_small"];
    self.username=[dict valueForKey:@"username"];
    self.profile_photo=[dict valueForKey:@"profile_photo"];
    self.dob=[dict valueForKey:@"dob"];
    self.phone=[dict valueForKey:@"phone"];
    
    self.profile_story_title=[dict valueForKey:@"profile_story_title"];
    self.profile_story_description=[dict valueForKey:@"profile_story_description"];
    self.city=[dict valueForKey:@"city"];
    
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.idDetail forKey:@"idDetail"];
    [encoder encodeObject:self.cover_photo forKey:@"cover_photo"];
    [encoder encodeObject:self.bio forKey:@"bio"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.first_name forKey:@"first_name"];
    [encoder encodeObject:self.last_name forKey:@"last_name"];

    [encoder encodeObject:self.profession forKey:@"profession"];
    [encoder encodeObject:self.profile_photo_small forKey:@"profile_photo_small"];

    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.profile_photo forKey:@"profile_photo"];
    [encoder encodeObject:self.accessToken forKey:@"accessToken"];
    [encoder encodeObject:self.dob forKey:@"dob"];
    [encoder encodeObject:self.phone forKey:@"phone"];

    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.profile_story_description forKey:@"profile_story_description"];
    [encoder encodeObject:self.profile_story_title forKey:@"profile_story_title"];

}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        //decode properties, other class vars
        
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.idDetail = [decoder decodeObjectForKey:@"idDetail"];
        self.cover_photo = [decoder decodeObjectForKey:@"cover_photo"];
        
        self.bio = [decoder decodeObjectForKey:@"bio"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.first_name = [decoder decodeObjectForKey:@"first_name"];
        
        self.last_name = [decoder decodeObjectForKey:@"last_name"];
        self.profile_photo_small = [decoder decodeObjectForKey:@"profile_photo_small"];
        self.profession = [decoder decodeObjectForKey:@"profession"];
        
        self.profile_photo = [decoder decodeObjectForKey:@"profile_photo"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.accessToken=[decoder decodeObjectForKey:@"accessToken"];
        self.dob = [decoder decodeObjectForKey:@"dob"];
        self.phone = [decoder decodeObjectForKey:@"phone"];

        self.city = [decoder decodeObjectForKey:@"city"];
        self.profile_story_description = [decoder decodeObjectForKey:@"profile_story_description"];
        self.profile_story_title = [decoder decodeObjectForKey:@"profile_story_title"];

        
    }
    return self;
}


@end
