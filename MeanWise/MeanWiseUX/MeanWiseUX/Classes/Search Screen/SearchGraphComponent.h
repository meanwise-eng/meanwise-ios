//
//  SearchGraphComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 02/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircularGraphManager.h"

@interface SearchGraphComponent : UIView
{
    CircularGraphManager *cControl;
    
    UIButton *searchBtn;

    UIActivityIndicatorView *loaderView;
    UITextField *searchBox;
    
    BOOL isSearchBoxEditMode;
    
    BOOL isSearchBtnInside;
    
    UILabel *statusLabel;
    UILabel *miniStatusLabel;
    
    UILabel *errorMessageLBL;
    
}
-(void)setUp;
-(void)onCContronScroll:(NSValue *)pointValue;

@end
