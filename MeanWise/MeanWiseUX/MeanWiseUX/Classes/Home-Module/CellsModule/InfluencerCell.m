//
//  InfluencerCell.m
//  MeanWiseUX
//
//  Created by Hardik on 07/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "InfluencerCell.h"
#import "Constant.h"

@implementation InfluencerCell
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.clipsToBounds=YES;
        
        self.firstNameLBL=[[UILabel alloc] initWithFrame:CGRectMake(2, 65, self.frame.size.width-4, 35)];
        [self addSubview:self.firstNameLBL];
        self.firstNameLBL.font=[UIFont fontWithName:k_fontSemiBold size:11];
        
        
        self.firstNameLBL.textAlignment=NSTextAlignmentCenter;
        self.firstNameLBL.textColor=[UIColor whiteColor];
        
        self.backgroundColor=[UIColor colorWithWhite:1 alpha:0.1f];
        self.layer.cornerRadius=3;
        self.layer.borderColor=[UIColor colorWithWhite:1 alpha:0.15f].CGColor;
        self.layer.borderWidth=1;
        

        self.userImageView=[[UIImageHM alloc] initWithFrame:CGRectMake(25/2, 15, 50, 50)];
        [self addSubview:self.userImageView];
        self.userImageView.layer.cornerRadius=25;
        
        self.userImageView.backgroundColor=[UIColor whiteColor];
        self.firstNameLBL.text=@"Hello";
        
       
        /*
        self.profLBL=[[UILabel alloc] initWithFrame:CGRectMake(2, 80, self.frame.size.width-4, 12)];
        [self addSubview:self.profLBL];
        self.profLBL.font=[UIFont fontWithName:k_fontSemiBold size:9];
        self.profLBL.textAlignment=NSTextAlignmentCenter;
        self.profLBL.textColor=[UIColor whiteColor];
        self.profLBL.text=@"Architecture";
         */

        
    }
    return self;
}
@end
