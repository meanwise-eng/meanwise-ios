//
//  CircularGraphManager.h
//  MeanWiseRedesignHelper
//
//  Created by Hardik on 01/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CircularGraphManager : UIView <UIScrollViewDelegate>
{

    UIScrollView *scrollView;
    
    CGPoint layoutCenter;
    CGPoint touchPoint;
    CGSize cellSize;
    

    NSMutableArray *dataArray;
    
    NSMutableArray *stackPosRadiusArray;
    NSMutableArray *stackCapacityArray;
    NSMutableArray *allUIObjects;
    

    BOOL isSearching;
    BOOL isCleanupInProgress;
    

    id target;
    SEL onScrollEvent;
    SEL onUserTap;
    SEL onLongTap;

}
-(void)setUp;
-(void)setTarget:(id)targetReceived onScroll:(SEL)func andOnUserTap:(SEL)func2 andLongTap:(SEL)func3;


//Events = Methods
-(void)addNewObjects:(NSArray *)array;
-(void)setSearchMode:(BOOL)flag;
-(void)removeAllClear;
-(BOOL)getSearchMode;


-(void)makeAllVisible;


//Button to reach center
//search button inside the circular bar
//search button tap - open textfield
//after pressed search reload data
//


@end
