//
//  SearchSuggestionsView.h
//  MeanWiseUX
//
//  Created by Hardik on 07/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchSuggestionsView : UIView
{

    
    NSMutableArray *listOfOptions;
    NSMutableArray *listOfOptionsLBL;
    
    
    NSArray *optionsName;
    
    id target;
    SEL onSelectFunc;
}
-(void)setUp;
-(void)setTarget:(id)targetReceived OnOptionSelect:(SEL)func1;
-(void)setSearchString:(NSString *)searchTerm;


@end
