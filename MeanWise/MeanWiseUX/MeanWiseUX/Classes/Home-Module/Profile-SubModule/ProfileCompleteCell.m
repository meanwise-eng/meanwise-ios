//
//  NotificationCell.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "ProfileCompleteCell.h"
#import "Constant.h"

@implementation ProfileCompleteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
        
        self.opaque=YES;
        
        self.clipsToBounds=YES;
        
        self.itemImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 25, 25)];
        [self.contentView addSubview:self.itemImage];
        
        
        self.itemLbl = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 100, 25)];
        self.itemLbl.font = [UIFont fontWithName:k_fontSemiBold size:17.0];
        self.itemLbl.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.itemLbl];
        
        
        self.itemStatus = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width - 50, 10, 25, 25)];
        [self.contentView addSubview:self.itemStatus];
        
        
    }
    return self;
}



@end
