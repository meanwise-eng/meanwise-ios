//
//  APIManager.m
//  MeanWiseUX
//
//  Created by Hardik on 09/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "APIManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIKit.h>

@implementation APIManager

-(NSString *)baseString
{
    return @"https://api.meanwise.com/api/v4/";
   //return @"http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/";
}

#pragma mark - Register For Push Notifications

-(void)registerDeviceForPushNotification:(NSString *)device delegate:(id)delegate andSelector:(SEL)selector
{
    //curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/18/posts/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token 2b40b3899d179376ccf6f86277d576b94c175e90" -X POST --data '{"text":"text post dec22", "interest":1}' | more
    
    NSString *userId=[UserSession getUserId];
    
    NSString *path=[NSString stringWithFormat:@"amazon/notification/device/register/"];
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *token=[UserSession getAccessToken];
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];

    NSUUID *identifierForVendor = [[UIDevice currentDevice] identifierForVendor];
    NSString* uuid = [identifierForVendor UUIDString];
    
    NSError *error;
    NSDictionary *dict;
    
    dict=@{
            @"device_id":uuid,
            @"user_id":userId,
            @"device_token":device
            };
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
            }
            else
            {
                if([jsonDict valueForKey:@"results"]!=nil)
                {
                    
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                    
                    
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[[jsonDict valueForKey:@"non_field_errors"] objectAtIndex:0];
                    
                }
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;

        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
}



#pragma mark - Friendship Mechanism
-(void)sendRequestGettingUsersFriends:(NSString *)userId status:(int)statusValue delegate:(id)delegate andSelector:(SEL)selector
{
    

    
    NSString *path=[NSString stringWithFormat:@"user/%@/friends/",userId];
    
    if(statusValue==-1)
    {
        path=[NSString stringWithFormat:@"%@?status=pending",path];
    }
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSString *token=[UserSession getAccessToken];
    
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    //    NSError *error;
    //  NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //[urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                    
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"detail"];
                    
                }
                
                
                
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
}

-(void)sendRequestForUpdateFriendshipStatus:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector
{
    /*
     curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/18/friends/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token e581fe1f83d40a6de5761d6ce8bbff0e0a0680c6" -X POST --data '{"friend_id":12, "status":"pending"}' | more
     {"status":"success","error":"","results":"Request already pending"}
     
     Reject Request
     curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/18/friends/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token e581fe1f83d40a6de5761d6ce8bbff0e0a0680c6" -X POST --data '{"friend_id":12, "status":"rejected"}' | more
     {"status":"success","error":"","results":"Successfully rejected."}
     
     Accept Request
     curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/18/friends/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token e581fe1f83d40a6de5761d6ce8bbff0e0a0680c6" -X POST --data '{"friend_id":2, "status":"accepted"}' | more
     {"status":"success","error":"","results":"Successfully accepted."}
     */
     
    
    NSString *statusStr=[dict valueForKey:@"status"];
    NSString *friendTo=[UserSession getUserId];
    
    if([statusStr.lowercaseString isEqualToString:@"pending"])
    {
        friendTo=[dict valueForKey:@"friend_id"];
        NSString *userId=[UserSession getUserId];
        dict=@{@"friend_id":userId,@"status":[dict valueForKey:@"status"]};
    }
    
    NSString *path=[NSString stringWithFormat:@"user/%@/friends/",friendTo];
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *token=[UserSession getAccessToken];
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
               // NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([jsonDict valueForKey:@"results"]!=nil)
                {
                   // NSLog(@"Success");
                    
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                    
                    
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[[jsonDict valueForKey:@"non_field_errors"] objectAtIndex:0];
                    
                    
                    
                }
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];

}


#pragma mark - Post Update

-(void)sendRequestForLikeAPostId:(NSString *)postId delegate:(id)delegate andSelector:(SEL)selector andIsLike:(BOOL)flag
{
    
    NSString *userId=[UserSession getUserId];
    NSString *token=[UserSession getAccessToken];
    
    //userid, post id, like/inlike
    
    NSString *likeStr=@"like";
    if(flag==false) likeStr=@"unlike";
    
    NSString *path=[NSString stringWithFormat:@"user/%@/posts/%@/%@/",userId,postId,likeStr];
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    //    NSError *error;
    //  NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //[urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
                //NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                    
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"detail"];
                    
                }
                
                
                
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
}
-(void)sendRequestForAddingNewComment:(NSString *)postId withData:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector
{
    
   // curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/posts/2/comments/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token 638b5d5a3b8d83b28fdd580d25c717cf574a4710" -X POST --data '{"comment_text":"test comment one", "commented_by":10}'
    
 //   curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/posts/1/comments/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token e581fe1f83d40a6de5761d6ce8bbff0e0a0680c6" -X POST --data '{"comment_text":"test comment one", "commented_by":18}' | more
    
    NSString *path=[NSString stringWithFormat:@"posts/%@/comments/",postId];
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];

    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *token=[UserSession getAccessToken];
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
        NSError *error;
      NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            
            
         
            
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
              //  NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    NSDictionary *dataDict = [jsonDict valueForKey:@"results"];
                    obj.response=[dataDict valueForKey:@"data"];
                    
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"detail"];
                    
                }
                
                
                
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
}

-(void)sendRequestForDeletePost:(NSString *)postId delegate:(id)delegate andSelector:(SEL)selector
{
    
    // curl -X  DELETE http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/17/posts/134/ -H 'Authorization: Token 2b40b3899d179376ccf6f86277d576b94c175e90' | more
    
    NSString *userId=[UserSession getUserId];
    
    NSString *path=[NSString stringWithFormat:@"user/%@/posts/%@/",userId,postId];
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"DELETE"];
    
    NSString *token=[UserSession getAccessToken];
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    //    NSError *error;
    //  NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //[urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
              //  NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                    
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"detail"];
                    
                }
                
                
                
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:[NSArray arrayWithObjects:obj,postId, nil] afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
}


-(void)sendRequestForNewPostWithMedia:(NSDictionary *)dict WithMediaData:(NSData *)media andTypeisVideo:(BOOL)isVideo delegate:(id)delegate andSelector:(SEL)selector
{
    
    
    
   /* NSDictionary *dict1=@{
                          @"text":text,
                          @"interest":interest,
                          @"topic_names":topic_names,
                          @"tags":tags
                          };*/
    
    // curl -X POST http://127.0.0.1:8000/api/v4/user/17/posts/ --dump-header - -H "Content-Type: multipart/form-data" -H "Authorization: Token 2b40b3899d179376ccf6f86277d576b94c175e90" -X POST -F interest=1 -F image="@/home/raj/Pictures/mobile/IMG_20140310_195139094.jpg" | more

    
    NSString *userId=[UserSession getUserId];
    
    NSString *path=[NSString stringWithFormat:@"user/%@/posts/",userId];
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:240.0f];
 //   [urlRequest addValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    
    
    NSString *token=[UserSession getAccessToken];
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    
    //Creating Body
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [urlRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    
    // file
    float low_bound = 0;
    float high_bound =5000;
    float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);//image1
    int intRndValue = (int)(rndValue + 0.5);
    NSString *str_image1 = [@(intRndValue) stringValue];
    
    //UIImage *chosenImage1=[UIImage imageWithContentsOfFile:mediaURL];
   // NSData *mediaData = UIImageJPEGRepresentation(chosenImage1, 90);
    
    NSString *postType=@"image";
    NSString *extension=@"jpg";
    
    if(isVideo==true)
    {
        postType=@"video";
        extension=@"mp4";
    }
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.%@\"\r\n",postType,str_image1,extension] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:media]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    
    NSString *interest=[dict valueForKey:@"interest"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"interest\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:interest] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString *text=[dict valueForKey:@"text"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"text\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:text] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    if([dict valueForKey:@"topic_names"]){
       NSString *topic_names=[dict valueForKey:@"topic_names"];
       [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"topic_names\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithString:topic_names] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if([dict valueForKey:@"tags"]){
        NSString *tags=[dict valueForKey:@"tags"];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tags\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:tags] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }

    
    [urlRequest setHTTPBody:body];

    
    
   // NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];

    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
              //  NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"failed"])
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"image"];

                }
                else if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                  //  NSLog(@"Success");
                    
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                    
                    
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[[jsonDict valueForKey:@"non_field_errors"] objectAtIndex:0];
                    
                    
                    
                }
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
          //  NSLog(@"Error %ld",error.code);
          //  NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
    

    
}
-(void)sendRequestForNewPost:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector
{
    //curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/18/posts/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token 2b40b3899d179376ccf6f86277d576b94c175e90" -X POST --data '{"text":"text post dec22", "interest":1}' | more

    NSString *userId=[UserSession getUserId];
    
    NSString *path=[NSString stringWithFormat:@"user/%@/posts/",userId];
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *token=[UserSession getAccessToken];
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    
    //NSLog(@"TOKEN IS %@ AND USER ID IS %@", token, userId);
    
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
   //  NSLog(@"DATA FOR NEW POST IS  %@", postData);
    
    [urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
               // NSLog(@"json error:%@ and response is %@",Jerror, jsonDict);
            }
            else
            {
                if([jsonDict valueForKey:@"results"]!=nil)
                {
                   // NSLog(@"Success: %@", jsonDict);
                    
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                    
                    
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[[jsonDict valueForKey:@"non_field_errors"] objectAtIndex:0];
                    
                   // NSLog(@"Error 500: %@", jsonDict);
                    
                }
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];

}

-(void)sendRequestForDeleteComment:(NSString *)commentId postId:(NSString *)postId delegate:(id)delegate andSelector:(SEL)selector;
{
    //curl -X  DELETE http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/posts/2/comments/3/ -H 'Authorization: Token 638b5d5a3b8d83b28fdd580d25c717cf574a4710' | more
    
    
    NSString *path=[NSString stringWithFormat:@"posts/%@/comments/%@/",postId,commentId];

    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"DELETE"];
    
    NSString *token=[UserSession getAccessToken];
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    //    NSError *error;
    //  NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //[urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
               // NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                    
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"detail"];
                    
                }
                
                
                
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:[NSArray arrayWithObjects:obj,commentId, nil] afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
}
-(void)sendRequestForComments:(NSString *)postId delegate:(id)delegate andSelector:(SEL)selector;
{
    
    NSString *path=[NSString stringWithFormat:@"posts/%@/comments/",postId];
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSString *token=[UserSession getAccessToken];
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    //    NSError *error;
    //  NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //[urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
               // NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    NSDictionary *dataDict = [jsonDict valueForKey:@"results"];
                    obj.response=[dataDict valueForKey:@"data"];
                    
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"detail"];
                    
                }
                
                
                
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
}

#pragma mark - Post Search

-(void)sendRequestForChannel:(NSString *)channelName delegate:(id)delegate andSelector:(SEL)selector
{
 
    NSString *path=[NSString stringWithFormat:@"search/post/?interest_name='%@'",channelName];
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
  //  NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",@"e581fe1f83d40a6de5761d6ce8bbff0e0a0680c6"];
   // [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];

    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    //    NSError *error;
    //  NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //[urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
                //NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([jsonDict valueForKey:@"results"])
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                    
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"detail"];
                    
                }
                
                
                
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];

}

-(void)sendRequestForPostOfUsersId:(NSString *)userId delegate:(id)delegate andSelector:(SEL)selector
{
    
    NSString *path=[NSString stringWithFormat:@"user/%@/posts/",userId];
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSString *token=[UserSession getAccessToken];
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];

    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
   
//    NSError *error;
  //  NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //[urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
                //NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    NSDictionary *dataDict = [jsonDict valueForKey:@"results"];
                    obj.response=[dataDict valueForKey:@"data"];

                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"detail"];

                }
                
                
                
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
}
#pragma mark - Notifications
-(void)sendRequestForNotificationsWithdelegate:(id)delegate andSelector:(SEL)selector
{
    // curl -X GET  http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/17/home/feed/ -H 'Authorization: Token ad44b3c55e73cdca2b84e2c7d4c0d2f2d7e7532d' | more
    
//    curl -X GET  http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/17/notifications/latest/ -H 'Authorization: Token e581fe1f83d40a6de5761d6ce8bbff0e0a0680c6' | more
    
    
    NSString *userId=[UserSession getUserId];
    NSString *path=[NSString stringWithFormat:@"user/%@/notifications/latest/",userId];
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSString *token=[UserSession getAccessToken];
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    
    
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    //    NSError *error;
    //  NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //[urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
             //   NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                    
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"detail"];
                    
                }
                
                
                
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
    
}
#pragma mark - FEED APIs

-(int)getTotalPosts
{
    NSString *userId=[UserSession getUserId];
    NSString *path=[NSString stringWithFormat:@"user/%@/home/feed/?page_size=1&page=1",userId];
    
    __block int totalPosts;
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSString *token=[UserSession getAccessToken];
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            
          //  NSLog(@"CONTENT FOR HOME : %@", jsonDict);
            
            
            if(Jerror!=nil)
            {

             //   NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                    NSDictionary *dataDict = [jsonDict valueForKey:@"results"];
                    totalPosts = (int)[dataDict valueForKey:@"num_pages"];
                    
                }
                else
                {
                  //  NSLog(@"Error 500: %@",[jsonDict valueForKey:@"detail"]);
                }
    
            }
        }
        else
        {
           // NSLog(@"Error %ld: %@",(long)error.code, error.localizedDescription);

        }
        
    }];
    
    [postDataTask resume];
    
    
    return totalPosts;
 
}

-(void)sendRequestHomeFeedFor_UserWithdelegate:(id)delegate withPage:(int)page andSelector:(SEL)selector
{
    
    // curl -X GET  http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/17/home/feed/ -H 'Authorization: Token ad44b3c55e73cdca2b84e2c7d4c0d2f2d7e7532d' | more
    
    NSString *userId=[UserSession getUserId];
    NSString *path=[NSString stringWithFormat:@"user/%@/home/feed/?page_size=5&page=%d",userId,page];
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSString *token=[UserSession getAccessToken];
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    
    
    
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    //    NSError *error;
    //  NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //[urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            
            //NSLog(@"CONTENT FOR HOME : %@", jsonDict);
            
            
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
                //NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                    NSDictionary *dataDict = [jsonDict valueForKey:@"results"];
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[dataDict valueForKey:@"data"];
                    
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"detail"];
                    
                }
                
                
                
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
}


-(void)sendRequestHomeFeedFor_UserWithdelegate:(id)delegate andSelector:(SEL)selector
{
    
  // curl -X GET  http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/17/home/feed/ -H 'Authorization: Token ad44b3c55e73cdca2b84e2c7d4c0d2f2d7e7532d' | more
    
    NSString *userId=[UserSession getUserId];
    NSString *path=[NSString stringWithFormat:@"user/%@/home/feed/?page_size=500&page=1",userId];
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSString *token=[UserSession getAccessToken];
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    
    //NSLog(@"TOKEN IS %@", token);
    
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    //    NSError *error;
    //  NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //[urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            
           // NSLog(@"CONTENT FOR HOME : %@", jsonDict);
            
            
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
             //   NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                    NSDictionary *dataDict = [jsonDict valueForKey:@"results"];
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[dataDict valueForKey:@"data"];
                    
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"detail"];
                    
                }
                
                
                
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
}


-(void)sendRequestExploreTopTrendingTopicsForChannel:(NSString *)channelId Withdelegate:(id)delegate andSelector:(SEL)selector
{
    
    //curl GET http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/interests/2/topics/trending/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token ad44b3c55e73cdca2b84e2c7d4c0d2f2d7e7532d" | more
    
    
    NSString *path=[NSString stringWithFormat:@"interests/%@/topics/trending/",channelId];
    
    
    
    
    
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSString *token=[UserSession getAccessToken];
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    // NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //[urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
               // NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([jsonDict valueForKey:@"results"]!=nil && [[jsonDict valueForKey:@"results"] isKindOfClass:[NSArray class]])
                {
                 //   NSLog(@"Success");
                    
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                    
                    
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"error"];
                    
                    
                    
                }
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
    
}

-(void)sendRequestExploreAutoCompleteAPI:(NSDictionary *)dict Withdelegate:(id)delegate andSelector:(SEL)selector
{
    
    // curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/posts/topics/autocomplete/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token ad44b3c55e73cdca2b84e2c7d4c0d2f2d7e7532d" -X POST --data '{"tag":"ta"}' | more
    
    // curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/posts/tags/autocomplete/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token ad44b3c55e73cdca2b84e2c7d4c0d2f2d7e7532d" -X POST --data '{"tag":"ta"}' | more
    
    
    NSString *path=@"posts/topics/autocomplete/";
    
    if([dict valueForKey:@"tag"]!=nil)
    {
        path=@"posts/tags/autocomplete/";
    }
    
    
    
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *token=[UserSession getAccessToken];
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
               // NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([jsonDict valueForKey:@"results"]!=nil && [[jsonDict valueForKey:@"results"] isKindOfClass:[NSArray class]])
                {
                //    NSLog(@"Success");
                    
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                    
                    
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"error"];
                    
                    
                    
                }
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
}

-(void)sendRequestExploreFeedWithKey:(NSDictionary *)dict Withdelegate:(id)delegate andSelector:(SEL)selector
{
//    http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/search/post/?interest_name=%22sports%22
    
    // curl -X GET  http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/17/home/feed/ -H 'Authorization: Token ad44b3c55e73cdca2b84e2c7d4c0d2f2d7e7532d' | more
    
    
    int typeOfSearch=[[dict valueForKey:@"type"] intValue];
    
    NSString *path=@"";
    
    if(typeOfSearch==1) //interest based
    {
        NSString *string=[dict valueForKey:@"word"];

      path=[NSString stringWithFormat:@"search/post/?interest_name=%@",string];
    }
    if(typeOfSearch==2) //interest based
    {
        NSString *string=[dict valueForKey:@"word"];
        
        path=[NSString stringWithFormat:@"search/post/?tag_names=%@",string];
    }
    if(typeOfSearch==3) //interest based
    {
        NSString *string=[dict valueForKey:@"word"];
        
        path=[NSString stringWithFormat:@"search/post/?topic_texts=%@",string];
    }
    if(typeOfSearch==4)
    {
        NSString *channelName=[dict valueForKey:@"word"];
        NSString *topicName=[dict valueForKey:@"topic"];
        
        path=[NSString stringWithFormat:@"search/post/?interest_name=%@&topic_texts=%@",channelName,topicName];
        
    }
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
    
   NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    //    NSError *error;
    //  NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //[urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
              //  NSLog(@"json error:%@",Jerror);
            }
            else
            {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
               
                
                
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
}


#pragma mark - Login API

-(void)sendRequestForLoginWithData:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector
{
    
//    NSString *path=@"custom_auth/api-token-auth/";
        NSString *path=@"custom_auth/fetch/token/";
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                             JSONObjectWithData:data
                             options:kNilOptions
                             error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;

              //  NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"result"] valueForKey:@"token"]!=nil)
                {
               //     NSLog(@"Success");
                    
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"result"];


                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"error"];
                    

                    
                }
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{

        [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });

    }];
    
    [postDataTask resume];
}
#pragma mark - User Profile Retrival
-(void)sendRequestForUserData:(NSString *)token andUserId:(NSString *)userId delegate:(id)delegate andSelector:(SEL)selector
{
    
    //curl -X GET http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/userprofile/ -H 'Authorization: Token ad44b3c55e73cdca2b84e2c7d4c0d2f2d7e7532d'
    
    NSString *path=[NSString stringWithFormat:@"user/%@/userprofile/",userId];
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
    
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    //    NSError *error;
    //  NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //[urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
              //  NSLog(@"json error:%@",Jerror);
            }
            else
            {
                
                if([jsonDict valueForKey:@"results"]!=nil)
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"detail"];
                }
                
                
                
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
}

#pragma mark - User Search
-(void)sendRequestForUserSearch:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector
{
//    http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/search/userprofile/?skills_text=python&username=testuser2
    
//    NSDictionary *dict=@{@"paramKey":paramKey,@"searchTerm":searchFieldTXT.text};

    
    NSString *path=[NSString stringWithFormat:@"search/userprofile/?%@=%@",[dict valueForKey:@"paramKey"],[dict valueForKey:@"searchTerm"]];
    
    NSLog(@"SEARCHING AT %@", path);
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                
                NSLog(@"SUCCESSFUL SEARCH");
               
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
              
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
}
-(void)sendRequestForAllUserData:(NSString *)token delegate:(id)delegate andSelector:(SEL)selector
{
    
    //curl -X GET http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/userprofile/ -H 'Authorization: Token ad44b3c55e73cdca2b84e2c7d4c0d2f2d7e7532d'
    
    NSString *path=[NSString stringWithFormat:@"user/userprofile/"];
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
    
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    //    NSError *error;
    //  NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //[urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                
                if([jsonDict valueForKey:@"results"]!=nil)
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"detail"];
                }
                
                
                
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
}
#pragma mark - Signup Mechanism
-(NSMutableData *)setUpBodyForSignup:(NSDictionary *)dict
{
    
    NSString *profile_photo=[dict valueForKey:@"profile_photo"];
    NSString *cover_photo=[dict valueForKey:@"cover_photo"];
    NSString *username=[dict valueForKey:@"username"];
    NSString *email=[dict valueForKey:@"email"];
    
    NSString *first_name=[dict valueForKey:@"first_name"];
    NSString *last_name=[dict valueForKey:@"last_name"];
    NSString *dob=[dict valueForKey:@"dob"];
    NSString *password=[dict valueForKey:@"password"];
    
    
    NSString *interests=[dict valueForKey:@"interests"];
    NSString *invite_code=[dict valueForKey:@"invite_code"];
    NSString *skills=[dict valueForKey:@"skills"];
    //NSString *profession=[dict valueForKey:@"profession"];
    
    
    
    /*   curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/custom_auth/user/register/ --dump-header - -H "Content-Type: multipart/form-data"  -X POST -F username="alonehitman" -F email="hardik@test.com" -F password="testpass123" -F first_name="testfname11" -F last_name="testlname11" -F skills=[1,2] -F profession=1 -F interests=[1,2] -Finvite_code="REALPEOPLE" -F dob="2000-10-10" -F cover_photo="@/Users/Hardik/Desktop/Research2/9d033fd0788d1a5704f93f20c6df4bfe.jpg" -F profile_photo="@/Users/Hardik/Github/MeanWiseUX/MeanWiseUX/temp/profile8.jpg" | more*/
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    
    
    NSMutableData *body = [NSMutableData data];
    
    // file
    float low_bound = 0;
    float high_bound =5000;
    float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);//image1
    int intRndValue = (int)(rndValue + 0.5);
    NSString *str_image1 = [@(intRndValue) stringValue];
    
    //UIImage *chosenImage1=[UIImage imageWithContentsOfFile:cover_photo];
    //NSData *mediaData = UIImageJPEGRepresentation(chosenImage1, 90);
    
    NSData *cover_photoData = [NSData dataWithContentsOfFile:cover_photo];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"cover_photo\"; filename=\"coverphoto.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:cover_photoData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *profile_photoData = [NSData dataWithContentsOfFile:profile_photo];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profile_photo\"; filename=\"profile_photo.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:profile_photoData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //username
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:username] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //email
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"email\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:email] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //first_name
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"first_name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:first_name] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //last_name
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"last_name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:last_name] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //dob
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"dob\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:dob] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //password
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:password] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //interest
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"interests\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:interests] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //invite_code
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"invite_code\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:invite_code] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //skills
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"skills\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:skills] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    /*//profession
     [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profession\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[[NSString stringWithString:profession] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     
     */
    
    
    return body;
}


-(void)sendRequestForSignUp:(NSDictionary *)dataDict delegate:(id)delegate andSelector:(SEL)selector
{
    /*
     curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/custom_auth/user/register/ --dump-header - -H "Content-Type: multipart/form-data"  -X POST -F username="alonehitman" -F email="hardik@test.com" -F password="testpass123" -F first_name="testfname11" -F last_name="testlname11" -F skills=[1,2] -F profession=1 -F interests=[1,2] -Finvite_code="REALPEOPLE" -F dob="2000-10-10" -F cover_photo="@/Users/Hardik/Desktop/Research2/9d033fd0788d1a5704f93f20c6df4bfe.jpg" -F profile_photo="@/Users/Hardik/Github/MeanWiseUX/MeanWiseUX/temp/profile8.jpg" | more
     */
    
    NSString *path=@"custom_auth/user/register/";
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [urlRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    
    [urlRequest setHTTPBody:[self setUpBodyForSignup:dataDict]];
    
    
    
    
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                }
                else
                {
                    obj.statusCode=500;
                    
                    NSDictionary *errorDict=[jsonDict valueForKey:@"error"];
                    
                    if([errorDict objectForKey:@"username"]!=nil)
                    {
                        obj.message=[[errorDict valueForKey:@"username"] objectAtIndex:0];
                    }
                    else
                    {
                        NSLog(@"ERRORS:::::: %@, %@, %@", Jerror, errorDict, jsonDict);
                        obj.message=@"Unknown Error received";
                    }
                    
                    //obj.message=[[jsonDict valueForKey:@"non_field_errors"] objectAtIndex:0];
                    
                    
                    
                }
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
    
    
    
}

-(void)sendRequestTocheckIfUserExistWithEmail:(NSString *)email withDelegate:(id)delegate andSelector:(SEL)selector
{
    
    //http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/custom_auth/user/verify/
    
    NSString *path=@"custom_auth/user/verify/";
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSDictionary *dict=@{@"email":email};
    
    
    NSError *error=nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [urlRequest setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[[jsonDict valueForKey:@"non_field_errors"] objectAtIndex:0];
                    
                    
                    
                }
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
}

#pragma mark - Edit Profile
-(void)sendRequestForChangePassword:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector
{
   // curl -X POST http://127.0.0.1:8000/api/v4/user/41/change/password/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token 638b5d5a3b8d83b28fdd580d25c717cf574a4710" -X POST --data '{"old_password":"testpass321", "new_password":"testpass123"}' | more
    
    //http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/18/userprofile/
    
    NSString *token=[UserSession getAccessToken];
    NSString *userId=[UserSession getUserId];
    
    NSString *path=[NSString stringWithFormat:@"user/%@/change/password/",userId];
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    
    
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                
                if(![[jsonDict valueForKey:@"status"] isEqualToString:@"failed"])
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"error"];
                }
                
                
                
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
}

-(void)sendRequestForEditProfile:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector
{
    
    //http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/18/userprofile/
    
    NSString *token=[UserSession getAccessToken];
    NSString *userId=[UserSession getUserId];
    
    NSString *path=[NSString stringWithFormat:@"user/%@/userprofile/",userId];
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"PATCH"];
    
    
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                
                if([jsonDict valueForKey:@"results"]!=nil)
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"detail"];
                }
                
                
                
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
}


-(void)sendRequestForUpdateCoverPhoto:(NSString *)coverphotoURL delegate:(id)delegate andSelector:(SEL)selector
{
    NSString *token=[UserSession getAccessToken];
    NSString *userId=[UserSession getUserId];
    
    NSString *path=[NSString stringWithFormat:@"user/%@/userprofile/",userId];
    

    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0f];
    [urlRequest setHTTPMethod:@"PATCH"];
    
    
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    
    
    //Creating Body
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [urlRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];

    // file
    float low_bound = 0;
    float high_bound =5000;
    float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);//image1
    int intRndValue = (int)(rndValue + 0.5);
    NSString *str_image1 = [@(intRndValue) stringValue];
    
    //UIImage *chosenImage1=[UIImage imageWithContentsOfFile:mediaURL];
    // NSData *mediaData = UIImageJPEGRepresentation(chosenImage1, 90);
    
    NSData *mediaData = [NSData dataWithContentsOfFile:coverphotoURL];
    
   
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *string=[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"cover_photo\"; filename=\"%@.jpg\"\r\n",str_image1];
    
    [body appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:mediaData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
   
    
    [urlRequest setHTTPBody:body];
    
    
    
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                
                if([jsonDict valueForKey:@"results"]!=nil)
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"detail"];
                }
                
                
                
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
    
}

-(void)sendRequestForForgetPasswordWithDelegate:(id)delegate andSelector:(SEL)selector;
{
    NSString *path=[NSString stringWithFormat:@"user/%@/forgot/password/",[UserSession getUserId]];
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *token=[UserSession getAccessToken];
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    [urlRequest setHTTPMethod:@"GET"];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[[jsonDict valueForKey:@"non_field_errors"] objectAtIndex:0];
                    
                    
                    
                }
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
}

-(void)sendRequestForUpdateProfilePhoto:(NSString *)coverphotoURL delegate:(id)delegate andSelector:(SEL)selector
{
    NSString *token=[UserSession getAccessToken];
    NSString *userId=[UserSession getUserId];
    
    NSString *path=[NSString stringWithFormat:@"user/%@/userprofile/",userId];
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0f];
    [urlRequest setHTTPMethod:@"PATCH"];
    
    
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    
    
    //Creating Body
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [urlRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // file
    float low_bound = 0;
    float high_bound =5000;
    float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);//image1
    int intRndValue = (int)(rndValue + 0.5);
    NSString *str_image1 = [@(intRndValue) stringValue];
    
    //UIImage *chosenImage1=[UIImage imageWithContentsOfFile:mediaURL];
    // NSData *mediaData = UIImageJPEGRepresentation(chosenImage1, 90);
    
    NSData *mediaData = [NSData dataWithContentsOfFile:coverphotoURL];
    
    
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *string=[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profile_photo\"; filename=\"%@.jpg\"\r\n",str_image1];
    
    [body appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:mediaData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [urlRequest setHTTPBody:body];
    
    
    
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                
                if([jsonDict valueForKey:@"results"]!=nil)
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"detail"];
                }
                
                
                
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
    
}




#pragma mark - static API
-(void)sendRequestForSkillsWithDelegate:(id)delegate andSelector:(SEL)selector;
{
    NSString *path=@"skill/";
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    NSDictionary *dataDict = [jsonDict valueForKey:@"results"];
                    
                    obj.response=[dataDict valueForKey:@"data"];
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[[jsonDict valueForKey:@"non_field_errors"] objectAtIndex:0];
                    
                    
                    
                }
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
    
}
-(void)sendRequestForProffesionsWithDelegate:(id)delegate andSelector:(SEL)selector
{
    NSString *path=@"profession/";
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    
                    NSDictionary *dataDict = [jsonDict valueForKey:@"results"];

                    obj.response=[dataDict valueForKey:@"data"];
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[[jsonDict valueForKey:@"non_field_errors"] objectAtIndex:0];
                    
                    
                    
                }
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;
            
            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
    
}
-(void)sendRequestForInterestWithDelegate:(id)delegate andSelector:(SEL)selector
{
    NSString *path=@"interest/";
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=nil;
        obj.response=nil;
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                obj.statusCode=Jerror.code;
                obj.message=Jerror.localizedDescription;
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    NSDictionary *dataDict = [jsonDict valueForKey:@"results"];
                    
                    
                    obj.response=[dataDict valueForKey:@"data"];
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[[jsonDict valueForKey:@"non_field_errors"] objectAtIndex:0];
                    
                }
            }
        }
        else
        {
            obj.statusCode=error.code;
            obj.message=error.localizedDescription;

            //NSLog(@"Error %ld",error.code);
            //NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
    
}
@end
