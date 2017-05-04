//
//  APIObjects_NotificationObj.h
//  MeanWiseUX
//
//  Created by Hardik on 02/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIObjects_NotificationObj : NSObject

@property (nonatomic, strong) NSString* notificationReceiverUserName;
@property (nonatomic,strong) NSNumber *notificationIdNo;

@property (nonatomic, strong) NSString* notificationId;
@property (nonatomic, strong) NSString* notification_type;
@property (nonatomic,strong) NSNumber *notification_typeNo;

@property (nonatomic, strong) NSString* created_on;

@property (nonatomic, strong) NSString* notifier_userId;
@property (nonatomic, strong) NSString* notifier_userFirstName;
@property (nonatomic, strong) NSString* notifier_userLastName;
@property (nonatomic, strong) NSString* notifier_userUserName;
@property (nonatomic, strong) NSString* notifier_userThumbURL;

@property (nonatomic, strong) NSString* postId;
@property (nonatomic, strong) NSString* postThumbURL;
@property (nonatomic, strong) NSString* postType;

@property (nonatomic, strong) NSString* commentId;
@property (nonatomic, strong) NSString* commentText;

@property (nonatomic, strong) NSString* msgText;

@property (nonatomic, strong) NSNumber* notificationIsNew;

@property (nonatomic,strong) NSDictionary *postFeedObj;


-(void)setUpWithDict:(NSDictionary *)dict;





@end
