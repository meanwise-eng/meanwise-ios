//
//  OverlayStickerView.h
//  VideoPlayerDemo
//
//  Created by Hardik on 09/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomRotatePanImageView.h"

@interface OverlayStickerView : ZoomRotatePanImageView <UITextViewDelegate>
{
    
    float currentKeyboardHeight;
    UITextView *mainTextView;
    UIView *mainView;
    
    id editingDelegate;
    SEL onEditingStart;
    SEL onEditingEnd;
    SEL onDeleteCallBack;
    
    
    BOOL allowBackground;
}
-(void)setUpOverLaySticker;
-(void)resignResponderThis;
-(void)becomeResponsderThis;

-(void)setEditingDelegate:(id)delegateReceived onEditingStart:(SEL)func1 onEditingEnd:(SEL)func2;
-(void)setDeleteCallBack:(SEL)func;
-(float)getKeyboardHeight;


-(void)changeProperty:(NSDictionary *)dict;

-(void)cleanUp;



@end
