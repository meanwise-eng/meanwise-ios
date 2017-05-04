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
        
        self.layer.cornerRadius = 5.0;
        
        self.bgView=[[UIView alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width-10, self.frame.size.height)];
        [self addSubview:self.bgView];
        self.bgView.backgroundColor=[UIColor blackColor];
        self.bgView.layer.cornerRadius = 5.0;
        
        
        
        self.profileIMGVIEW=[[UIImageHM alloc] initWithFrame:self.bgView.frame];
        [self addSubview:self.profileIMGVIEW];
        self.profileIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
        self.profileIMGVIEW.clipsToBounds=YES;
        self.profileIMGVIEW.alpha=0.8;
        
        self.profileIMGVIEW.layer.cornerRadius = 5.0;
        
        
        self.shadowImage=[[UIView alloc] initWithFrame:self.profileIMGVIEW.frame];
        [self addSubview:self.shadowImage];
        self.shadowImage.alpha=0.5;
        self.shadowImage.clipsToBounds=YES;
        self.shadowImage.hidden=true;
        self.shadowImage.userInteractionEnabled=false;
        
        self.shadowImage.layer.cornerRadius = 5.0;
        
        
        self.nameLBL=[[UILabel alloc] initWithFrame:CGRectMake(40, 10, self.frame.size.width-80, 80)];
        [self addSubview:self.nameLBL];
        self.nameLBL.text=@"Hi,\nI'm Sam";
        self.nameLBL.textColor=[UIColor whiteColor];
        self.nameLBL.textAlignment=NSTextAlignmentLeft;
        self.nameLBL.font=[UIFont fontWithName:k_fontSemiBold size:28];
        self.nameLBL.adjustsFontSizeToFitWidth = YES;
        self.nameLBL.numberOfLines=1;
        
        self.whiteBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        self.whiteBtn.backgroundColor=[UIColor colorWithWhite:1 alpha:0.5];
        self.whiteBtn.clipsToBounds=YES;
        [self.whiteBtn setBackgroundImage:[UIImage imageNamed:@"Checkmark.png"] forState:UIControlStateNormal];
        
        self.blueBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        self.blueBtn.backgroundColor=[UIColor colorWithRed:102/255.0 green:204/255.0 blue:255/255.0 alpha:1.0];
        self.blueBtn.clipsToBounds=YES;
        [self.blueBtn setBackgroundImage:[UIImage imageNamed:@"Checkmark.png"] forState:UIControlStateNormal];
        
        self.blueBtn.layer.cornerRadius=35;
        self.whiteBtn.layer.cornerRadius=35;
        
        [self addSubview:self.whiteBtn];
        [self addSubview:self.blueBtn];
        
        self.whiteBtn.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.blueBtn.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.whiteBtn.enabled=false;
        self.blueBtn.enabled=false;
        
        self.blueBtn.hidden = true;
        
    }
    return self;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if(selected==true)
    {
        
        NSLog(@"selected");
        self.blueBtn.hidden=false;
    }
    else
    {
        
        NSLog(@"deselected");
        self.blueBtn.hidden=true;
    }
    
    
}



@end

