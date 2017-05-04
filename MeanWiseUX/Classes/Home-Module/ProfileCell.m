//
//  ProfileCell.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "ProfileCell.h"

@implementation ProfileCell

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.clipsToBounds=YES;
      
        
        
        
     
        
        self.profileIMGVIEW=[[ASNetworkImageNode alloc] init];
        [self.profileIMGVIEW setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.profileIMGVIEW.view];
       // self.profileIMGVIEW.image=[UIImage imageNamed:@"CoverPhoto.jpg"];
        self.profileIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
        self.profileIMGVIEW.clipsToBounds=YES;
        self.profileIMGVIEW.placeholderEnabled = YES;
        self.profileIMGVIEW.placeholderFadeDuration = 0.25;
        
        self.shadowImage=[[ASDisplayNode alloc] init];
        [self.shadowImage setFrame:self.profileIMGVIEW.frame];
        self.shadowImage.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"BlackShadow.png"]];
        self.shadowImage.contentMode=UIViewContentModeScaleAspectFill;
        [self addSubview:self.shadowImage.view];
        self.shadowImage.alpha=0.3;
        self.shadowImage.clipsToBounds=YES;

        
        self.nameLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.height-80, self.frame.size.width-80, 80)];
        [self addSubview:self.nameLBL];
        self.nameLBL.text=@"Hi,\nI'm Sam";
        self.nameLBL.textColor=[UIColor whiteColor];
        self.nameLBL.textAlignment=NSTextAlignmentLeft;
        self.nameLBL.font=[UIFont fontWithName:k_fontExtraBold size:25];
        self.nameLBL.numberOfLines=2;
        self.nameLBL.adjustsFontSizeToFitWidth = YES;
        
    }
    return self;
}

-(void)setHiddenCustom:(BOOL)flag
{
    // hiddenView.hidden=!flag;
    self.hidden=flag;
    
}
-(void)setFrameX:(CGRect)frame;
{
    // self.postIMGVIEW.frame=frame;
    //self.shadowImage.frame=frame;
    
    self.profileIMGVIEW.frame=CGRectMake(15, 50, 50, 50);
    self.nameLBL.frame=CGRectMake(30, 40, 200, 25);
    
    
    
    
}

@end
