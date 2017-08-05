//
//  NotificationCell.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "NotificationCell.h"
#import "GUIScaleManager.h"
#import "MiniProfileComponent.h"

@implementation NotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
        
        self.opaque=YES;
        float cellWidth=RX_mainScreenBounds.size.width;
        
        //        @property (nonatomic, strong) UIImageView *profileIMGVIEW;
        //        @property (nonatomic, strong) UILabel *contactNameLBL;
        //        @property (nonatomic, strong) UILabel *messageSubTextLBL;
        //        @property (nonatomic, strong) UILabel *timeLBL;
        
        self.profileIMGVIEW=[[UIImageHM alloc] initWithFrame:CGRectMake(15, 15, 45, 45)];
        [self.contentView addSubview:self.profileIMGVIEW];
        self.profileIMGVIEW.image=[UIImage imageNamed:@"profile2.jpg"];
        self.profileIMGVIEW.contentMode=UIViewContentModeScaleToFill;
        self.profileIMGVIEW.clipsToBounds=YES;
        self.profileIMGVIEW.layer.cornerRadius=45/2;
        
        self.postImageView=[[UIImageHM alloc] initWithFrame:CGRectMake(cellWidth-70, 5, 60, 90)];
        [self.contentView addSubview:self.postImageView];
        self.postImageView.image=[UIImage imageNamed:@"pqr1.jpg"];
        self.postImageView.contentMode=UIViewContentModeScaleAspectFill;
        
        
        self.contactNameLBL=[[UILabel alloc] initWithFrame:CGRectMake(70, 15, cellWidth-100-70, 20)];
        [self.contentView addSubview:self.contactNameLBL];
        self.contactNameLBL.text=@"John Elapse";
        self.contactNameLBL.textColor=[UIColor whiteColor];
        self.contactNameLBL.textAlignment=NSTextAlignmentLeft;
        self.contactNameLBL.font=[UIFont fontWithName:k_fontBold size:13];
        
        self.messageSubTextLBL=[[UILabel alloc] initWithFrame:CGRectMake(70, 35, cellWidth-100-70, 40)];
        [self.contentView addSubview:self.messageSubTextLBL];
        self.messageSubTextLBL.text=@"Liked your post!";
        self.messageSubTextLBL.textColor=[UIColor whiteColor];
        self.messageSubTextLBL.textAlignment=NSTextAlignmentLeft;
        self.messageSubTextLBL.font=[UIFont fontWithName:k_fontSemiBold size:13];
        self.messageSubTextLBL.numberOfLines=2;

     
        self.timeLBL=[[UILabel alloc] initWithFrame:CGRectMake(cellWidth-90, 10, 80, 20)];
        [self.contentView addSubview:self.timeLBL];
        self.timeLBL.text=@"9:30 AM";
        self.timeLBL.textColor=[UIColor whiteColor];
        self.timeLBL.textAlignment=NSTextAlignmentRight;
        self.timeLBL.font=[UIFont fontWithName:k_fontRegular size:10];
        self.timeLBL.numberOfLines=1;
        

        self.postImageView.opaque=true;
        self.timeLBL.opaque=true;
        self.messageSubTextLBL.opaque=true;
        self.contactNameLBL.opaque=true;
        self.profileIMGVIEW.opaque=true;
        
        //@property (nonatomic, strong) UIButton *acceptBtn;
//        @property (nonatomic, strong) UIButton *cancelBtn;

        self.acceptBtn=[[UIButton alloc] initWithFrame:CGRectMake(cellWidth-50, 15, 36, 36)];
        [self addSubview:self.acceptBtn];
        self.acceptBtn.layer.borderWidth=1;
        self.acceptBtn.layer.borderColor=[UIColor colorWithRed:0.27 green:0.80 blue:1.00 alpha:1.00].CGColor;
        self.acceptBtn.backgroundColor=[UIColor colorWithRed:0.27 green:0.80 blue:1.00 alpha:1.00];
        self.acceptBtn.layer.cornerRadius=18;
        [self.acceptBtn setImage:[UIImage imageNamed:@"2_correctBtn.png"] forState:UIControlStateNormal];
        [self.acceptBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];

        self.cancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(cellWidth-100,15, 36, 36)];
        [self addSubview:self.cancelBtn];
        self.cancelBtn.layer.borderWidth=1;
        self.cancelBtn.layer.borderColor=[UIColor whiteColor].CGColor;
        self.cancelBtn.backgroundColor=[UIColor clearColor];
        self.cancelBtn.layer.cornerRadius=18;
        [self.cancelBtn setImage:[UIImage imageNamed:@"2_cancelBtn.png"] forState:UIControlStateNormal];

        [self.cancelBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        
        [self.acceptBtn addTarget:self action:@selector(acceptFriendAPIcall:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.cancelBtn addTarget:self action:@selector(rejectFriendAPIcall:) forControlEvents:UIControlEventTouchUpInside];

        
        self.cancelBtn.hidden=true;
        self.acceptBtn.hidden=true;
        
        
        self.clipsToBounds=YES;
    }
    return self;
}
-(void)acceptFriendAPIcall:(id)sender
{
    
}
-(void)rejectFriendAPIcall:(id)sender
{
    
}

-(void)setUpObj:(APIObjects_NotificationObj *)obj;
{
    dataObj=obj;
    float cellWidth=RX_mainScreenBounds.size.width;

//
//    if(obj.notificationIsNew.intValue==1)
//    {
//        self.contentView.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5f];
//        
//        [UIView animateWithDuration:1.0f animations:^{
//            self.contentView.backgroundColor=[UIColor clearColor];
// 
//        }];
//    }
//    else
//    {
//        self.contentView.backgroundColor=[UIColor clearColor];
//    }
    
    self.contactNameLBL.text=[NSString stringWithFormat:@"%@ %@",obj.notifier_userFirstName,obj.notifier_userLastName];
    
    
    self.timeLBL.frame=CGRectMake(self.contactNameLBL.intrinsicContentSize.width+15+5, 15, 80, 20);
    self.timeLBL.text=obj.created_on;
    
    self.messageSubTextLBL.text=obj.msgText;
    
  
    
    if([obj.notification_type isEqualToString:@"FriendRequestAccepted"] || [obj.notification_type isEqualToString:@"FriendRequestReceived"])
    {
        
        self.postImageView.hidden=true;
        [self.postImageView clearImageAll];
        
//        if([obj.notification_type isEqualToString:@"FriendRequestReceived"])
//        {
//            self.cancelBtn.hidden=false;
//            self.acceptBtn.hidden=false;
//            
//        }
//        else
//        {
//            self.cancelBtn.hidden=true;
//            self.acceptBtn.hidden=true;
//            
//        }

    }
    else
    {
        if([obj.postType isEqualToString:@"1"])
        {
            self.postImageView.hidden=true;
            [self.postImageView clearImageAll];
            
        }
        else
        {
            self.postImageView.hidden=false;
            [self.postImageView setUp:obj.postThumbURL];
            
        }
    }
    
    [self.profileIMGVIEW setUp:obj.notifier_userThumbURL];
    
    
    CGRect rect=self.messageSubTextLBL.frame;
    
    int height=[self getLabelHeight:self.messageSubTextLBL];
    
    if(height>40)
    {
        height=40;
    }
    
    self.messageSubTextLBL.frame=CGRectMake(rect.origin.x, rect.origin.y, rect.size.width,height);
    [self.profileIMGVIEW setTarget:self OnClickFunc:@selector(profileBtnClicked:) WithObj:[self userDictDetail:dataObj]];

}
-(NSDictionary *)userDictDetail:(APIObjects_NotificationObj *)feedData
{
    
    NSString *userCover;
    
    if(feedData.notifier_userCoverURL==nil)
    {
        userCover=@"";
    }
    

    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          feedData.notifier_userFirstName,@"user_firstname",
                          feedData.notifier_userLastName,@"user_lastname",
                          @"",@"user_profession",
                          feedData.notifier_userThumbURL,@"user_profile_photo_small",
                          feedData.notifier_userId,@"user_id",
                          userCover,@"user_cover_photo",
                          
                          nil];

//    NSDictionary *dict=@{
//                         @"user_firstname":feedData.notifier_userFirstName,
//                         @"user_lastname":feedData.notifier_userLastName,
//                         @"user_profile_photo_small":feedData.notifier_userThumbURL,
//                         @"user_profession":@"",
//                         @"user_id":feedData.notifier_userId,
//                         @"user_cover_photo":userCover,
//                         };
    
    return dict;
}

-(void)profileBtnClicked:(NSDictionary *)userDict
{
    [AnalyticsMXManager PushAnalyticsEventAction:@"Profile screen from Notifications"];

    NSString *screenIdentifier=@"FLIST";
    
    if(RX_isiPhone4Res)
    {
        return;
    }
    
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
        
        
        // CGRect rect=CGRectMake(0, RX_mainScreenBounds.size.height, RX_mainScreenBounds.size.width, 0);
        MiniProfileComponent *compo=[[MiniProfileComponent alloc] initWithFrame:rect];
        [compo setUp:userDict];
        [compo setTarget:self onClose:@selector(ProfilecloseBtnClicked:)];
        
        
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

- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}


@end
