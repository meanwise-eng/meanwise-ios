//
//  NotificationCell.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
        
        float cellWidth=[UIScreen mainScreen].bounds.size.width;
        
        //        @property (nonatomic, strong) UIImageView *profileIMGVIEW;
        //        @property (nonatomic, strong) UILabel *contactNameLBL;
        //        @property (nonatomic, strong) UILabel *messageSubTextLBL;
        //        @property (nonatomic, strong) UILabel *timeLBL;
        
        self.profileIMGVIEW=[[UIImageHM alloc] initWithFrame:CGRectMake(15, 15, 45, 45)];
        [self addSubview:self.profileIMGVIEW];
        self.profileIMGVIEW.image=[UIImage imageNamed:@"profile2.jpg"];
        self.profileIMGVIEW.contentMode=UIViewContentModeScaleToFill;
        self.profileIMGVIEW.clipsToBounds=YES;
        self.profileIMGVIEW.layer.cornerRadius=45/2;
        
        self.postImageView=[[UIImageHM alloc] initWithFrame:CGRectMake(cellWidth-70, 5, 60, 90)];
        [self addSubview:self.postImageView];
        self.postImageView.image=[UIImage imageNamed:@"pqr1.jpg"];
        self.postImageView.contentMode=UIViewContentModeScaleAspectFit;
        
        
        
        self.contactNameLBL=[[UILabel alloc] initWithFrame:CGRectMake(70, 15, cellWidth-100-70, 20)];
        [self addSubview:self.contactNameLBL];
        self.contactNameLBL.text=@"John Elapse";
        self.contactNameLBL.textColor=[UIColor whiteColor];
        self.contactNameLBL.textAlignment=NSTextAlignmentLeft;
        self.contactNameLBL.font=[UIFont fontWithName:k_fontBold size:13];
        
        self.messageSubTextLBL=[[UILabel alloc] initWithFrame:CGRectMake(70, 35, cellWidth-100-70, 20)];
        [self addSubview:self.messageSubTextLBL];
        self.messageSubTextLBL.text=@"Liked your post!";
        self.messageSubTextLBL.textColor=[UIColor whiteColor];
        self.messageSubTextLBL.textAlignment=NSTextAlignmentLeft;
        self.messageSubTextLBL.font=[UIFont fontWithName:k_fontSemiBold size:13];
        self.messageSubTextLBL.numberOfLines=2;

     
        self.timeLBL=[[UILabel alloc] initWithFrame:CGRectMake(cellWidth-90, 10, 80, 20)];
        [self addSubview:self.timeLBL];
        self.timeLBL.text=@"9:30 AM";
        self.timeLBL.textColor=[UIColor whiteColor];
        self.timeLBL.textAlignment=NSTextAlignmentRight;
        self.timeLBL.font=[UIFont fontWithName:k_fontRegular size:10];
        self.timeLBL.numberOfLines=1;
        

        self.clipsToBounds=YES;
    }
    return self;
}
-(void)setUpObj:(APIObjects_NotificationObj *)obj;
{
    dataObj=obj;
    
    self.contactNameLBL.text=[NSString stringWithFormat:@"%@ %@",obj.notifier_userFirstName,obj.notifier_userLastName];
    
    
    self.timeLBL.frame=CGRectMake(self.contactNameLBL.intrinsicContentSize.width+15+5, 15, 80, 20);
    self.timeLBL.text=obj.created_on;
    
    self.messageSubTextLBL.text=obj.msgText;
    
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
    
    [self.profileIMGVIEW setUp:obj.notifier_userThumbURL];
    
    
    
}

@end
