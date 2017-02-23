//
//  CommentCell.m
//  MeanWiseUX
//
//  Created by Hardik on 12/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.clipsToBounds=YES;
        
        
        int padding=70;

        
        self.profileIMGVIEW=[[UIImageHM alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
        [self addSubview:self.profileIMGVIEW];
        self.profileIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
        self.profileIMGVIEW.clipsToBounds=YES;
        self.profileIMGVIEW.layer.cornerRadius=40/2;
        
        self.personNameLBL=[[UILabel alloc] initWithFrame:CGRectMake(padding,5, self.frame.size.width*0.6, 30)];
        [self addSubview:self.personNameLBL];
        self.personNameLBL.text=@"Marry Ideal";
        self.personNameLBL.textColor=[UIColor whiteColor];
        self.personNameLBL.textAlignment=NSTextAlignmentLeft;
        self.personNameLBL.font=[UIFont fontWithName:k_fontBold size:14];
        self.personNameLBL.numberOfLines=0;

        
        
        self.nameLBL=[[UILabel alloc] initWithFrame:CGRectMake(padding,35, self.frame.size.width*0.6, 100)];
        [self addSubview:self.nameLBL];
        self.nameLBL.text=@"Awesome! How do you do that?";
        self.nameLBL.textColor=[UIColor whiteColor];
        
        self.nameLBL.textAlignment=NSTextAlignmentLeft;
        self.nameLBL.font=[UIFont fontWithName:k_fontRegular size:13];
        self.nameLBL.numberOfLines=0;
        
        self.timeLBL=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-50, 5, 40, 30)];
        [self addSubview:self.timeLBL];
        self.timeLBL.text=@"3h";
        self.timeLBL.textColor=[UIColor whiteColor];
        self.timeLBL.textAlignment=NSTextAlignmentRight;
        self.timeLBL.font=[UIFont fontWithName:k_fontBold size:14];
        self.timeLBL.numberOfLines=0;

        
        
        self.separatorView=[[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,1)];
        [self addSubview:self.separatorView];
        self.separatorView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.1];
        
        
      //  self.layer.borderWidth=1;
        
    }
    return self;
}
-(void)setProfileImageURLString:(NSString *)stringPath
{
    [self.profileIMGVIEW setUp:stringPath];
    
}
-(void)setNameLBLText:(NSString *)string
{
    self.nameLBL.text=string;
    CGFloat fixedWidth = self.nameLBL.frame.size.width;
    CGSize newSize = [self.nameLBL sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    
    
    int padding=70;
    
    self.nameLBL.frame=CGRectMake(padding,35, self.frame.size.width*0.6, 100);
        
    CGRect newFrame = self.nameLBL.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        self.nameLBL.frame = newFrame;
        
    
   // self.separatorView.frame=CGRectMake(0,newFrame.size.height-1,self.frame.size.width,1);
    
}



@end

