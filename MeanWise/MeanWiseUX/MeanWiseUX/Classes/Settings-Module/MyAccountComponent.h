//
//  MyAccountComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SettingComponent.h"
#import "MWNavBar.h"
#import "UIImageHM.h"
#import "ImageCropView.h"

@interface MyAccountComponent : UIView  <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

{
    
    
    UIView *navBar;
    UILabel *navBarTitle;
    
    id delegate;
    SEL backBtnClicked;
    
    UIImageHM *coverPhoto;
    UIImageHM *profilePhoto;
    UIButton *profileChangeBtn;
    UIButton *coverPhotoChangeBtn;
    
    UILabel *fullNameLBL;
    UILabel *userNameLBL;
    
    UIButton *settingBtn;
    
    UITableView *listOfItems;
    
    SettingComponent *settingCompo;
    
    NSArray *items;
    
    UIImagePickerController *picker;
    ImageCropView *imgCropper;
    int imageForCover;
    

}
@property (nonatomic, strong) UIImageView *blackOverLayView;

-(void)setUp;
-(void)setTarget:(id)target andBackFunc:(SEL)func;

@end
