//
//  VideoTextItemCell.h
//  ExactResearch
//
//  Created by Hardik on 14/02/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VideoTextItemCell : UIView <UITextViewDelegate>
{
    
    id targetTextChange;
    SEL textChangeFunc;
    SEL deleteBtnClickedFunc;
    int pathMain;

    UIView *mainAreaView;
    UITextView *textView;
    
    UIButton *deleteDoneBtn;
    UILabel *counterLBL;
    
    int isInEditMode;
    
}
-(void)updateIndexPath:(int)path;

-(void)setFrameX:(CGRect)rect;
-(void)setTextValue:(NSString *)text andIndexPath:(int)path;
-(void)setUpMainWithFrame:(CGRect)frame;

-(void)setTarget:(id)target andtextchangeFunc:(SEL)selector andDeleteBtnClicked:(SEL)selector2;
@end
