//
//  SignUpWizardName.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "SignUpWizardAppearanceComponent.h"
#import "ViewController.h"
#import "FTIndicator.h"

@implementation SignUpWizardAppearanceComponent

-(void)setUp
{
    
    coverphotoPath=nil;
    profilephotoPath=nil;
    
     isProfilePicUploaded=0;
     isCoverPicUploaded=0;
    
    self.backgroundColor=[UIColor clearColor];
    [Constant setUpGradient:self style:8];
    
    [self addSubview:[Constant createProgressSignupViewWithWidth:self.frame.size.width andProgress:0.75 toPercentage:0.9]];

    coverPhoto=[[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:coverPhoto];
    coverPhoto.clipsToBounds=YES;
    coverPhoto.contentMode=UIViewContentModeScaleAspectFill;
    
    coverPhotoOverlay=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:coverPhotoOverlay];
    coverPhotoOverlay.backgroundColor=[UIColor colorWithWhite:0 alpha:0.3];
    coverPhotoOverlay.alpha=0;
    
    headLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 40)];
    [self addSubview:headLBL];
    headLBL.text=@"Appearance";
    headLBL.textColor=[UIColor whiteColor];
    headLBL.textAlignment=NSTextAlignmentLeft;
    headLBL.font=[UIFont fontWithName:k_fontAvenirNextHeavy size:28];
    headLBL.center=CGPointMake(self.frame.size.width/2, 140);
    
    subHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 60)];
    [self addSubview:subHeadLBL];
    subHeadLBL.numberOfLines=2;
    subHeadLBL.text=@"Make yourself look cooler to others.";
    subHeadLBL.textColor=[UIColor whiteColor];
    subHeadLBL.textAlignment=NSTextAlignmentLeft;
    subHeadLBL.font=[UIFont fontWithName:k_fontSemiBold size:15];
    subHeadLBL.center=CGPointMake(self.frame.size.width/2, 180);
    
    
    
    backBtn=[[UIButton alloc] initWithFrame:CGRectMake(20,35, 23*1.2, 16*1.2)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackButton.png"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-15, -15, -15, -15)];

    
    
    
    
    nextBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    nextBtn.layer.cornerRadius=20;
    nextBtn.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.6f];
    [nextBtn addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"nextArrow.png"] forState:UIControlStateNormal];
    [self addSubview:nextBtn];
    
    nextBtn.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-30);
    nextBtn.hidden=true;
    
    usernameHeadLBL=[[TTTAttributedLabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 20)];
    [self addSubview:usernameHeadLBL];
    usernameHeadLBL.text=@"USERNAME (Min 6 characters, without spaces)";
    usernameHeadLBL.textColor=[UIColor whiteColor];
    usernameHeadLBL.textAlignment=NSTextAlignmentLeft;
    usernameHeadLBL.font=[UIFont fontWithName:k_fontBold size:15];
    usernameHeadLBL.center=CGPointMake(self.frame.size.width/2, 230);
    
    NSString *text = @"USERNAME  (Min 6 characters, without spaces)";
    [usernameHeadLBL setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
     {
         NSRange boldRange = [[mutableAttributedString string] rangeOfString:@"(Min 6 characters, without spaces)" options:NSCaseInsensitiveSearch];
         
         [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:[UIColor colorWithWhite:1.0f alpha:0.8f] range:boldRange];
         
         UIFont *boldSystemFont = [UIFont fontWithName:k_fontBold size:12];
         CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
         if (font) {
             [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
             
             
             CFRelease(font);
         }
         
         return mutableAttributedString;
     }];
    

    
    
    usernameBaseView=[[UIView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 1)];
    usernameBaseView.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:usernameBaseView];
    usernameBaseView.center=CGPointMake(self.frame.size.width/2, 300);

    
    usernameField=[Constant textField_Style1_WithRect:CGRectMake(20, 0, self.frame.size.width-40, 50)];
    [self addSubview:usernameField];
    usernameField.center=CGPointMake(self.frame.size.width/2, 230+45);
    usernameField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    usernameField.autocorrectionType=UITextAutocorrectionTypeNo;

    userNameValidationSign=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:userNameValidationSign];
    userNameValidationSign.center=CGPointMake(self.frame.size.width-40, 230+45);
    userNameValidationSign.image=[UIImage imageNamed:@"Checkmark.png"];
    userNameValidationSign.hidden=true;
    
    usernameValidationLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 20)];
    [self addSubview:usernameValidationLBL];
    usernameValidationLBL.center=CGPointMake(self.frame.size.width/2, 230+15);
    usernameValidationLBL.font=[UIFont fontWithName:k_fontExtraBold size:12];
    usernameValidationLBL.textAlignment=NSTextAlignmentLeft;
    usernameValidationLBL.text=@"Username already in use.";
    usernameValidationLBL.textColor=[UIColor yellowColor];
    usernameValidationLBL.hidden=true;

    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2)];
    view.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:view];
    view.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-60);
    
    
    
    emailHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 15)];
    [self addSubview:emailHeadLBL];
    emailHeadLBL.text=@"PROFILE PHOTO";
    emailHeadLBL.textColor=[UIColor whiteColor];
    emailHeadLBL.textAlignment=NSTextAlignmentLeft;
    emailHeadLBL.font=[UIFont fontWithName:k_fontBold size:15];
    emailHeadLBL.center=CGPointMake(self.frame.size.width/2, 230+100);
    
    
    passHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 15)];
    [self addSubview:passHeadLBL];
    passHeadLBL.text=@"COVER PHOTO";
    passHeadLBL.textColor=[UIColor whiteColor];
    passHeadLBL.textAlignment=NSTextAlignmentLeft;
    passHeadLBL.font=[UIFont fontWithName:k_fontBold size:15];
    passHeadLBL.center=CGPointMake(self.frame.size.width/2, 350+100);
    
    UIButton *cameraBtn1=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:cameraBtn1];
    [cameraBtn1 setBackgroundImage:[UIImage imageNamed:@"CameraBtn.png"] forState:UIControlStateNormal];
    
    UIButton *cameraBtn2=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:cameraBtn2];
    [cameraBtn2 setBackgroundImage:[UIImage imageNamed:@"CameraBtn.png"] forState:UIControlStateNormal];
    
    
    UIButton *uploadBtn1=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:uploadBtn1];
    [uploadBtn1 setBackgroundImage:[UIImage imageNamed:@"UploadBtn.png"] forState:UIControlStateNormal];
    
    UIButton *uploadBtn2=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:uploadBtn2];
    [uploadBtn2 setBackgroundImage:[UIImage imageNamed:@"UploadBtn.png"] forState:UIControlStateNormal];
    
    cameraBtn1.center=CGPointMake(40, 230+45+100);
    uploadBtn1.center=CGPointMake(40+80, 230+45+100);
    cameraBtn2.center=CGPointMake(40, 350+45+100);
    uploadBtn2.center=CGPointMake(40+80, 350+45+100);
    
    profilePhoto=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [self addSubview:profilePhoto];
    profilePhoto.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.2f];
    profilePhoto.layer.cornerRadius=40;
    profilePhoto.clipsToBounds=YES;
    profilePhoto.contentMode=UIViewContentModeScaleAspectFit;
    profilePhoto.center=CGPointMake(self.frame.size.width-50, 230+45+100);

    
    [uploadBtn1 addTarget:self action:@selector(profilePhotoLibrary) forControlEvents:UIControlEventTouchUpInside];
    [uploadBtn2 addTarget:self action:@selector(coverPhotoLibrary) forControlEvents:UIControlEventTouchUpInside];

    [cameraBtn1 addTarget:self action:@selector(profilePhotoCamera) forControlEvents:UIControlEventTouchUpInside];
    [cameraBtn2 addTarget:self action:@selector(coverPhotoCamera) forControlEvents:UIControlEventTouchUpInside];

    
    
    [usernameField addTarget:self
                   action:@selector(userNameValidation:)
         forControlEvents:UIControlEventEditingChanged];

    imageForCover=-1;
     
    
}
-(void)userNameValidation:(id)sender
{
    
    int valid=1;
    if([usernameField.text isEqualToString:@""])
    {
        valid=0;
    }
    if([usernameField.text containsString:@" "])
    {
        valid=0;
    }
    if([usernameField.text length]<6)
    {
        valid=0;
    }
    
    
    
    if(valid==1)
    {
        userNameValidationSign.hidden=false;
    }
    else
    {
        userNameValidationSign.hidden=true;

    }
    
    [self updateValidation];
}

-(void)coverPhotoLibrary
{
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imageForCover=1;

    UIViewController *vc = self.window.rootViewController;
    
    
    [vc presentViewController:picker animated:YES completion:nil];

}
-(void)coverPhotoCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        [Constant okAlert:@"Sorry" withSubTitle:@"Camera not available" onView:self andStatus:-1];
    }
    else
    {
        imageForCover=1;

        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        UIViewController *vc = self.window.rootViewController;
        
        
        [vc presentViewController:picker animated:YES completion:nil];
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self cropImage:info];
//    if(picker1.allowsEditing==false)
//    {
//    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
//    coverPhoto.image = chosenImage;
//        coverPhotoOverlay.alpha=0.3;
//    }
//    else
//    {
//        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//        profilePhoto.image = chosenImage;
//
//    }
    [picker1 dismissViewControllerAnimated:YES completion:NULL];
    
}
-(void)cropImage:(NSDictionary *)info
{
    
    
    imgCropper=[[ImageCropView alloc] initWithFrame:self.bounds];
    [self addSubview:imgCropper];
    
    if(imageForCover==1)
    {
        [imgCropper setUp:self.frame.size.height/self.frame.size.width andRect:self.bounds];
    }
    else if(imageForCover==0)
    {
        [imgCropper setUp:1 andRect:profilePhoto.frame] ;

    }
    [imgCropper setUpImage:info[UIImagePickerControllerOriginalImage]];
    [imgCropper setTarget:self andDoneBtn:@selector(cropFinished:) andCancelBtn:nil];
    
}
-(void)cropFinished:(UIImage *)image
{
    if(imageForCover==1)
    {
        isCoverPicUploaded=1;
        
        coverPhoto.image=image;
        coverPhotoOverlay.alpha=0.3;
        
        coverphotoPath=[Constant FM_saveImageAtDocumentDirectory:image WithFileName:@"coverphoto.png"];
        

    }
    else
    {
        isProfilePicUploaded=1;
        profilePhoto.image = image;
       profilephotoPath=[Constant FM_saveImageAtDocumentDirectory:image WithFileName:@"profilephoto.png"];
        
    }
    imageForCover=-1;
    
    
    
    [self updateValidation];
}
-(void)updateValidation
{
    
    int valid=1;
    if([usernameField.text isEqualToString:@""])
    {
        valid=0;
    }
    if([usernameField.text containsString:@" "])
    {
        valid=0;
    }
    if([usernameField.text length]<6)
    {
        valid=0;
    }
    
    
    if(isCoverPicUploaded==1 && isProfilePicUploaded==1 && valid==1)
    {
        nextBtn.hidden=false;
    }
    else
    {
        nextBtn.hidden=true;
    }
}

-(void)profilePhotoCamera
{
    imageForCover=0;

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

    [Constant okAlert:@"Sorry" withSubTitle:@"Camera not available" onView:self andStatus:-1];
        
    }
    else {
        
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.title=@"Profile Photo";
        UIViewController *vc = self.window.rootViewController;
        
        
        [vc presentViewController:picker animated:YES completion:nil];
        
    }
}
-(void)profilePhotoLibrary
{
    imageForCover=0;

    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.title=@"Profile Photo";
    UIViewController *vc = self.window.rootViewController;

    
    [vc presentViewController:picker animated:YES completion:nil];
}

-(void)setTarget:(id)target andFunc1:(SEL)func;
{
    delegate=target;
    Func_backBtnClicked=func;
    
}
-(void)setTarget:(id)target andFunc2:(SEL)func;
{
    delegate=target;
    Func_nextBtnClicked=func;
    
}
-(void)nextBtnClicked:(id)sender
{

    [usernameField resignFirstResponder];
    
        nextBtn.enabled=false;
        
        APIManager *manager=[[APIManager alloc] init];
        [manager sendRequestTocheckIfUserExistWithUsername:[usernameField.text lowercaseString] withDelegate:self andSelector:@selector(performNextIfPossible:)];
        

    [FTIndicator showProgressWithmessage:@"Please wait.." userInteractionEnable:FALSE];


}
-(void)performNextIfPossible:(APIResponseObj *)responseObj
{
    nextBtn.enabled=true;
    
    [FTIndicator dismissProgress];
    
    NSString *string=[responseObj.response valueForKey:@"exists"];
    if([[string lowercaseString] isEqualToString:@"true"])
    {
        NSLog(@"User Already Exists");
        
        
        usernameValidationLBL.hidden=false;
        [usernameField becomeFirstResponder];
        usernameValidationLBL.text=[NSString stringWithFormat:@"'%@' already in use.",[usernameField.text lowercaseString]];
    }
    else
    {
        [self GoforSignup];
    }

}

-(void)GoforSignup
{
    [usernameField resignFirstResponder];
    
    
    [DataSession sharedInstance].signupObject.username=usernameField.text;
    [DataSession sharedInstance].signupObject.profile_photo=profilephotoPath;
    [DataSession sharedInstance].signupObject.cover_photo=coverphotoPath;
    
    screen=[[SignUpTransitionScreen alloc] initWithFrame:self.bounds];
    [self addSubview:screen];
    [screen setUpForSignup:self andFunc1:@selector(SignupSuccessfully:) andFunc2:@selector(SignupFailed:)];
}
-(void)SignupSuccessfully:(id)sender
{
    [delegate performSelector:Func_nextBtnClicked withObject:nil afterDelay:0.01];

}
-(void)SignupFailed:(id)sender
{
    [screen removeFromSuperview];
}

-(void)backBtnClicked:(id)sender
{
    [delegate performSelector:Func_backBtnClicked withObject:nil afterDelay:0.01];

}

-(void)forgetPassBtnClicked:(id)sender
{
    
}

@end
