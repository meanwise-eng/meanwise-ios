//
//  PostMiniCell.m
//  MeanWiseUX
//
//  Created by Hardik on 04/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "PostMiniCell.h"
#import "ResolutionVersion.h"
#import "GUIScaleManager.h"

@implementation PostMiniCell

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.clipsToBounds=YES;
      
        self.postImageV=[[UIImageHM alloc] initWithFrame:self.bounds];
        [self addSubview:self.postImageV];
        
        self.statusText=[[UILabel alloc] init];
        [self addSubview:self.statusText];
        self.statusText.textColor=[UIColor whiteColor];
        self.statusText.numberOfLines=0;
        self.statusText.adjustsFontSizeToFitWidth=YES;
        
        
        self.statusText.font=[UIFont fontWithName:k_fontSemiBold size:15];
        self.statusText.frame=CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10);
        
        self.postImageV.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.statusText.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        
       


        /*
        self.statusText.frame=CGRectMake(50, 10, RX_mainScreenBounds.size.width-100, RX_mainScreenBounds.size.height*0.32);
        self.statusText.font=[UIFont fontWithName:k_fontSemiBold size:20];
        float ratio=(self.frame.size.width)/(RX_mainScreenBounds.size.width);
        self.statusText.transform=CGAffineTransformMakeScale(ratio, ratio);
*/
        
    }
    return self;
}
-(void)setUpPostImageURL:(NSString *)urlStr andText:(NSString *)string;
{

    if([urlStr isEqualToString:@""])
    {
        self.statusText.text=string;
        self.statusText.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        
        self.postImageV.hidden=true;
        self.statusText.hidden=false;


    }
    else
    {
        [self.postImageV setUp:urlStr];
        self.statusText.text=string;
        
        self.postImageV.hidden=false;
        self.statusText.hidden=true;

    }


    
    
}
@end
