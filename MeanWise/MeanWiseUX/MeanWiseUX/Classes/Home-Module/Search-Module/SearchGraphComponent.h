//
//  SearchGraphComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 02/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircularGraphManager.h"
#import "APIObjects_ProfileObj.h"
#import "UIImageHM.h"

@interface ProfileQuickLookView : UIView
{
    
    UIImageHM *profilePic;
    UIView *popUpView;
    
    UILabel *bioInfoLBL;
    
    
    APIObjects_ProfileObj *obj;
    id target;
    SEL onTapEvent;
    
    CGRect sourceFrame;
    
}
-(void)setUp;
-(void)assignData:(APIObjects_ProfileObj *)dataObj withFrame:(CGRect)frame;
-(void)setTarget:(id)targetReceived onTap:(SEL)func;

@end


@interface SearchGraphComponent : UIView <UITextFieldDelegate>
{

    NSMutableArray *userMainData;
    CircularGraphManager *cControl;
    
    UIButton *searchBtn;

    UIActivityIndicatorView *loaderView;
    UITextField *searchBox;
    
    BOOL isSearchBoxEditMode;
    
    BOOL isSearchBtnInside;
    
    UILabel *statusLabel;
    UIButton *miniStatusLabel;
    UIButton *resetSearch;
    UILabel *errorMessageLBL;
    
    id target;
    SEL onCloseFunc;
    
    UIButton *closeBtn;
    
    int searchType;
    
    ProfileQuickLookView *quickLookView;
    
}
-(void)setUp;
-(void)onCContronScroll:(NSValue *)pointValue;
-(void)setTarget:(id)targetReceived onCloseFunc:(SEL)func;

@end

