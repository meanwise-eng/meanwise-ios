//
//  HCFilterImageView.h
//  Exacto
//
//  Created by Hardik on 18/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HCFilterList.h"
#import "HCFilterHelper.h"


@interface HCFilterImageView : UIView 
{
    
    UIImage *keyImage;
    UIImageView *keyImageView;
    UIView *imageOverLay;
    CAGradientLayer *gLayer;

    
    NSMutableArray *CorefilterDB;
    NSMutableArray *MasterFilterDB;
    
    UILabel *fancyToast;
    
    int cFilterNo;
    
    NSMutableArray *filteredImageName;
    
    HCFilterList *filterListIB;
    
    HCFilterHelper *helper;
}
-(void)setUp;
-(void)cleanUp;
-(void)setUpPath:(NSString *)path;

@end


