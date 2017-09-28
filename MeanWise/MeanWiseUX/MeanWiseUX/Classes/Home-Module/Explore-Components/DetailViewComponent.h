//
//  DetailViewComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 28/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageHM.h"

#import "ZoomGestureView.h"
#import "FullCommentDisplay.h"
#import "ShareComponent.h"


@interface DetailViewComponent : ZoomGestureView <UICollectionViewDelegate,UICollectionViewDataSource>
{
    
    
    FullCommentDisplay *commentDisplay;
    ShareComponent *sharecompo;

    NSMutableArray *dataRecords;


    UIImageHM *postIMGVIEW;
    UICollectionView *galleryView;
    
    
    int colorNumber;
    
    id delegate;
    SEL pageChangeCallBackFunc;
    SEL downCallBackFunc;
    
    NSIndexPath *globalPath;
    

    NSString *screenIdentifier;
    
    BOOL shouldOpenCommentDirectly;

    UIButton *backBtn;
    BOOL isUserCanDeletePost;
    
    SEL onDeletePost;
    
    BOOL ifItsForExplore;
}
-(void)openCommentDirectly:(BOOL)flag;
-(void)showBackBtn;

-(void)setDelegate:(id)target andPageChangeCallBackFunc:(SEL)function1 andDownCallBackFunc:(SEL)function2;
-(void)setUpNewScrolledRect:(CGRect)rect;

-(void)setUpWithCellRect:(CGRect)rect;
-(void)setImage:(NSString *)string andNumber:(NSIndexPath *)indexPath;
-(void)setDataRecords:(NSMutableArray *)array;
-(void)setColorNumber:(int)number;
-(void)setIfUserCanDeletePost:(BOOL)flag withDeleteCallBack:(SEL)callBack;
-(void)addNewDataViaReload;

-(void)setIfItsForExplore:(BOOL)flag;

@end
