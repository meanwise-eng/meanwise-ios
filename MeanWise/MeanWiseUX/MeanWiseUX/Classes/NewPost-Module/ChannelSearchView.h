//
//  ChannelSearchView.h
//  MeanWiseUX
//
//  Created by Hardik on 29/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelSearchView : UIView <UITableViewDataSource,UITableViewDelegate>

{
    
    
    int selectedChannelId;
    NSArray *masterData;
    NSArray *resultData;
    
    UIView *selectionMasterView;
    UIView *searchFieldBG;
    UITextField *searchField;
    UIView *searchBar;
    UITableView *feedTable;
    

    
    UIImageView *selectedCellImage;
    UIView *selectedCellImageOverLay;
    UILabel *selectedCellTitle;
    UIImageView *nextArrowImage;
    UIButton *buttonSelect;
    
    CGRect shortFrame;
    CGRect fullFrame;
    CGRect shortFrameOther;
    CGRect fullFrameOther;
}
-(void)setUp;
-(void)setState1Frame:(CGRect)frame;

-(int)getSelectedChannelId;

@end
