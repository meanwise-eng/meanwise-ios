//
//  ChannelCell.m
//  MeanWiseUX
//
//  Created by Hardik on 29/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "ChannelCell.h"

@implementation ChannelCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.clipsToBounds=YES;
        
        
        imageView=[[UIImageHM alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
        [self addSubview:imageView];
        imageView.layer.cornerRadius=2;
        imageView.clipsToBounds=YES;
        
        
        viewOverlay=[[UIView alloc] initWithFrame:imageView.frame];
        [self addSubview:viewOverlay];
        viewOverlay.alpha=0.5;
        
        label=[[UILabel alloc] initWithFrame:CGRectMake(70, 5, 300, 50)];
        [self addSubview:label];
        
        
        label.font=[UIFont fontWithName:k_fontSemiBold size:16];
        label.text=@"Music";
        
        label.textColor=[UIColor colorWithRed:(arc4random()%10)*0.1 green:(arc4random()%10)*0.1 blue:0 alpha:1.0f];
        
    }
    return self;
    
}
-(void)setName:(NSString *)string andNumber:(int)imageNumber
{
    numberIndex=imageNumber;
    UIColor *color1=[Constant colorGlobal:(imageNumber%14)];


    label.textColor=color1;
    
    viewOverlay.backgroundColor=color1;
    
    label.text=string;
}
-(void)setImageURL:(NSString *)urlString
{
 
    [imageView setUp:urlString];
    
}
-(UIImage *)getImage;
{
    return imageView.image;
}
-(UIColor *)getColorOfCell
{
    return label.textColor;
}
-(int)getImageNumberOfColor
{
    return numberIndex;
}


@end
