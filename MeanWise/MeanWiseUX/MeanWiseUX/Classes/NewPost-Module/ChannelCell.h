//
//  ChannelCell.h
//  MeanWiseUX
//
//  Created by Hardik on 29/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "UIImageHM.h"

@interface ChannelCell : UITableViewCell
{
    UIImageHM *imageView;
    UIView *viewOverlay;
    UILabel *label;
    
    int numberIndex;
}

-(void)setName:(NSString *)string andNumber:(int)number;
-(UIColor *)getColorOfCell;
-(int)getImageNumberOfColor;
-(void)setImageURL:(NSString *)urlString;
-(UIImage *)getImage;

@end
