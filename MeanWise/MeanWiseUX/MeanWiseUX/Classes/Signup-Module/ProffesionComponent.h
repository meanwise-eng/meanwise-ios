//
//  ProffesionComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 19/02/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@interface ProffesionComponent : UIView <UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *keyTable;
    NSArray *profArray;
    
    id target;
    SEL proSelectedFunc;
}
-(void)setUp;
-(void)setTarge:(id)delegate andOnProffSelect:(SEL)func1;

@end
