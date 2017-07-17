//
//  EditSCSuggestionsComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 16/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIManager.h"

@interface EditSCSuggestionsComponent : UIView <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tagListTBL;

    id target;
    SEL onTagSelectCallBack;

    NSMutableArray *resultList;
    NSString *searchTerm;

    APIManager *manager;
    
    BOOL isQueryForProfession;
}
-(void)setUp;
-(void)sendQueryForProfession:(BOOL)flag;
-(void)setTerm:(NSString *)term;
-(void)setUp:(id)target OnTagSelectCallBack:(SEL)func;

@end
