//
//  MessageContactCell.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "MessageContactCell.h"

@implementation MessageContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
 
//        @property (nonatomic, strong) UIImageView *profileIMGVIEW;
//        @property (nonatomic, strong) UILabel *contactNameLBL;
//        @property (nonatomic, strong) UILabel *messageSubTextLBL;
//        @property (nonatomic, strong) UILabel *timeLBL;

        self.profileIMGVIEW=[[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        [self addSubview:self.profileIMGVIEW];
        self.profileIMGVIEW.image=[UIImage imageNamed:@"profile2.jpg"];
        self.profileIMGVIEW.contentMode=UIViewContentModeScaleToFill;
        self.profileIMGVIEW.clipsToBounds=YES;
        self.profileIMGVIEW.layer.cornerRadius=25;

        self.contactNameLBL=[[UILabel alloc] initWithFrame:CGRectMake(80, 15, 200, 20)];
        [self addSubview:self.contactNameLBL];
        self.contactNameLBL.text=@"John Elapse";
        self.contactNameLBL.textColor=[UIColor blackColor];
        self.contactNameLBL.textAlignment=NSTextAlignmentLeft;
        self.contactNameLBL.font=[UIFont fontWithName:k_fontSemiBold size:15];

        self.messageSubTextLBL=[[UILabel alloc] initWithFrame:CGRectMake(80, 35, 200, 20)];
        [self addSubview:self.messageSubTextLBL];
        self.messageSubTextLBL.text=@"Lorem Ipsum dummy text";
        self.messageSubTextLBL.textColor=[UIColor grayColor];
        self.messageSubTextLBL.textAlignment=NSTextAlignmentLeft;
        self.messageSubTextLBL.font=[UIFont fontWithName:k_fontSemiBold size:13];
        self.messageSubTextLBL.numberOfLines=2;

        
        self.timeLBL=[[UILabel alloc] initWithFrame:CGRectMake(375-90, 10, 80, 20)];
        [self addSubview:self.timeLBL];
        self.timeLBL.text=@"9:30 AM";
        self.timeLBL.textColor=[UIColor grayColor];
        self.timeLBL.textAlignment=NSTextAlignmentRight;
        self.timeLBL.font=[UIFont fontWithName:k_fontSemiBold size:10];
        self.timeLBL.numberOfLines=1;

        
        self.clipsToBounds=YES;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if(selected)
    {
        self.backgroundColor=[UIColor whiteColor];
    }
    else
    {
        self.backgroundColor=[UIColor whiteColor];
    }
    // Configure the view for the selected state
}

@end
