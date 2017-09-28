//
//  TopicAutoCompleteControl.h
//  MeanWiseUX
//
//  Created by Hardik on 10/08/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditTagListControl.h"


@interface SuggestionBox : UIView <UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *resultListView;
    NSMutableArray *resultData;
    NSString *searchString;
    
    id target;
    SEL onSuggestionSelect;
    
    
    CGRect searchBoxRect;
    
    
}
-(void)searchTermChange:(NSString *)newString;
-(void)setTarget:(id)targetReceived onSelect:(SEL)func;
-(void)setSearchRect:(CGRect)frame;
-(void)setUp;

@end

@interface TopicAutoCompleteControl : UIView <UITextFieldDelegate>
{

    CGRect fullRect;
    CGRect smallRect;
    
    id target;
    SEL onCloseFunc;
    
    UIButton *cancelBtn;
    UIButton *doneBtn;

    UIView *searchBar;
    UIView *searchFieldBG;
    UILabel *title;
    UITextField *searchField;
    
    NSMutableArray *tagListArray;
    
    
    
    SuggestionBox *suggestionView;

    EditTagListControl *tagList;
    
}
-(void)setUp:(CGRect)fullRect withData:(NSMutableArray *)array;
-(void)setTarget:(id)target onCloseFunc:(SEL)func;

@end

