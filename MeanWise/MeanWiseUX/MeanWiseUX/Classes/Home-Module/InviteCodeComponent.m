//
//  InviteCodeComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 18/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "InviteCodeComponent.h"
#import "Constant.h"
#import "APIManager.h"
#import "FTIndicator.h"

@implementation InviteCodeComponent

-(void)setTarget:(id)target CallBackSuccess:(SEL)func1 andCallBackCance:(SEL)func2;
{
    delegate=target;
    Func_successBtnClicked=func1;
    Func_cancelBtnClicked=func2;

}
-(void)setUp
{
    
    self.backgroundColor=[UIColor clearColor];
    [Constant setUpGradient:self style:202];
    
    
    
    headLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 40)];
    [self addSubview:headLBL];
    headLBL.text=@"One sec.";
    headLBL.textColor=[UIColor whiteColor];
    headLBL.textAlignment=NSTextAlignmentLeft;
    headLBL.font=[UIFont fontWithName:k_fontBold size:28];
    headLBL.center=CGPointMake(self.frame.size.width/2, 140);
    
    
    
    closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(20,35, 40, 40)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [self addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [closeBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-15, -15, -15, -15)];
    closeBtn.center=CGPointMake(self.frame.size.width-25, 25+20);
    
    
    
    submitBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    submitBtn.layer.cornerRadius=20;
    submitBtn.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.6f];
    [submitBtn addTarget:self action:@selector(inviteCodeSubmitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"nextArrow.png"] forState:UIControlStateNormal];
    [self addSubview:submitBtn];
    
    submitBtn.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-30);
    
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2)];
    view.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:view];
    view.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-60);
    
    
    inviteCodeHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, headLBL.frame.origin.y+40, self.frame.size.width-40, 15)];
    [self addSubview:inviteCodeHeadLBL];
    inviteCodeHeadLBL.text=@"Meanwise is currently invite only";
    inviteCodeHeadLBL.textColor=[UIColor whiteColor];
    inviteCodeHeadLBL.textAlignment=NSTextAlignmentLeft;
    inviteCodeHeadLBL.font=[UIFont fontWithName:k_fontRegular size:15];
    
    inviteCodeField=[Constant textField_Style1_WithRect:CGRectMake(20, headLBL.frame.origin.y+40+30, self.frame.size.width-40, 50)];
    [self addSubview:inviteCodeField];
    inviteCodeField.delegate=self;
    
    inviteCodeBaseView=[[UIView alloc] initWithFrame:CGRectMake(20, headLBL.frame.origin.y+40+30+50, self.frame.size.width-40, 1)];
    inviteCodeBaseView.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:inviteCodeBaseView];
    
    descriptionLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, inviteCodeField.frame.origin.y+50+5, self.frame.size.width-40, 40)];
    [self addSubview:descriptionLBL];
    descriptionLBL.textColor=[UIColor colorWithWhite:1 alpha:0.5];
    descriptionLBL.textAlignment=NSTextAlignmentLeft;
    descriptionLBL.font=[UIFont fontWithName:k_fontRegular size:15];
    descriptionLBL.text=@"Paste or type your invitation code here to start posting content";
    descriptionLBL.numberOfLines=2;
    

    
   
    
    [inviteCodeField addTarget:self
                   action:@selector(inviteCodeText:)
         forControlEvents:UIControlEventEditingChanged];

    
    [inviteCodeField becomeFirstResponder];
    submitBtn.hidden=true;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self inviteCodeSubmitBtnClicked:nil];
    return true;
}
-(void)inviteCodeText:(id)sender
{
    if(![inviteCodeField.text isEqualToString:@""])
    {
        submitBtn.hidden=false;
    }
    else
    {
        submitBtn.hidden=true;
    }
    
}


-(void)inviteCodeSubmitBtnClicked:(id)sender
{
    [AnalyticsMXManager PushAnalyticsEventAction:@"Invite Screen-Attempt"];

    [FTIndicator showProgressWithmessage:@"Verifying.." userInteractionEnable:false];
    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestTocheckInviteCode:inviteCodeField.text withDelegate:self andSelector:@selector(responseReceived:)];
    

}
-(void)responseReceived:(APIResponseObj *)obj
{
    [FTIndicator dismissProgress];

    if(obj.statusCode==500)
    {

        [FTIndicator showErrorWithMessage:@"Invalid Code.\nPlease enter a valid invite code and try again."];
        
    }
    else if(obj.statusCode==200)
    {
        [self getUpdatedInfo];

        
        [FTIndicator showSuccessWithMessage:@"Code Applied Successfully"];
    }
    
 
    

}
-(void)getUpdatedInfo
{
    [FTIndicator showProgressWithmessage:@"Please wait.." userInteractionEnable:false];

    APIManager *manager=[[APIManager alloc] init];
    
    
    NSString *token=[UserSession getAccessToken];
    NSString *userId=[UserSession getUserId];
    
    [manager sendRequestForUserData:token andUserId:userId delegate:self andSelector:@selector(userUpdatedInfoReceived:)];

}
-(void)userUpdatedInfoReceived:(APIResponseObj *)responseObj
{
    [FTIndicator dismissProgress];

 
    if(responseObj.statusCode==200)
    {
        NSString *token=[UserSession getAccessToken];

    [UserSession setSessionProfileObj:responseObj.response andAccessToken:token];
    [delegate performSelector:Func_successBtnClicked withObject:nil afterDelay:0.01];
    }

}
-(void)closeBtnClicked:(id)sender
{

    [delegate performSelector:Func_cancelBtnClicked withObject:nil afterDelay:0.01];
    
}

@end
