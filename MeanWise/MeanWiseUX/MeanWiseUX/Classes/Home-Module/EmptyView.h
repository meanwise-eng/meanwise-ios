//
//  EmptyView.h
//  MeanWiseUX
//
//  Created by Hardik on 30/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"

@interface EmptyView : UIView
{
    
    id target;
    SEL onReloadFunc;
}
@property (nonatomic, strong) UILabel *msgLBL;
@property (nonatomic, strong) UIButton *reloadBtn;
-(void)setDelegate:(id)delegate onReload:(SEL)func;

-(void)setUIForBlack;
-(void)setUIForWhite;

@end
