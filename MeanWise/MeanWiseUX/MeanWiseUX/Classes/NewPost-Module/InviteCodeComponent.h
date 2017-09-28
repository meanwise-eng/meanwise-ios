//
//  InviteCodeComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 18/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteCodeComponent : UIView <UITextFieldDelegate>
{
    
    UILabel *headLBL;
    UIButton *submitBtn;
    UIButton *closeBtn;
    
    UIView *inviteCodeBaseView;
    UILabel *inviteCodeHeadLBL;
    UITextField *inviteCodeField;
    UILabel *descriptionLBL;

    
    id delegate;
    SEL Func_cancelBtnClicked;
    SEL Func_successBtnClicked;
    

}
-(void)setUp;

-(void)setTarget:(id)target CallBackSuccess:(SEL)func1 andCallBackCance:(SEL)func2;

@end
