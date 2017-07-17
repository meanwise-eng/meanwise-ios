//
//  EditStoryComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MWNavBar.h"
#import "SAMTextView.h"

@interface EditStoryComponent : UIView <UITextViewDelegate>
{
    int noOfCharacters;
    UILabel *limitIndicatorLBL;

    
    UIView *storyDescBGV;
    
    SAMTextView *storyDescTV;
    
    
    UIView *navBar;
    UILabel *navBarTitle;
    
    id delegate;
    SEL backBtnClicked;
    
    UILabel *instructionField;
    UIButton *saveBtn;
}
@property (nonatomic, strong) UIImageView *blackOverLayView;

-(void)setUp;
-(void)setTarget:(id)target andBackFunc:(SEL)func;

@end
