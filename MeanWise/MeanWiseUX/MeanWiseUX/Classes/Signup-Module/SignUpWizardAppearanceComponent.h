//
//  SignUpWizardAppearanceComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "ImageCropView.h"
#import "DataSession.h"
#import "SignUpTransitionScreen.h"

@interface SignUpWizardAppearanceComponent : UIView <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    SignUpTransitionScreen *screen;
    UILabel *usernameHeadLBL;
    UIView *usernameBaseView;
    UITextField *usernameField;
    UILabel *usernameValidationLBL;
    
    UIButton *nextBtn;
    
    UILabel *headLBL,*subHeadLBL;
    UIButton *forgetPassBtn;
    UIButton *backBtn;
    
    UILabel *passHeadLBL,*bioHeadLBL;
    UIView *passBaseView;
    UIView *emailBaseView,*bioBaseView;
    UILabel *emailHeadLBL;
    
    id delegate;
    SEL Func_backBtnClicked;
    SEL Func_nextBtnClicked;
    
    UIImageView *profilePhoto;
    UIImageView *coverPhoto;

    UIImagePickerController *picker;
    ImageCropView *imgCropper;
    int imageForCover;

    UIView *coverPhotoOverlay;
    
    int isProfilePicUploaded;
    int isCoverPicUploaded;
    
    UIImageView *userNameValidationSign;
    
    NSString *coverphotoPath;
    NSString *profilephotoPath;
}

-(void)setUp;
-(void)setTarget:(id)target andFunc1:(SEL)func;
-(void)setTarget:(id)target andFunc2:(SEL)func;

@end

/*
 
 SignUpWizardAppearanceComponent *c=[[SignUpWizardAppearanceComponent alloc] initWithFrame:self.view.bounds];
 [self.view addSubview:c];
 [c setUp];
 
 */
