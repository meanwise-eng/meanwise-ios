//
//  ConnectionBar.h
//  MeanWiseUX
//
//  Created by Hardik on 27/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface ConnectionBar : NSObject
{
    Reachability *reachability;

    UIView *statusBarNotifierView;
    UILabel *statusBarNotifierText;
    
    UIWindow *window;
    
    CGRect hiddenRect;
    CGRect showingRect;
    


}
@property (nonatomic, assign) BOOL hasInet;
-(void)setUp;

@end
