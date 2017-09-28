//
//  ProfileFilterPostComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 12/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileFilterPostComponent : UIView
{
    NSMutableArray *postFilterBtns;

    UIButton *closeBtn;
    
    id delegate;
    SEL onApplyFilter;
    
    NSMutableArray *allRelatedInterests;
    
    NSArray *allDataRecords;
    
    UILabel *titleLabel;
}
-(void)setUp;
-(void)calculateFilterStats:(NSMutableArray *)dataRecords;

-(void)setTarget:(id)delegateReceived ApplyFilter:(SEL)func1;

@end
