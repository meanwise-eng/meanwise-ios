//
//  PostTrackSeenHelper.h
//  VideoPlayerDemo
//
//  Created by Hardik on 12/08/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTrackSeenHelper : UIView
{
    
    NSString *currentURL;
    NSString *currentURLTime;
    NSMutableArray *allRecords;

    NSString *analyticsPath;
    
}
+ (instancetype)sharedInstance;




-(void)PS_setNewURL:(NSString *)urlstr;
-(void)PS_NewPost:(NSDictionary *)dict;
-(NSString *)getCurrentTime;


-(void)postAllJsonFiles;


@end


//Create Folder
//save File
//Upload All files


/*

 1. NEW API Call - setNewURL
 2. Add entry for visible items and when scroll happens - Explore screen
 3. When tap - Annote
 4. When scroll in expanded feed-

*/
