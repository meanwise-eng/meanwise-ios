//
//  ChannelExploreCell.m
//  MeanWiseUX
//
//  Created by Hardik on 02/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "ChannelExploreCell.h"



@implementation ChannelExploreCell

- (void) prepareForReuse
{
    
    self.profileIMGVIEW.image = NULL;
    [super prepareForReuse];
    
}


-(void)setURLString:(NSString *)string
{
    if(![string isEqualToString:@""])
    {
    [self.profileIMGVIEW setUp:string];
        
    }
    else
    {
        [self.profileIMGVIEW setUp:@"ExploreHome.jpg"];
    }
    
}
-(id)initWithFrame:(CGRect)frame;
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        
        
        self.backgroundColor=[UIColor blackColor];

        self.bgView=[[UIView alloc] initWithFrame:self.bounds];
        self.bgView.backgroundColor=[UIColor blackColor];
        [self addSubview:self.bgView];
        
        self.profileIMGVIEW=[[UIImageHM alloc] initWithFrame:self.bgView.bounds];
        [self addSubview:self.profileIMGVIEW];
      //  self.profileIMGVIEW.image=[UIImage imageNamed:@"CoverPhoto.jpg"];
        self.profileIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
        self.profileIMGVIEW.clipsToBounds=YES;
        
        
      
        
        self.nameLBL=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height/2)];
        self.nameLBL.layer.masksToBounds = NO;
        self.nameLBL.clipsToBounds=false;

        [self addSubview:self.nameLBL];
        self.nameLBL.text=@"Music";
        self.nameLBL.textColor=[UIColor whiteColor];
        self.nameLBL.textAlignment=NSTextAlignmentCenter;
        self.nameLBL.font=[UIFont fontWithName:k_fontSemiBold size:13];
        self.nameLBL.numberOfLines=2;
        
        self.nameLBL.layer.shadowOffset=CGSizeMake(0, 0);
        self.nameLBL.layer.shadowColor=[UIColor blackColor].CGColor;
        self.nameLBL.layer.shadowOpacity=0.8f;
        self.nameLBL.layer.shadowRadius=3;
        


        self.clipsToBounds=YES;
        self.layer.cornerRadius=2;
        
        

        self.profileIMGVIEW.alpha=0.5;
        self.nameLBL.alpha=0.5;

        
    }
    return self;
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if(selected==true)
    {
        
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{

            self.profileIMGVIEW.alpha=1;
            self.nameLBL.alpha=1;

        } completion:^(BOOL finished) {
            
        }];
       // NSLog(@"selected");
    }
    else
    {
        
        
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
    
            self.profileIMGVIEW.alpha=0.5;
            self.nameLBL.alpha=0.5;
            
        } completion:^(BOOL finished) {
            
        }];

     //   NSLog(@"deselected");
    }
    
    
}



@end
