//
//  SinglePostViewer.h
//  MeanWiseUX
//
//  Created by Hardik on 15/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinglePostViewer : UIView
{
    id delegate;
    SEL onCleanupCallBack;
    
    
    BOOL isCommentOpen;
}
-(void)setUpWithPostId:(NSString *)postId withCommentOpen:(BOOL)flag;
-(void)setDelegate:(id)target onCleanUp:(SEL)func;

@end
