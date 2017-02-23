//
//  APITesterView.h
//  MeanWiseUX
//
//  Created by Hardik on 09/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIManager.h"
#import "Constant.h"

@interface APITesterView : UIView
{
    APIManager *manager;
}
-(void)setUp;
//-(void)callStaticAPIs;

@end
