//
//  NewPostStoryCell.m
//  MeanWiseUX
//
//  Created by Mohamed Aas on 4/16/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "NewPostStoryCell.h"

@implementation NewPostStoryCell


-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.clipsToBounds=YES;
        
        post = [[ASNetworkImageNode alloc]init];
        [post setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [post setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:post.view];

        statusLBL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.bounds.size.width-20, self.bounds.size.height-20)];
        statusLBL.hidden = true;
        statusLBL.textColor = [UIColor whiteColor];
        [self addSubview:statusLBL];
        
        overLay = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        overLay.backgroundColor = [UIColor whiteColor];
        overLay.alpha = 0.8;
        [self addSubview:overLay];
    }
 
    return self;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if(selected)
    {
        overLay.alpha = 0;
        
    }
    else
    {
        overLay.alpha = 0.8;
        
    }
    
    
}

-(void)setDataObj:(APIObjects_FeedObj *)dict;
{
    
    if(dict.mediaType.intValue!=0)
    {
        post.URL = [NSURL URLWithString:dict.image_url];
    }
    
    statusLBL.text = dict.text;
    
    
    [self setUpMediaType:dict.mediaType.intValue andColorNumber:dict.colorNumber.intValue];
    
  
}

-(void)setUpMediaType:(int)number andColorNumber:(int)Cnumber;
{
    

    mediaType=number;
    
    if(mediaType==0)
    {
        
        post.hidden = YES;
        statusLBL.hidden = false;
        self.backgroundColor=[Constant colorGlobal:Cnumber];
        statusLBL.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        statusLBL.font=[UIFont fontWithName:k_fontExtraBold size:40];
        statusLBL.numberOfLines=0;
        statusLBL.adjustsFontSizeToFitWidth=YES;
        
    }
    else
    {

        statusLBL.hidden = true;
        post.hidden = NO;
        self.backgroundColor=[UIColor whiteColor];
        
    }
    
}

@end
