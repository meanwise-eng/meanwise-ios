//
//  EditTagSearchResultComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 29/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTagSearchResultComponent : UIView <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tagListTBL;
    
    NSArray *tagList;
    NSMutableArray *resultList;
    
    id target;
    SEL onTagSelectCallBack;
    
    NSArray *currentTagList;
    NSString *searchTerm;
    
}
-(void)setUp:(id)target OnTagSelectCallBack:(SEL)func;
-(void)setSearchTerm:(NSString *)term withCurrentArray:(NSArray *)array;

@end
