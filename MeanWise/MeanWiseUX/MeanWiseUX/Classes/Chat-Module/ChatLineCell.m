//
//  ChatLineCell.m
//  MeanWiseUX
//
//  Created by Hardik on 12/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "ChatLineCell.h"

@implementation ChatLineCell

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.clipsToBounds=YES;
        
        
        self.shadowView=[[UIView alloc] initWithFrame:CGRectMake(25, 5, self.frame.size.width-25, 30)];
        [self addSubview:self.shadowView];
        
        self.profileIMGVIEW=[[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 40, 40)];
        [self addSubview:self.profileIMGVIEW];
        self.profileIMGVIEW.image=[UIImage imageNamed:@"profile2.jpg"];
        self.profileIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
        self.profileIMGVIEW.clipsToBounds=YES;
        self.profileIMGVIEW.layer.cornerRadius=20;
        
        self.nameLBL=[[UILabel alloc] initWithFrame:CGRectMake(55,5, self.frame.size.width*0.6, 100)];
        [self addSubview:self.nameLBL];
        self.nameLBL.text=@"Awesome! How do you do that?";
        self.nameLBL.textColor=[UIColor blackColor];
        
        self.nameLBL.textAlignment=NSTextAlignmentLeft;
        self.nameLBL.font=kk_chatFont;
        self.nameLBL.numberOfLines=0;

        self.shadowView.clipsToBounds=YES;
        self.shadowView.layer.cornerRadius=8;
     
        
        self.timeLBL=[[UILabel alloc] initWithFrame:CGRectMake(55,5, 100, 100)];
        [self addSubview:self.timeLBL];
        self.timeLBL.textColor=[UIColor grayColor];
        self.timeLBL.text=@"Yesterday 3:47 PM";
        self.timeLBL.textAlignment=NSTextAlignmentRight;
        self.timeLBL.font=[UIFont fontWithName:k_fontSemiBold size:8];


    }
    return self;
}
-(void)setSenderValue:(int)Number
{
    senderValue=Number;
    if(Number==0)
    {
        self.shadowView.backgroundColor=kk_chatBG2Color;
        self.profileIMGVIEW.frame=CGRectMake(self.frame.size.width-40-5, 0, 40, 40);
        self.nameLBL.textColor=kk_chatFG2Color;

    }
    else
    {
        self.shadowView.backgroundColor=kk_chatBG1Color;
        self.profileIMGVIEW.frame=CGRectMake(5, 0, 40, 40);
        self.nameLBL.textColor=kk_chatFG1Color;

    }
    
    
}
-(void)setNameLBLText:(NSString *)string
{
    self.nameLBL.text=string;
    CGFloat fixedWidth = self.nameLBL.frame.size.width;
    CGSize newSize = [self.nameLBL sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    
    
    int padding=60;
    
    if(senderValue==1)
    {
        self.nameLBL.frame=CGRectMake(padding,5, self.frame.size.width*0.6, 100);
        
    CGRect newFrame = self.nameLBL.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height+10);
    self.nameLBL.frame = newFrame;

    self.shadowView.frame=CGRectMake(newFrame.origin.x-10, newFrame.origin.y, newFrame.size.width+20, newFrame.size.height);
    }
    else
    {
        self.nameLBL.frame=CGRectMake(self.frame.size.width*0.4-padding,5, self.frame.size.width*0.6, 100);
        
        CGRect newFrame = self.nameLBL.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height+10);
        self.nameLBL.frame = newFrame;
        
        self.shadowView.frame=CGRectMake(newFrame.origin.x-10, newFrame.origin.y, newFrame.size.width+20, newFrame.size.height);
        
    }

    self.timeLBL.frame=CGRectMake(self.shadowView.frame.origin.x+self.shadowView.frame.size.width-100, self.shadowView.frame.origin.y+self.shadowView.frame.size.height, 100, 10);
    
}
@end
