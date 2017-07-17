//
//  ShareObject.h
//  ShareMenu
//
//  Created by Hardik on 18/02/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>




@interface SHARE_fbObject : NSObject
//@property NSString *textToShare;
//@property NSString *urlStringToShare;
//@property UIImage *imageToShare;
@property NSString *contentTitle;
@property NSString *contentDescription;
@property NSString *contentURL;
@property NSString *imageURL;
@property UIImage *imageAttachment;
@end

@interface SHARE_twitterObject : NSObject
@property NSString *textToShare;
@property NSString *urlStringToShare;
@property UIImage *imageToShare;
@end

@interface SHARE_emailObject : NSObject
@property NSString *emailTitle;
@property NSString *emailBody;
@property NSString *emailTo;
@property NSString *emailAttachment;
@property UIImage *imageAttachment;
@end

@interface SHARE_smsObject : NSObject
@property NSString *smsText;
@property UIImage *imageAttachment;
@end

@interface SHARE_clipBoardObject : NSObject
@property NSString *clipBoardText;
@end

