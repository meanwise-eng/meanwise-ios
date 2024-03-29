//
//  FriendListCell.m
//  MeanWiseUX
//
//  Created by Hardik on 17/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "FriendListCell.h"
#import "ProfileWindowControl.h"
#import "GUIScaleManager.h"

@implementation FriendListCell

-(void)setDataDict:(APIObjects_ProfileObj *)obj
{
    
    
    dataObj=obj;
    
    
    NSString *personName=[NSString stringWithFormat:@"%@ %@",obj.first_name,obj.last_name];
    NSString *userName=[NSString stringWithFormat:@" @%@",obj.username];
  //  NSString *finalString=[NSString stringWithFormat:@"%@ %@",personName,userName];
    

    
    NSMutableAttributedString *string=[[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *temp1=[[NSMutableAttributedString alloc] initWithString:personName];
    [temp1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:k_fontRegular size:14] range:NSMakeRange(0, personName.length)];
    [temp1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, personName.length)];

    
    NSMutableAttributedString *temp2=[[NSMutableAttributedString alloc] initWithString:userName];
    [temp2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:k_fontRegular size:12] range:NSMakeRange(0, userName.length)];
    
    [temp2 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, userName.length)];

    [string appendAttributedString:temp1];
    
    [string appendAttributedString:temp2];
    
    
    [self.profileIMGVIEW setUp:obj.profile_photo_small];
    
    self.contactNameLBL.attributedText=string;
//    self.contactNameLBL.text=[NSString stringWithFormat:@"%@ %@",obj.first_name,obj.last_name];

    self.proType.text=obj.profession_text;
    [self.profileIMGVIEW setTarget:self OnClickFunc:@selector(profileBtnClicked:) WithObj:[self userDictDetail:dataObj]];


}
-(NSDictionary *)userDictDetail:(APIObjects_ProfileObj *)feedData
{
    NSDictionary *dict=@{@"cover_photo":feedData.cover_photo,@"user_id":feedData.userId};
    
    return dict;
}
-(void)profileBtnClicked:(NSDictionary *)userDict
{
    NSString *screenIdentifier=@"FLIST";
    
    if(RX_isiPhone4Res)
    {
        return;
    }
    
    [AnalyticsMXManager PushAnalyticsEventAction:@"Profile screen from Friend list"];

    
    if(![screenIdentifier isEqualToString:@"PROFILE"] && ![screenIdentifier isEqualToString:@"DEEPLINKPOST"] && ![screenIdentifier isEqualToString:@"NOTIFICATIONPOST"])
    {
        if([screenIdentifier isEqualToString:@"EXPLORE"])
        {
            [HMPlayerManager sharedInstance].Explore_isPaused=true;
        }
        else if([screenIdentifier isEqualToString:@"HOME"])
        {
            [HMPlayerManager sharedInstance].Home_isPaused=true;
        }
        
        //    [HMPlayerManager sharedInstance].All_isPaused=true;
        
        CGRect rect=[self.profileIMGVIEW convertRect:self.profileIMGVIEW.superview.frame fromView:self];
        
        CGPoint p=[self.profileIMGVIEW convertPoint:self.profileIMGVIEW.center toView:nil];
        rect=CGRectMake(p.x-self.profileIMGVIEW.bounds.size.width/2, p.y-self.profileIMGVIEW.bounds.size.height/2, self.profileIMGVIEW.bounds.size.width, self.profileIMGVIEW.bounds.size.width);

        
        
        
        ProfileWindowControl *control=[[ProfileWindowControl alloc] init];
        [control setUp:userDict andSourceFrame:rect];
        [control setTarget:self onClose:@selector(ProfilecloseBtnClicked:)];

        
        NSLog(@"%@",userDict);
    }
    
}
-(void)ProfilecloseBtnClicked:(id)sender
{
    NSString *screenIdentifier=@"FLIST";
    
    if([screenIdentifier isEqualToString:@"EXPLORE"])
    {
        [HMPlayerManager sharedInstance].Explore_isPaused=false;
    }
    else if([screenIdentifier isEqualToString:@"HOME"])
    {
        [HMPlayerManager sharedInstance].Home_isPaused=false;
    }
    
    //    [HMPlayerManager sharedInstance].All_isPaused=false;
    
    NSLog(@"closed");
    
}


-(void)setTargetCaller:(id)targetReceived
{
     targetCaller=targetReceived;
}
-(void)setCallBackForAccept:(SEL)func
{
    onAcceptCallBack=func;

}
-(void)setCallBackForReject:(SEL)func
{
    onCancelCallBack=func;

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //        @property (nonatomic, strong) UIImageView *profileIMGVIEW;
        //        @property (nonatomic, strong) UILabel *contactNameLBL;
        //        @property (nonatomic, strong) UILabel *messageSubTextLBL;
        //        @property (nonatomic, strong) UILabel *timeLBL;
        
        self.profileIMGVIEW=[[UIImageHM alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        [self addSubview:self.profileIMGVIEW];
        self.profileIMGVIEW.contentMode=UIViewContentModeScaleToFill;
        self.profileIMGVIEW.clipsToBounds=YES;
        self.profileIMGVIEW.layer.cornerRadius=25;
        
        self.contactNameLBL=[[UILabel alloc] initWithFrame:CGRectMake(80, 15, 200, 25)];
        [self addSubview:self.contactNameLBL];
        self.contactNameLBL.text=@"John Elapse";
        self.contactNameLBL.textColor=[UIColor blackColor];
        self.contactNameLBL.textAlignment=NSTextAlignmentLeft;
        self.contactNameLBL.font=[UIFont fontWithName:k_fontRegular size:15];
      
      
        self.proType=[[UILabel alloc] initWithFrame:CGRectMake(80, 40, 200, 25)];
        [self addSubview:self.proType];
        self.proType.text=@"John Elapse";
        self.proType.textColor=[UIColor blackColor];
        self.proType.textAlignment=NSTextAlignmentLeft;
        self.proType.font=[UIFont fontWithName:k_fontRegular size:12];
        
        
        self.acceptBtn=[[UIButton alloc] initWithFrame:CGRectMake(80, 70, 80, 30)];
        [self.acceptBtn setTitle:@"Accept" forState:UIControlStateNormal];

        
        self.rejectBtn=[[UIButton alloc] initWithFrame:CGRectMake(170, 70, 80, 30)];
        [self.rejectBtn setTitle:@"Reject" forState:UIControlStateNormal];

        
        [self.acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.acceptBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:14];
        [self.rejectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.rejectBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:14];

        
        [self.acceptBtn addTarget:self action:@selector(FriendShipAccepted:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.rejectBtn addTarget:self action:@selector(FriendShipRejected:) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.acceptBtn.layer.cornerRadius=15;
        self.rejectBtn.layer.cornerRadius=15;
        self.acceptBtn.clipsToBounds=YES;
        self.rejectBtn.clipsToBounds=YES;
        
        self.acceptBtn.backgroundColor=[UIColor colorWithRed:0.18 green:0.80 blue:0.44 alpha:1.00];
        self.rejectBtn.backgroundColor=[UIColor colorWithRed:0.91 green:0.30 blue:0.24 alpha:1.00];

        [self addSubview:self.acceptBtn];
        [self addSubview:self.rejectBtn];
        
        self.acceptBtn.hidden=true;
        self.rejectBtn.hidden=true;
        

        
        self.clipsToBounds=YES;
    }
    return self;
}

-(void)FriendShipAccepted:(id)sender
{
    [targetCaller performSelector:onAcceptCallBack withObject:dataObj.userId afterDelay:0.01];
    NSLog(@"Accepted");
    
}
-(void)FriendShipRejected:(id)sender
{
    [targetCaller performSelector:onCancelCallBack withObject:dataObj.userId afterDelay:0.01];

    NSLog(@"Rejected");
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
