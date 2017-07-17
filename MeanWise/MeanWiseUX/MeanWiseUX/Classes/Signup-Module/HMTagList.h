//
//  HMTagList.h
//  MeanWiseUX
//
//  Created by Hardik on 05/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@interface HMTagList : UIView
{
    
    NSMutableArray *arrayTags;
    NSMutableArray *tagUILabel;
    
}
-(void)setUp;
-(void)addNewTag:(NSString *)tag;
-(NSArray *)getNumberOfTagsSelected;

@end

@interface HMTagLabel : UIView
{
    
    UILabel *label;
    UIButton *btn;
    NSString *tagString;
    
    id delegate;
    SEL selector;
    
}
-(void)setUpString:(NSString *)string withHeight:(int)height;
-(CGRect)getFrame;

-(void)setDelegate:(id)sender andFunc:(SEL)func;


@end
