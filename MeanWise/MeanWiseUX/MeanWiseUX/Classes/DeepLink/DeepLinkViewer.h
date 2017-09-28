//
//  DeepLinkViewer.h
//  MeanWiseUX
//
//  Created by Hardik on 12/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeepLinkPostViewer.h"
#import "HMPlayerManager.h"

@interface DeepLinkViewer : UIView
{
    UIWindow *window;
    
    

    
    NSString *profileIdentifier;
    NSString *homeIdentifier;
    NSString *exploreIdentifier;
    NSString *notificationIdentifier;
    
    
    id delegate;
    SEL onCleanupCallBack;

}
-(void)setUpWithPostId:(NSString *)postId;
-(void)cleanUp;
-(void)setDelegate:(id)target onCleanUp:(SEL)func;
@end
