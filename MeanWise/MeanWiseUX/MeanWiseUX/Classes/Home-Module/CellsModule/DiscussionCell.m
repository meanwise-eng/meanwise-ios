//
//  DiscussionCell.m
//  MeanWiseUX
//
//  Created by Hardik on 07/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "DiscussionCell.h"
#import "Constant.h"

@implementation DiscussionCell
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.clipsToBounds=YES;
        self.layer.cornerRadius=2;
        self.backgroundColor=[UIColor whiteColor];
        
        
        self.shortNameLBL=[[UILabel alloc] initWithFrame:CGRectMake(125/2+5+30, 10, 200, 15)];
        [self addSubview:self.shortNameLBL];
        self.shortNameLBL.font=[UIFont fontWithName:k_fontSemiBold size:12];
        
        self.timeLBL=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-60, 10, 50, 15)];
        [self addSubview:self.timeLBL];
        self.timeLBL.font=[UIFont fontWithName:k_fontRegular size:10];
        
        self.postTextLBL=[[UILabel alloc] initWithFrame:CGRectMake(125/2+10, 30, self.frame.size.width-125/2-20, self.frame.size.height-40)];
        [self addSubview:self.postTextLBL];
        self.postTextLBL.font=[UIFont fontWithName:k_fontRegular size:11];
        self.postTextLBL.numberOfLines=2;
        
        
        self.shortNameLBL.textAlignment=NSTextAlignmentLeft;
        self.timeLBL.textAlignment=NSTextAlignmentRight;
        self.postTextLBL.textAlignment=NSTextAlignmentLeft;
        self.timeLBL.textColor=[UIColor grayColor];
        

        
        
        self.profPicImgView=[[UIImageHM alloc] initWithFrame:CGRectMake(125/2+10, 10, 18, 18)];
        [self addSubview:self.profPicImgView];
        self.profPicImgView.layer.cornerRadius=18/2;
        
        self.postImgView=[[UIImageHM alloc] initWithFrame:CGRectMake(0, 0, 125/2, 148/2)];
        [self addSubview:self.postImgView];
        
        
//        self.postTextLBL.backgroundColor=[UIColor yellowColor];
//        self.timeLBL.backgroundColor=[UIColor orangeColor];
//        self.shortNameLBL.backgroundColor=[UIColor purpleColor];
//        self.postImgView.backgroundColor=[UIColor redColor];
//        self.profPicImgView.backgroundColor=[UIColor redColor];
//        self.shortNameLBL.text=@"James L";
//        self.timeLBL.text=@"5min";
//        self.postTextLBL.text=@"The way Jorah looked at Dany at the end gave me chills. He was there when the Dragons were born.";
        
        


    }
    return self;
}
@end
