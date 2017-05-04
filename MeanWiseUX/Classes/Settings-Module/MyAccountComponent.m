//
//  MyAccountComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "MessageContactCell.h"
#import "ChatThreadComponent.h"
#import "MyAccountComponent.h"
#import "FriendList.h"
#import "FriendRequestList.h"
#import "TermsOfUse.h"
#import "PrivacyPolicy.h"
#import "UserSession.h"
#import "ViewController.h"
#import "EditInterestsComponent.h"

@implementation MyAccountComponent

-(void)setUp
{
    
    [Constant setStatusBarColorWhite:false];
    
    items=[NSArray arrayWithObjects:@"Friend Requests",@"Manage Interests",@"My Friends",@"Terms of Use",@"Privacy Policy", nil];
    
    self.blackOverLayView=[[UIImageView alloc] initWithFrame:CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    
    self.blackOverLayView.backgroundColor=[UIColor blackColor];
    [self addSubview:self.blackOverLayView];
    self.blackOverLayView.alpha=0;
    
    
    coverPhoto=[[UIImageHM alloc] initWithFrame:self.bounds];
    [self addSubview:coverPhoto];
    coverPhoto.contentMode=UIViewContentModeScaleAspectFill;
    coverPhoto.clipsToBounds=YES;

 
    
    navBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 65)];
    [self addSubview:navBar];
    navBar.backgroundColor=[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
    
    navBarTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 65-20)];
    [navBar addSubview:navBarTitle];
    navBarTitle.text=@"Me";
    navBarTitle.textColor=[UIColor colorWithRed:0.59 green:0.11 blue:1.00 alpha:1.00];
    navBarTitle.textAlignment=NSTextAlignmentCenter;
    navBarTitle.font=[UIFont fontWithName:k_fontSemiBold size:18];
    
    
    
    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 60, 25, 25)];
    [backBtn setShowsTouchWhenHighlighted:YES];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackPlainForNav.png"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    
    backBtn.center=CGPointMake(10+25/2, 20+65/2-10);
    
    
    settingBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 60, 25, 25)];
    [settingBtn setShowsTouchWhenHighlighted:YES];
    [settingBtn addTarget:self action:@selector(settingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"settingsIconForNav.png"] forState:UIControlStateNormal];
    [self addSubview:settingBtn];
    
    settingBtn.center=CGPointMake(self.frame.size.width-10-25/2, 20+65/2-10);
    
    coverPhotoChangeBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-80, 70, 80, 80)];
    [self addSubview:coverPhotoChangeBtn];
    [coverPhotoChangeBtn setImage:[UIImage imageNamed:@"CameraBtn.png"] forState:UIControlStateNormal];
    [coverPhotoChangeBtn addTarget:self action:@selector(coverPhotoChangeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [coverPhotoChangeBtn setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];

    
//    profileChangeBtn=[[UIButton alloc] initWithFrame:profilePhoto.frame];
//    [self addSubview:profileChangeBtn];
//    [profileChangeBtn setImage:[UIImage imageNamed:@"CameraBtn.png"] forState:UIControlStateNormal];
//    [profileChangeBtn addTarget:self action:@selector(profileChangeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [profileChangeBtn setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];

    
    int height=65;
    height=height+40;
    profilePhoto=[[UIImageHM alloc] initWithFrame:CGRectMake(self.frame.size.width/2-40, height, 80, 80)];
    [self addSubview:profilePhoto];
    profilePhoto.contentMode=UIViewContentModeScaleAspectFill;
    profilePhoto.image=[UIImage imageNamed:@"profile6.jpg"];
    profilePhoto.clipsToBounds=YES;
    profilePhoto.layer.cornerRadius=40;
    
    profileChangeBtn=[[UIButton alloc] initWithFrame:profilePhoto.frame];
    [self addSubview:profileChangeBtn];
    [profileChangeBtn setImage:[UIImage imageNamed:@"CameraBtn.png"] forState:UIControlStateNormal];
    [profileChangeBtn addTarget:self action:@selector(profileChangeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [profileChangeBtn setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    
    
    
    height=height+80;
    
    fullNameLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, height, self.frame.size.width, 22)];
    fullNameLBL.text=[UserSession getFullName];
    [self addSubview:fullNameLBL];
    fullNameLBL.textColor=[UIColor whiteColor];
    fullNameLBL.textAlignment=NSTextAlignmentCenter;
    fullNameLBL.font=[UIFont fontWithName:k_fontExtraBold size:18];

    height=height+22;
    
    userNameLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, height, self.frame.size.width, 20)];
    userNameLBL.text=[UserSession getUserName];
    [self addSubview:userNameLBL];
    userNameLBL.textColor=[UIColor whiteColor];
    userNameLBL.textAlignment=NSTextAlignmentCenter;
    userNameLBL.font=[UIFont fontWithName:k_fontBold size:12];
    
   
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = CGRectMake(0,self.frame.size.height-300, self.frame.size.width,300);
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:blurEffectView];
    
    
    listOfItems=[[UITableView alloc] initWithFrame:blurEffectView.frame];
    [self addSubview:listOfItems];
    listOfItems.delegate=self;
    listOfItems.dataSource=self;
    listOfItems.backgroundColor=[UIColor clearColor];
    listOfItems.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    listOfItems.separatorColor=[UIColor colorWithWhite:1 alpha:0];
    listOfItems.scrollEnabled=false;

    
    [coverPhoto setUp:[UserSession getCoverPictureURL]];
    [profilePhoto setUp:[UserSession getBigProfilePictureURL]];
    
    
  //  [self settingBtnClicked:nil];
    // msgContactTable.bounces=false;
    
}
-(void)profileChangeBtnClicked:(id)sender
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    
    [alert addButton:@"Photos" withActionBlock:^{
        // Put your action here
        [self profilePhotoLibrary];
    }];
    
    [alert addButton:@"Camera" withActionBlock:^{
        // Put your action here
        [self profilePhotoCamera];
    }];
    
    
    [alert showAlertInView:self
                 withTitle:@"Profile Photo"
              withSubtitle:nil
           withCustomImage:nil
       withDoneButtonTitle:@"Cancel"
                andButtons:nil];
    
}
-(void)coverPhotoChangeBtnClicked:(id)sender
{
    
    FCAlertView *alert = [[FCAlertView alloc] init];
    
    [alert addButton:@"Photos" withActionBlock:^{
        [self coverPhotoLibrary];
    }];
    
    [alert addButton:@"Camera" withActionBlock:^{
        // Put your action here
        [self coverPhotoCamera];
    }];
    
    
    [alert showAlertInView:self
                 withTitle:@"Cover Photo"
              withSubtitle:nil
           withCustomImage:nil
       withDoneButtonTitle:@"Cancel"
                andButtons:nil];
    
    
    
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
    NSString *path=[Constant FM_saveImageAtDocumentDirectory:image];
    
    if(imageForCover==1)
    {
        [self updateCoverPhoto:path];
        coverPhoto.image=image;
    }
    else
    {
        [self updateProfilePhoto:path];
        profilePhoto.image = image;
    }
    imageForCover=-1;
    
}
-(void)updateProfilePhoto:(NSString *)path
{
    path=[Constant getCompressedPathFromImagePath:path];
    
    UINavigationController *vc=(UINavigationController *)[Constant topMostController];
    ViewController *t=(ViewController *)vc.topViewController;
    [t updateProfilePicture:path];

}
-(void)updateCoverPhoto:(NSString *)path
{
    path=[Constant getCompressedPathFromImagePath:path];
    
    UINavigationController *vc=(UINavigationController *)[Constant topMostController];
    ViewController *t=(ViewController *)vc.topViewController;
    [t updateCoverPicture:path];

    
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

-(void)settingBtnClicked:(id)sender
{
    settingCompo=[[SettingsComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
    [settingCompo setUp];
    settingCompo.blackOverLayView.image=[Constant takeScreenshot];
    settingCompo.blackOverLayView.alpha=1;
    
    [settingCompo setTarget:self andBackFunc:@selector(backFromSetting:)];
    
    [self addSubview:settingCompo];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        settingCompo.frame=self.bounds;
        settingCompo.backgroundColor=[UIColor whiteColor];
    }];
    
    
}
-(void)backFromSetting:(id)sender
{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return listOfItems.frame.size.height/items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"CellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    

    cell.textLabel.text = [[items objectAtIndex:indexPath.row] uppercaseString];
    cell.textLabel.font=[UIFont fontWithName:k_fontExtraBold size:13];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, listOfItems.frame.size.height/items.count-2, tableView.frame.size.width, 2)];
    [cell.contentView addSubview:view];
    view.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.1];
    
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.row==0)
    {
        FriendRequestList *Compo=[[FriendRequestList alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        [Compo setUp];
        Compo.blackOverLayView.image=[Constant takeScreenshot];
        Compo.blackOverLayView.alpha=1;
        
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
    }
    if(indexPath.row==1)
    {
        EditInterestsComponent *Compo=[[EditInterestsComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [Compo setUp];
        Compo.blackOverLayView.image=[Constant takeScreenshot];
        Compo.blackOverLayView.alpha=1;
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
    }
    if(indexPath.row==2)
    {
  FriendList *Compo=[[FriendList alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
    [Compo setUp];
    Compo.blackOverLayView.image=[Constant takeScreenshot];
    Compo.blackOverLayView.alpha=1;
    
    [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
    
    [self addSubview:Compo];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        Compo.frame=self.bounds;
        Compo.backgroundColor=[UIColor whiteColor];
    }];
    }

    if(indexPath.row==3)
    {
        TermsOfUse *Compo=[[TermsOfUse alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        [Compo setUp];
        Compo.blackOverLayView.image=[Constant takeScreenshot];
        Compo.blackOverLayView.alpha=1;
        
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
    }

    if(indexPath.row==4)
    {
        PrivacyPolicy *Compo=[[PrivacyPolicy alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        [Compo setUp];
        Compo.blackOverLayView.image=[Constant takeScreenshot];
        Compo.blackOverLayView.alpha=1;
        
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
    }

    
}


-(void)setTarget:(id)target andBackFunc:(SEL)func
{
    delegate=target;
    backBtnClicked=func;
    
}
-(void)backBtnClicked:(id)sender
{
    [Constant setStatusBarColorWhite:true];
    
    [delegate performSelector:backBtnClicked withObject:nil afterDelay:0.02];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}





@end
