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
    
    UIWindow *window;

    Reachability *reachability;

    
    
    UIView *internetErrorView;


}
@property (nonatomic, assign) BOOL hasInet;
-(void)setUp;

@end
