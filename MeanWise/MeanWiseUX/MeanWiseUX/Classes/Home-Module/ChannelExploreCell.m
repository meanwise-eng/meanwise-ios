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
    
    [self.profileIMGVIEW setUp:string];
    
}
-(id)initWithFrame:(CGRect)frame;
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        
        self.backgroundColor=[UIColor clearColor];
        
        self.bgView=[[UIView alloc] initWithFrame:self.bounds];
        self.bgView.backgroundColor=[UIColor blackColor];
        [self addSubview:self.bgView];
        
        self.profileIMGVIEW=[[UIImageHM alloc] initWithFrame:self.bgView.bounds];
        [self addSubview:self.profileIMGVIEW];
      //  self.profileIMGVIEW.image=[UIImage imageNamed:@"CoverPhoto.jpg"];
        self.profileIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
        self.profileIMGVIEW.clipsToBounds=YES;
        self.profileIMGVIEW.alpha=0.6;
        
        
        self.nameLBL=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, 30)];
        [self addSubview:self.nameLBL];
        self.nameLBL.text=@"Music";
        self.nameLBL.textColor=[UIColor whiteColor];
        self.nameLBL.textAlignment=NSTextAlignmentLeft;
        self.nameLBL.font=[UIFont fontWithName:k_fontBold size:12];
        self.nameLBL.numberOfLines=2;
//        CGSize size=[self.nameLBL sizeThatFits:self.nameLBL.frame.size];
//        self.nameLBL.frame=CGRectMake(5, 5, size.width, size.height);
        
        self.overLayView=[[UIView alloc] initWithFrame:self.bounds];
        self.overLayView.backgroundColor=[UIColor redColor];
        self.overLayView.alpha=0.5;
        [self addSubview:self.overLayView];
        

        
        
       
        
        self.backgroundColor=[UIColor blackColor];
        
    }
    return self;
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if(selected==true)
    {
        
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{

//            self.bgView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height+10);
//
//            self.profileIMGVIEW.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height+10);
//            self.overLayView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height+10);
            
            self.profileIMGVIEW.alpha=0.8;

            self.overLayView.alpha=0;

        } completion:^(BOOL finished) {
            
        }];
       // NSLog(@"selected");
    }
    else
    {
        
        
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
//            self.bgView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//
//            self.profileIMGVIEW.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//            self.overLayView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//
            self.profileIMGVIEW.alpha=0.6;

            self.overLayView.alpha=0.5;
        } completion:^(BOOL finished) {
            
        }];

     //   NSLog(@"deselected");
    }
    
    
}



@end
