//
//  APIObjects_ProfileObj.m
//  MeanWiseUX
//
//  Created by Hardik on 23/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "APIObjects_ProfileObj.h"
#import "UserSession.h"
@implementation APIObjects_ProfileObj

-(void)setUpWithDict:(NSDictionary *)dict
{

    self.userId=[dict valueForKey:@"user_id"];
    self.idDetail=[dict valueForKey:@"id"];
    self.cover_photo=[dict valueForKey:@"cover_photo"];
    
    if([[dict valueForKey:@"profile_background_color"] isKindOfClass:[NSNull class]])
    {
        self.profile_background_color=@"#888888";
    }
    else
    {
        self.profile_background_color=[dict valueForKey:@"profile_background_color"];
        if([self.profile_background_color isEqualToString:@"#FFFFFF"])
        {
            self.profile_background_color=@"#536DFE";
        }
    }
    
    
    self.user_type=[NSNumber numberWithInt:[[dict valueForKey:@"user_type"] intValue]];
    
    if([[dict valueForKey:@"profession_text"] isKindOfClass:[NSNull class]])
    {
        self.profession_text=@"";
    }
    else
    {
        self.profession_text=[dict valueForKey:@"profession_text"];
    }
    
    int len=(int)[NSString stringWithFormat:@"%@",self.userId].intValue;
    self.colorNumber=[NSNumber numberWithInt:len%13];
    
    self.skill_List=[dict valueForKey:@"skills_list"];
    
    if([[dict valueForKey:@"bio"] isKindOfClass:[NSNull class]])
    {
        self.bio=@"";
    }
    else
    {
        self.bio=[dict valueForKey:@"bio"];

    }
    
    
    
    self.email=[dict valueForKey:@"email"];
    self.first_name=[dict valueForKey:@"first_name"];
    self.last_name=[dict valueForKey:@"last_name"];
    
    if([[dict valueForKey:@"user_profession"] valueForKey:@"name"]==nil)
    {
        self.professionX=@"";
    }
    else
    {
        self.professionX=[[dict valueForKey:@"user_profession"] valueForKey:@"name"];

    }
    
    
    self.profile_photo_small=[dict valueForKey:@"profile_photo_small"];
    self.username=[dict valueForKey:@"username"];
    self.profile_photo=[dict valueForKey:@"profile_photo"];
    
    if([[dict valueForKey:@"phone"] isKindOfClass:[NSNull class]])
    {
        self.phone=@"";
    }
    else
    {
        self.phone=[dict valueForKey:@"phone"];
        
    }
    
    if([[dict valueForKey:@"dob"] isKindOfClass:[NSNull class]])
    {
        self.dob=@"";
    }
    else
    {
        self.dob=[dict valueForKey:@"dob"];
        
    }
    
    
    if([[dict valueForKey:@"profile_story_title"] isKindOfClass:[NSNull class]])
    {
        self.profile_story_title=@"";
    }
    else
    {
        self.profile_story_title=[dict valueForKey:@"profile_story_title"];
        
    }
    
    if([[dict valueForKey:@"profile_story_description"] isKindOfClass:[NSNull class]])
    {
        self.profile_story_description=@"";
    }
    else
    {
        self.profile_story_description=[dict valueForKey:@"profile_story_description"];
        
    }
    
    
    
    if([[dict valueForKey:@"city"] isKindOfClass:[NSNull class]])
    {
        self.city=@"";
    }
    else
    {
        self.city=[dict valueForKey:@"city"];
    }
    
    self.interests=[dict valueForKey:@"interests"];
    self.skillsX=[dict valueForKey:@"skills"];
    
    
    
    

  
    self.friend_count=[NSNumber numberWithInt:[[dict valueForKey:@"friend_count"] intValue]];
    
    if([[dict valueForKey:@"friend_request_status"] isKindOfClass:[NSNull class]])
    {
        self.friend_request_status=@"";
    }
    else
    {
        self.friend_request_status=[dict valueForKey:@"friend_request_status"];
    }
    
    //Accepted,Pending
    
    
    
    /*
     self.friendShipStatus=@"";
     NSString *watchingUserId=[NSString stringWithFormat:@"%@",[dict valueForKey:@"user_id"]];

    self.userFriends=[dict valueForKey:@"user_friends"];

    for (NSDictionary *dictTemp in self.userFriends)
    {
        
        NSString *currentUserId=[NSString stringWithFormat:@"%@",[UserSession getUserId]];
        NSString *senderId=[NSString stringWithFormat:@"%@",[dictTemp valueForKey:@"friend_sender_id"]];
        NSString *receiverId=[NSString stringWithFormat:@"%@",[dictTemp valueForKey:@"friend_receiver_id"]];
        NSString *status=[NSString stringWithFormat:@"%@",[dictTemp valueForKey:@"status"]];

        if([senderId isEqualToString:currentUserId] || [receiverId isEqualToString:currentUserId])
        {
        
        if([status isEqualToString:@"Pending"])
        {
            if([senderId isEqualToString:watchingUserId] && [receiverId isEqualToString:currentUserId])
            {
                self.friendShipStatus=@"Pending";
            }
            if([senderId isEqualToString:currentUserId] && [receiverId isEqualToString:watchingUserId])
            {
                self.friendShipStatus=@"Sent";
            }
        }
        else
        {
            self.friendShipStatus=status;
        }
        }

        
        
    }
     */

    
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

    [encoder encodeObject:self.professionX forKey:@"professionX"];
    [encoder encodeObject:self.profile_photo_small forKey:@"profile_photo_small"];

    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.profile_photo forKey:@"profile_photo"];
    [encoder encodeObject:self.accessToken forKey:@"accessToken"];
    [encoder encodeObject:self.dob forKey:@"dob"];
    [encoder encodeObject:self.phone forKey:@"phone"];

    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.profile_story_description forKey:@"profile_story_description"];
    [encoder encodeObject:self.profile_story_title forKey:@"profile_story_title"];

    [encoder encodeObject:self.interests forKey:@"interests"];
    [encoder encodeObject:self.skillsX forKey:@"skillsX"];

    
    [encoder encodeObject:self.skill_List forKey:@"skill_List"];
    [encoder encodeObject:self.profile_background_color forKey:@"profile_background_color"];
    [encoder encodeObject:self.profession_text forKey:@"profession_text"];
    [encoder encodeObject:self.user_type forKey:@"user_type"];
    [encoder encodeObject:self.friend_count forKey:@"friend_count"];
    [encoder encodeObject:self.friend_request_status forKey:@"friend_request_status"];

    

    
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
        self.professionX = [decoder decodeObjectForKey:@"professionX"];
        
        self.profile_photo = [decoder decodeObjectForKey:@"profile_photo"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.accessToken=[decoder decodeObjectForKey:@"accessToken"];
        self.dob = [decoder decodeObjectForKey:@"dob"];
        self.phone = [decoder decodeObjectForKey:@"phone"];

        self.city = [decoder decodeObjectForKey:@"city"];
        self.profile_story_description = [decoder decodeObjectForKey:@"profile_story_description"];
        self.profile_story_title = [decoder decodeObjectForKey:@"profile_story_title"];

        self.interests = [decoder decodeObjectForKey:@"interests"];
        self.skillsX = [decoder decodeObjectForKey:@"skillsX"];

        self.skill_List = [decoder decodeObjectForKey:@"skill_List"];
        self.profile_background_color = [decoder decodeObjectForKey:@"profile_background_color"];
        self.profession_text = [decoder decodeObjectForKey:@"profession_text"];
        self.user_type = [decoder decodeObjectForKey:@"user_type"];
        self.friend_count = [decoder decodeObjectForKey:@"friend_count"];
        self.friend_request_status = [decoder decodeObjectForKey:@"friend_request_status"];


        
    }
    return self;
}


@end
