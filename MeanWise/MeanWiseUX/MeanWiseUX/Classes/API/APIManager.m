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
#import "Constant.h"
#import "PostTrackSeenHelper.h"
#import "NSString+UrlEncode.h"

@implementation APIManager

-(NSString *)baseString
{
// Test1
 //   return @"http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/";
 //Test2
//    return @"http://ec2-54-159-112-138.compute-1.amazonaws.com:8000/api/v4/";

//Test2
  //  return  @"http://ec2-34-228-26-196.compute-1.amazonaws.com:8000/api/v4/";
    
//Dev Server 1.1
  // return @"http://ec2-34-228-26-196.compute-1.amazonaws.com:8001/api/v4/";
    
//Live 1.0
 //  return @"https://api.meanwise.com/api/v4/";
    
//    Live 1.1
    //return @"https://api.meanwise.com/api/v1.1/";

  // Dev server 1.2
 // return @"http://34.228.26.196:8002/api/v4/";
   
//    Live 1.2
   return @"https://api.meanwise.com/api/v1.2/";
    

}


#pragma mark - AutoComplete

-(void)sendRequestGenericAutoCompleteAPI:(NSDictionary *)dict Withdelegate:(id)delegate andSelector:(SEL)selector
{
    
    // curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/posts/topics/autocomplete/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token ad44b3c55e73cdca2b84e2c7d4c0d2f2d7e7532d" -X POST --data '{"tag":"ta"}' | more
    
    // curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/posts/tags/autocomplete/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token ad44b3c55e73cdca2b84e2c7d4c0d2f2d7e7532d" -X POST --data '{"tag":"ta"}' | more
    
    
    int searchType=1;
    NSString *path=@"posts/tags/autocomplete/";
    NSString *method=@"POST";
    
    NSDictionary *paramDict=@{[dict valueForKey:@"searchFor"]:[dict valueForKey:@"searchTerm"]};
    
    if([[dict valueForKey:@"searchFor"] isEqualToString:@"username"])
    {
        path=@"autocomplete/user/";
        path=[NSString stringWithFormat:@"%@?%@=%@",path,[dict valueForKey:@"searchFor"],[dict valueForKey:@"searchTerm"]];
        method=@"GET";
        searchType=2;
    }
    
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    finalURL = [finalURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:method];
    
    NSString *token=@"f684ba596e8f6e09a3f295f76a3d72d6d4e6b8db"; //D
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    if(searchType==1)
    {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:paramDict options:0 error:&error];
        [urlRequest setHTTPBody:postData];
    }
    
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
                
                
                if([jsonDict valueForKey:@"results"]!=nil && [[jsonDict valueForKey:@"results"] isKindOfClass:[NSArray class]])
                {
                    NSLog(@"Success");
                    
                    obj.statusCode=200;
                    obj.message=@"Success";
                    
                    obj.response=@{
                                   @"searchFor":[dict valueForKey:@"searchFor"],
                                   @"searchTerm":[dict valueForKey:@"searchTerm"],
                                   @"data":[jsonDict valueForKey:@"results"]
                                   };
                    
                    
                    
                    
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

#pragma mark - Friendship Mechanism
-(void)sendRequestGettingUsersFriends:(NSString *)userId status:(int)statusValue delegate:(id)delegate andSelector:(SEL)selector
{
    

    
 //   NSString *path=[NSString stringWithFormat:@"user/%@/friends/",userId];
    NSString *path=[NSString stringWithFormat:@"user/%@/friends/?page_size=%d&page=%d",userId,(int)self.countRequested,(int)self.pageNoRequested];

    if(statusValue==-1)
    {
        [AnalyticsMXManager PushAnalyticsEventAPI:@"API-Friend-Pending"];

        path=[NSString stringWithFormat:@"%@&status=pending",path];
    }
    else{
        [AnalyticsMXManager PushAnalyticsEventAPI:@"API-Friend-list"];

    }
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:30.0f];
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
        obj.totalNumOfPagesAvailable=nil;
        obj.inputPageNo=self.pageNoRequested;
        
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
                    obj.totalNumOfPagesAvailable=[[[jsonDict valueForKey:@"results"] valueForKey:@"num_pages"] integerValue];
                    obj.inputPageNo=self.pageNoRequested;

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
        
        [delegate performSelectorInBackground:selector withObject:obj];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [delegate performSelector:selector withObject:obj afterDelay:0.01];
//        });
        
    }];
    
    [postDataTask resume];
}

-(void)sendRequestForUpdateFriendshipStatus:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector
{
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-Friend-Respond"];

    /*
     curl -X POST http://ec2-54-159-112-138.compute-1.amazonaws.com:8000/api/v4/user/6/friends/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token a090e9e5d74815da85de56925ee82ba45b073856" -X POST --data '{"friend_id":7, "status":"pending"}' | more
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
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([jsonDict valueForKey:@"results"]!=nil)
                {
                    NSLog(@"Success");
                    
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
    
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-Like"];

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
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-Comment"];

    
   // curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/posts/2/comments/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token 638b5d5a3b8d83b28fdd580d25c717cf574a4710" -X POST --data '{"comment_text":"test comment one", "commented_by":10}'
    
 //   curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/posts/1/comments/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token e581fe1f83d40a6de5761d6ce8bbff0e0a0680c6" -X POST --data '{"comment_text":"test comment one", "commented_by":18}' | more
    
//    curl -X POST http://ec2-54-159-112-138.compute-1.amazonaws.com:8000/api/v4/posts/3/comments/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token a090e9e5d74815da85de56925ee82ba45b073856" -X POST --data '{"comment_text":"test comment one", "commented_by":7}' | more
    
    
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
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-Deletepost"];

    
    // curl -X  DELETE http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/17/posts/3/ -H 'Authorization: Token 638b5d5a3b8d83b28fdd580d25c717cf574a4710' | more
    
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


-(void)sendRequestForNewPostWithMedia:(NSDictionary *)dict WithMediaURL:(NSString *)mediaURL andTypeisVideo:(BOOL)isVideo delegate:(id)delegate andSelector:(SEL)selector
{
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-PostMedia"];

   /* NSDictionary *dict1=@{
                          @"text":text,
                          @"interest":interest,
                          @"topic_names":topic_names,
                          @"tags":tags
                          };
    
    
    dict1=@{
    @"text":text,
    @"interest":interest,
    @"topic_names":topic_names,
    @"tags":tags,
    @"geo_location_lat":geo_location_lat,
    @"geo_location_lng":geo_location_lng,
    @"mentioned_users":mentioned_users,
    
    };
    
    */
    
    // curl -X POST http://127.0.0.1:8000/api/v4/user/17/posts/ --dump-header - -H "Content-Type: multipart/form-data" -H "Authorization: Token 638b5d5a3b8d83b28fdd580d25c717cf574a4710" -X POST -F interest=1 -F image="@/home/raj/Pictures/mobile/IMG_20140310_195139094.jpg" | more

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
    
    NSData *mediaData = [NSData dataWithContentsOfFile:mediaURL];

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
    [body appendData:[NSData dataWithData:mediaData]];
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
    


    if([dict valueForKey:@"mentioned_users"])
    {
        NSArray *mentioned_users=[dict valueForKey:@"mentioned_users"];

        for(int i=0;i<mentioned_users.count;i++)
        {
       /// NSString *mentioned_users=[dict valueForKey:@"mentioned_users"];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"mentioned_users\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"%@", [mentioned_users objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];

        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    if([[dict valueForKey:@"geo_location_lat"] floatValue]!=0){
        NSNumber *tags=[dict valueForKey:@"geo_location_lat"];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"geo_location_lat\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%f",[tags floatValue]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if([[dict valueForKey:@"geo_location_lng"] floatValue]!=0){

        NSNumber *tags=[dict valueForKey:@"geo_location_lng"];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"geo_location_lng\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%f",[tags floatValue]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
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
                
                NSLog(@"json error:%@",Jerror);
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
                    NSLog(@"Success");
                    
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
            
            NSLog(@"Error %ld",error.code);
            NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
    

    
}
-(void)sendRequestForNewPost:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector
{
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-Text"];
    
    /* NSDictionary *dict1=@{
     @"text":text,
     @"interest":interest,
     @"topic_names":topic_names,
     @"tags":tags
     };
     
     
     dict1=@{
     @"text":text,
     @"interest":interest,
     @"topic_names":topic_names,
     @"tags":tags,
     @"geo_location_lat":geo_location_lat,
     @"geo_location_lng":geo_location_lng,
     @"mentioned_users":mentioned_users,
     
     };
     
     */
    
    // curl -X POST http://127.0.0.1:8000/api/v4/user/17/posts/ --dump-header - -H "Content-Type: multipart/form-data" -H "Authorization: Token 638b5d5a3b8d83b28fdd580d25c717cf574a4710" -X POST -F interest=1 -F image="@/home/raj/Pictures/mobile/IMG_20140310_195139094.jpg" | more
    
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
    
    
    
    if([dict valueForKey:@"mentioned_users"])
    {
        NSArray *mentioned_users=[dict valueForKey:@"mentioned_users"];
        
        for(int i=0;i<mentioned_users.count;i++)
        {
            /// NSString *mentioned_users=[dict valueForKey:@"mentioned_users"];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"mentioned_users\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"%@", [mentioned_users objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    if([[dict valueForKey:@"geo_location_lat"] floatValue]!=0){
        NSNumber *tags=[dict valueForKey:@"geo_location_lat"];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"geo_location_lat\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%f",[tags floatValue]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if([[dict valueForKey:@"geo_location_lng"] floatValue]!=0){
        
        NSNumber *tags=[dict valueForKey:@"geo_location_lng"];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"geo_location_lng\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%f",[tags floatValue]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
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
                
                NSLog(@"json error:%@",Jerror);
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
                    NSLog(@"Success");
                    
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
            
            NSLog(@"Error %ld",error.code);
            NSLog(@"Error %@",error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate performSelector:selector withObject:obj afterDelay:0.01];
        });
        
    }];
    
    [postDataTask resume];
    

    
}
-(void)sendRequestForNewPostOld:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector
{
    NSDictionary *dict1=@{
            @"text":[dict valueForKey:@"text"],
            @"interest":[dict valueForKey:@"interest"],
            @"topic_names":[dict valueForKey:@"topic_names"],
            @"tags":[dict valueForKey:@"tags"],
            @"geo_location_lat":@([[dict valueForKey:@"geo_location_lat"] floatValue]),
            @"geo_location_lng":@([[dict valueForKey:@"geo_location_lng"] floatValue]),
            
            };
    dict=dict1;
    
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-NewPost-Text"];

    //curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/18/posts/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token e581fe1f83d40a6de5761d6ce8bbff0e0a0680c6" -X POST --data '{"text":"text post dec22", "interest":1}' | more

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
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([jsonDict valueForKey:@"results"]!=nil)
                {
                    NSLog(@"Success");
                    
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

-(void)sendRequestForDeleteComment:(NSString *)commentId postId:(NSString *)postId delegate:(id)delegate andSelector:(SEL)selector;
{
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-DeleteComment"];

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
    
    //    curl GET http://34.228.26.196:8002/api/v4/posts/109/comments/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token f684ba596e8f6e09a3f295f76a3d72d6d4e6b8db" | more
    
    NSString *path=[NSString stringWithFormat:@"posts/%@/comments/",postId];
    //path=[NSString stringWithFormat:@"%@?item_count=%d",path,5];

    
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
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                    
                    obj.forwardURLStr=[jsonDict valueForKey:@"forward"];
                    obj.backwardURLStr=[jsonDict valueForKey:@"backward"];

                    
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
 
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-ChannelSearch"];

    NSString *path=[NSString stringWithFormat:@"search/post/?interest_name='%@'",channelName];
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
//    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",@"e581fe1f83d40a6de5761d6ce8bbff0e0a0680c6"];
//    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];

    
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
    
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-UserPost"];

    NSString *path=[NSString stringWithFormat:@"user/%@/posts/",userId];
    
    // path=[NSString stringWithFormat:@"%@?item_count=%d",path,5];

    
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
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"])
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                    
                    if([jsonDict valueForKey:@"total"]!=nil)
                    {
                        obj.totalRecords=[[jsonDict valueForKey:@"total"] integerValue];
                    }
                    
                    obj.forwardURLStr=[jsonDict valueForKey:@"forward"];
                    obj.backwardURLStr=[jsonDict valueForKey:@"backward"];


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
-(void)sendRequestForMyNotificationsWithdelegate:(id)delegate andSelector:(SEL)selector
{

    // curl -X GET  http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/17/home/feed/ -H 'Authorization: Token ad44b3c55e73cdca2b84e2c7d4c0d2f2d7e7532d' | more
    
//    curl -X GET  http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/17/notifications/latest/ -H 'Authorization: Token e581fe1f83d40a6de5761d6ce8bbff0e0a0680c6' | more
    
    //    curl -X GET  http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/5/notifications/latest/ -H 'Authorization: Token 659581f173cd25cca2011d97249db5900980b9e4' | more

    
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

-(void)sendRequestHomeFeedFor_UserWithdelegate:(id)delegate andSelector:(SEL)selector
{
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-Home"];

  // curl -X GET  http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/17/home/feed/ -H 'Authorization: Token ad44b3c55e73cdca2b84e2c7d4c0d2f2d7e7532d' | more
    
    NSString *userId=[UserSession getUserId];
//    NSString *path=[NSString stringWithFormat:@"user/%@/home/feed/?page_size=200",userId];
    NSString *path=[NSString stringWithFormat:@"user/%@/home/feed/?page_size=%d&page=%d",userId,(int)self.countRequested,(int)self.pageNoRequested];

    if((int)self.countRequested==-1)
    {
        path=[NSString stringWithFormat:@"user/%@/home/feed/",userId];
    }
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    finalURL = [finalURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

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
        obj.totalNumOfPagesAvailable=nil;
        obj.inputPageNo=self.pageNoRequested;
        
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
                    obj.totalNumOfPagesAvailable=[[[jsonDict valueForKey:@"results"] valueForKey:@"num_pages"] integerValue];
                    obj.inputPageNo=self.pageNoRequested;
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

-(void)sendRequestForPostInfoWithId:(NSString *)postId Withdelegate:(id)delegate andSelector:(SEL)selector;
{
    
    
    //curl GET http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/interests/2/topics/trending/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token ad44b3c55e73cdca2b84e2c7d4c0d2f2d7e7532d" | more
    
    
    //curl GET http://ec2-54-159-112-138.compute-1.amazonaws.com:8000/api/v4/post/25/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token 14ad0f5008b049e24e0fdc6a3857722d31db09b9" | more
    
    NSString *path=[NSString stringWithFormat:@"post/%@/",postId];
    
    
    //http://ec2-54-159-112-138.compute-1.amazonaws.com:8000/api/v4/post/25/
    
    
    
    
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
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                

                
                if([jsonDict valueForKey:@"detail"]==nil)
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=jsonDict;
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=@"Fail";
                    obj.response=[jsonDict valueForKey:@"detail"];
                }
                
               /* if([jsonDict valueForKey:@"results"]!=nil && [[jsonDict valueForKey:@"results"] isKindOfClass:[NSArray class]])
                {
                    NSLog(@"Success");
                    
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                    
                    
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[jsonDict valueForKey:@"error"];
                    
                    
                    
                }*/
                
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
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-TopTrendingTopics"];

    //curl GET http://ec2-54-159-112-138.compute-1.amazonaws.com:8000/api/v4/interests/1/topics/trending/ --dump-header - -H "Content-Type: application/json" -H "Authorization: Token 14ad0f5008b049e24e0fdc6a3857722d31db09b9" | more
    
    
  //  NSString *path=[NSString stringWithFormat:@"interests/%@/topics/trending/",channelId];
    
    NSString *path=@"topics/trending/";
    
    if(![channelId isEqualToString:@"-1"])
    {
        path=[NSString stringWithFormat:@"%@?interest_id=%@",path,channelId];
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
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([jsonDict valueForKey:@"results"]!=nil && [[jsonDict valueForKey:@"results"] isKindOfClass:[NSArray class]])
                {
                    NSLog(@"Success");
                    
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
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([jsonDict valueForKey:@"results"]!=nil && [[jsonDict valueForKey:@"results"] isKindOfClass:[NSArray class]])
                {
                    NSLog(@"Success");
                    
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

      path=[NSString stringWithFormat:@"search/post/?interest_name=%@",[string lowercaseString]];
        [AnalyticsMXManager PushAnalyticsEventAPI:@"API-ExploreInterest"];

    }
    if(typeOfSearch==2) //interest based
    {
        NSString *string=[dict valueForKey:@"word"];
        
        path=[NSString stringWithFormat:@"search/post/?tag_names=%@",[string lowercaseString]];
        [AnalyticsMXManager PushAnalyticsEventAPI:@"API-ExploreTags"];

    }
    if(typeOfSearch==3) //interest based
    {
        NSString *string=[dict valueForKey:@"word"];
        [AnalyticsMXManager PushAnalyticsEventAPI:@"API-ExploreWord"];

        path=[NSString stringWithFormat:@"search/post/?topic_texts=%@",[string lowercaseString]];
    }
    if(typeOfSearch==4)
    {
        NSString *channelName=[dict valueForKey:@"word"];
        NSString *topicName=[dict valueForKey:@"topic"];
        [AnalyticsMXManager PushAnalyticsEventAPI:@"API-ExploreTopicInterest"];

        path=[NSString stringWithFormat:@"search/post/?interest_name=%@&topic_texts=%@",[channelName lowercaseString],[topicName lowercaseString]];

    }
    
    
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    finalURL = [finalURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    


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
                
                NSLog(@"json error:%@",Jerror);
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

-(void)sendRequestExploreFeedWithDict:(NSDictionary *)dict Withdelegate:(id)delegate andSelector:(SEL)selector;
{
    NSString *exploreFeedType=[dict valueForKey:@"exploreFeedType"];
    int typeOfSearch=[[dict valueForKey:@"type"] intValue];
    

    NSString *basePath=@"posts/explore";
    
    if([exploreFeedType isEqualToString:@"trendingPostsControl"])
    {
        basePath=@"posts/trending";
    }
    
    NSString *path=@"";
    if(typeOfSearch==-1) //No filter
    {
        path=[NSString stringWithFormat:@"%@/",basePath];

    }
    else if(typeOfSearch==1) //interest based
    {
        NSString *string=[[[dict valueForKey:@"word"] lowercaseString] urlFilterCharacters];
        
        path=[NSString stringWithFormat:@"%@/?interest_name=%@",basePath,string];
        
    }
    else if(typeOfSearch==2) //hashtag based
    {
        NSString *string=[[dict valueForKey:@"word"] lowercaseString];
        
        path=[NSString stringWithFormat:@"%@/?tag_names=%@",basePath,string];
        
    }
    else if(typeOfSearch==3) //topic based
    {
        NSString *string=[[dict valueForKey:@"word"] lowercaseString];
        
        path=[NSString stringWithFormat:@"%@/?topic_texts=%@",basePath,string];
    }
    else if(typeOfSearch==4) //Topic+Interest
    {
        NSString *channelName=[[[dict valueForKey:@"word"] lowercaseString] urlFilterCharacters];
        NSString *topicName=[[dict valueForKey:@"topic"] lowercaseString];
        
        path=[NSString stringWithFormat:@"%@/?interest_name=%@&topic_texts=%@",basePath,channelName,topicName];
        
    }
    else if(typeOfSearch==5) //Home + Topic
    {
        NSString *string=[[dict valueForKey:@"topic"] lowercaseString];
        path=[NSString stringWithFormat:@"%@/?topic_texts=%@",basePath,string];
    }
    
   /* if(typeOfSearch!=-1)
    {
        path=[NSString stringWithFormat:@"%@&item_count=%d",path,5];
    }
    else
    {
        path=[NSString stringWithFormat:@"%@?item_count=%d",path,5];

    }*/
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    [[PostTrackSeenHelper sharedInstance] PS_setNewURL:finalURL];

   // finalURL = [finalURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
   
    
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:20.0f];
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
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if(![[dict valueForKey:@"status"] isEqualToString:@"failed"])
                {
                obj.statusCode=200;
                obj.message=@"Success";
                    obj.totalRecords=[[jsonDict valueForKey:@"count"] integerValue];

             
                    
                obj.response=[jsonDict valueForKey:@"results"];
                obj.forwardURLStr=[jsonDict valueForKey:@"forward"];
                obj.backwardURLStr=[jsonDict valueForKey:@"backward"];
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[NSString stringWithFormat:@"%@",[jsonDict valueForKey:@"error"]];
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
-(void)sendRequestExploreFeedWithURL:(NSString *)path Withdelegate:(id)delegate andSelector:(SEL)selector;
{
    NSString *finalURL=path;
    
    finalURL = [finalURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
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
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                obj.statusCode=200;
                obj.message=@"Success";
                obj.response=[jsonDict valueForKey:@"results"];
                
                if([jsonDict valueForKey:@"total"]!=nil)
                {
                obj.totalRecords=[[jsonDict valueForKey:@"total"] integerValue];
                }
                
                
                obj.forwardURLStr=[jsonDict valueForKey:@"forward"];
                obj.backwardURLStr=[jsonDict valueForKey:@"backward"];
                
                
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

#pragma mark - Login API

-(void)sendRequestForLoginWithData:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector
{
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-Login"];

    
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

                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                if([[jsonDict valueForKey:@"result"] valueForKey:@"token"]!=nil)
                {
                    NSLog(@"Success");
                    
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

#pragma mark - User Search
-(void)sendRequestForUserSearch:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector
{
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-UserSearch"];

//    http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/search/userprofile/?skills_text=python&username=testuser2
    
//    NSDictionary *dict=@{@"paramKey":paramKey,@"searchTerm":searchFieldTXT.text};

    
    NSString *path=[NSString stringWithFormat:@"search/userprofile/?%@=%@",[dict valueForKey:@"paramKey"],[dict valueForKey:@"searchTerm"]];
    
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
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-FeaturedUser"];

    //curl -X GET http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/userprofile/ -H 'Authorization: Token ad44b3c55e73cdca2b84e2c7d4c0d2f2d7e7532d'
    
    NSString *path=[NSString stringWithFormat:@"user/userprofile/?featured=yes"];
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:10.0f];
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
    NSArray *skills_list=[dict valueForKey:@"skills_list"];
    NSString *profile_background_color=[dict valueForKey:@"profile_background_color"];
    
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
    
    //profile_background_color
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profile_background_color\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:profile_background_color] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    
    
    for(int i=0;i<[skills_list count];i++)
    {
    //skills
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"skills_list\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@", [skills_list objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
//    //skills
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"skills_list\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"%@", skills_list] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    
    
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
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-Signup"];

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
-(void)sendRequestTocheckIfUserExistWithUsername:(NSString *)username withDelegate:(id)delegate andSelector:(SEL)selector
{
    
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-UsernameExists"];

    //       curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/custom_auth/user/verify/ --dump-header - -H "Content-Type: application/json"  -X POST --data '{"email”:"call.max17@gmail.com”}' | more
    
    //http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/custom_auth/user/verify/
    
    NSString *path=@"custom_auth/user/verify-username";
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSDictionary *dict=@{@"username":username};
    
    
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

-(void)sendRequestTocheckInviteCode:(NSString *)inviteCode withDelegate:(id)delegate andSelector:(SEL)selector
{
    
    
    
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-InviteCode"];

    NSString *path=@"me/invite-code/";
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"PUT"];
    
    
    NSString *token=[UserSession getAccessToken];

    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSDictionary *dict=@{@"invite_code":inviteCode};
    
    
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
                if(![[jsonDict valueForKey:@"error"] isEqualToString:@""])
                {
                    obj.statusCode=500;
                    obj.message=@"Invalid Code!";

                }
                else
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];

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
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-EmailExists"];

    
//       curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/custom_auth/user/verify/ --dump-header - -H "Content-Type: application/json"  -X POST --data '{"email”:"call.max17@gmail.com”}' | more
    
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
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-ChangePassword"];

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
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-EditProfile"];

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
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-UpdateCoverPhoto"];

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
-(void)sendRequestForForgetPasswordWithDelegate:(id)delegate withData:(NSDictionary *)dict andSelector:(SEL)selector;
{
    
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-ForgetPass"];

    // curl -X POST http://ec2-54-86-42-134.compute-1.amazonaws.com:8000/api/v4/user/forgot/password/ --dump-header - -H "Content-Type: application/json" -X POST --data '{"email":"raj.emailme@gmail.com"}' | more

    
    NSString *path=[NSString stringWithFormat:@"user/forgot/password/"];
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [urlRequest setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    [urlRequest setHTTPBody:postData];

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
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-ProfilePhoto"];

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
-(void)sendRequestForAutoCompleteProfessions:(NSString *)term Delegate:(id)delegate andSelector:(SEL)selector
{
    
    
    NSString *path=[NSString stringWithFormat:@"autocomplete/profession/?q=%@",term];
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    
    
    // finalURL=[NSString stringWithFormat:@"https://autocomplete.clearbit.com/v1/companies/suggest?query=%@",term];
    
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
                NSArray *array=(NSArray *)jsonDict;
                
                obj.statusCode=200;
                obj.message=@"success";
                obj.response=@{@"results":array,@"searchTerm":term};
                
                //                [NSDictionary dictionaryWithObject:array forKey:@"results"];
                
                /*
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
                 
                 
                 
                 }*/
                
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

-(void)sendRequestForAutoCompleteSkills:(NSString *)term Delegate:(id)delegate andSelector:(SEL)selector
{
    

    NSString *path=[NSString stringWithFormat:@"autocomplete/skill/?q=%@",term];
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    
    
   // finalURL=[NSString stringWithFormat:@"https://autocomplete.clearbit.com/v1/companies/suggest?query=%@",term];
    
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
                NSArray *array=(NSArray *)jsonDict;
                
                obj.statusCode=200;
                obj.message=@"success";
                obj.response=@{@"results":array,@"searchTerm":term};
                
//                [NSDictionary dictionaryWithObject:array forKey:@"results"];
                
                /*
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
                    
                    
                    
                }*/
                
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
#pragma mark - Influencers

-(void)sendRequestForGetInfluencers:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector
{
    NSString *path=@"influencers/";
    
    if(dict!=nil)
    {
        path=[NSString stringWithFormat:@"%@?interest_name=%@",path,[dict valueForKey:@"word"]];
    }

    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    
    finalURL = [finalURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
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
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                obj.statusCode=200;
                obj.message=@"Success";
                obj.response=[jsonDict valueForKey:@"results"];
                
                obj.forwardURLStr=[jsonDict valueForKey:@"forward"];
                obj.backwardURLStr=[jsonDict valueForKey:@"backward"];
                
                
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


-(void)sendRequestForGetDiscussions:(NSDictionary *)dict delegate:(id)delegate andSelector:(SEL)selector
{
    
    
    NSString *path=@"discussions/";
    
    if(dict!=nil)
    {
        path=[NSString stringWithFormat:@"%@?interest_name=%@",path,[[dict valueForKey:@"word"] urlFilterCharacters]];
    }
   // path=[NSString stringWithFormat:@"%@?item_count=%d",path,10];

    NSString *finalURL=[[NSString stringWithFormat:@"%@%@",[self baseString],path] lowercaseString];
    
    finalURL = [finalURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

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
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                obj.statusCode=200;
                obj.message=@"Success";
                obj.response=[jsonDict valueForKey:@"results"];
                
                obj.forwardURLStr=[jsonDict valueForKey:@"forward"];
                obj.backwardURLStr=[jsonDict valueForKey:@"backward"];
                
                
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

#pragma mark - Push notification
-(void)registerDeviceForPushNotification:(NSString *)device delegate:(id)delegate andSelector:(SEL)selector
{
    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-PushTokenSubmit"];

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
//    NSLog(@"uuid - %@",[identifierForVendor UUIDString]);
    NSError *error;
    NSDictionary *dict;
    
    dict=@{
           @"device_id":uuid,
           @"user_id":userId,
           @"device_token":device,
          @"platform":@"APNS",
//           @"platform":@"APNS_SANDBOX"

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
                if([[jsonDict valueForKey:@"error"] isEqualToString:@""])
                {
                    
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                    
                    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-PushTokenSubmit-Success"];

                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[[jsonDict valueForKey:@"non_field_errors"] objectAtIndex:0];
                    [AnalyticsMXManager PushAnalyticsEventAPI:@"API-PushTokenSubmit-Fail"];

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

-(void)sendRequestForDeviceVersion:(id)delegate andSelector:(SEL)selector
{
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

 //   appVersionString=@"1.0.1";
 
    NSString *path=[NSString stringWithFormat:@"version/iOS/%@/",appVersionString];
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",[self baseString],path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSString *token=[UserSession getAccessTokenOnLaunch];
    if(token!=nil)
    {
    NSString *tokenParameter=[NSString stringWithFormat:@"Token %@",token];
    [urlRequest setValue:tokenParameter forHTTPHeaderField:@"Authorization"];
    }

    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        APIResponseObj *obj=[[APIResponseObj alloc] init];
        obj.message=@"gj";
        obj.response=nil;
        obj.statusCode=500;
        
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
                
                if([[jsonDict valueForKey:@"status"] isEqualToString:@"success"]) //working version
                {
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                    
                    if([[[obj.response valueForKey:@"latest_version"] valueForKey:@"version"] isEqualToString:[[obj.response valueForKey:@"version"] valueForKey:@"version"]]) //up to date
                    {
                        obj.message=@"1";

                        int p=0;
                    }
                    else //Update is avaialble
                    {
                        obj.message=@"2";

                        int p=0;
                    }
                }
                else if([[jsonDict valueForKey:@"status"] isEqualToString:@"failed"]) //Force Update
                {
                    obj.statusCode=200;
                    obj.message=@"3";
                    obj.response=[jsonDict valueForKey:@"results"];

                    int p=0;
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
#pragma mark - API for Custom Analytics

-(void)sendRequestForPostAnalytics:(NSDictionary *)dict withFileName:(NSString *)fileName delegate:(id)delegate andSelector:(SEL)selector
{
    [AnalyticsMXManager PushAnalyticsEventAPI:@"Seen TrackAPI "];
   
    
    NSString *path=[NSString stringWithFormat:@"analytics"];
    
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
        obj.apiInputInfo=fileName;
        
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
                if([[jsonDict valueForKey:@"results"] isEqualToString:@"success"])
                {
                    NSLog(@"Success");
                    
                    obj.statusCode=200;
                    obj.message=@"Success";
                    obj.response=[jsonDict valueForKey:@"results"];
                    
                }
                else
                {
                    obj.statusCode=500;
                    obj.message=[[jsonDict valueForKey:@"error"] valueForKey:@"errorMessage"];
                    
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







































