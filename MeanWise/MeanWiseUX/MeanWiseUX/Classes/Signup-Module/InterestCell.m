//
//  InterestCell.m
//  MeanWiseUX
//
//  Created by Hardik on 05/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "InterestCell.h"

@implementation InterestCell

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.clipsToBounds=YES;
        
        self.bgView=[[UIView alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width-10, self.frame.size.height)];
        [self addSubview:self.bgView];
        self.bgView.backgroundColor=[UIColor blackColor];
        
        
        self.profileIMGVIEW=[[UIImageHM alloc] initWithFrame:self.bgView.frame];
        [self addSubview:self.profileIMGVIEW];
        self.profileIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
        self.profileIMGVIEW.clipsToBounds=YES;
        self.profileIMGVIEW.alpha=0.8;
        
        self.shadowImage=[[UIView alloc] initWithFrame:self.profileIMGVIEW.frame];
        [self addSubview:self.shadowImage];
        self.shadowImage.alpha=0.5;
        self.shadowImage.clipsToBounds=YES;
        self.shadowImage.hidden=true;
        self.shadowImage.userInteractionEnabled=false;
        
        
        self.nameLBL=[[UILabel alloc] initWithFrame:CGRectMake(40, 10, self.frame.size.width-80, 80)];
        [self addSubview:self.nameLBL];
        self.nameLBL.text=@"Hi,\nI'm Sam";
        self.nameLBL.textColor=[UIColor whiteColor];
        self.nameLBL.textAlignment=NSTextAlignmentLeft;
        self.nameLBL.font=[UIFont fontWithName:k_fontBold size:18];
        self.nameLBL.numberOfLines=2;
        
        self.whiteBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        self.whiteBtn.backgroundColor=[UIColor colorWithWhite:1 alpha:0.5];
        self.whiteBtn.clipsToBounds=YES;
        [self.whiteBtn setBackgroundImage:[UIImage imageNamed:@"Checkmark.png"] forState:UIControlStateNormal];

        self.whiteBtn.layer.cornerRadius=35;
        [self addSubview:self.whiteBtn];
        self.whiteBtn.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);

        self.whiteBtn.enabled=false;
        self.whiteBtn.hidden=true;
    }
    return self;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if(selected==true)
    {
        
        NSLog(@"selected");
        self.whiteBtn.hidden=false;
       self.shadowImage.hidden=false;
    }
    else
    {
        
        NSLog(@"deselected");
        self.whiteBtn.hidden=true;
       self.shadowImage.hidden=true;
    }
    
    
}



@end

