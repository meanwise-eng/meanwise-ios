//
//  PreviewMedia_ImageController.h
//  ExactResearch
//
//  Created by Hardik on 13/02/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewMedia_ImageController : UIView <UITextViewDelegate>
{
    NSString *filePathStr;
    BOOL isVideo;
    
    UIImageView *keyImageView;
    UIImageView *shadowImageView;
    
    UIButton *editBtn;
    UIButton *doneBtn;
    UIButton *EditingCorrectBtn;
    UIButton *EditingCancelBtn;
    
    
    
    UITextView *field;
    
    id target;
    SEL onSuccessFunc;
    SEL onCancelFunc;

    
    
    UIView *keyBoardBar;
    UIButton *blackColorBtn;
    UIButton *whiteColorBtn;

    UIButton *alignmentBtn;
    UIButton *fontSizeUpBtn;
    UIButton *fontSizeDownBtn;
    int fontSize;
    
    
}
-(void)setTarget:(id)targetReceived OnSuccess:(SEL)func1 OnFail:(SEL)func2;

-(void)setUpWithString:(NSString *)strPath;
@end
