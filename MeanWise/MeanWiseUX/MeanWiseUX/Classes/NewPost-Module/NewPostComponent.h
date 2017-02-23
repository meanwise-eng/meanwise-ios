//
//  NewPostComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 27/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomGestureView.h"
#import "Constant.h"
#import "ChannelSearchView.h"
#import "PhotoGallery.h"
#import "PreviewViewComponent.h"
#import "MediaCropper.h"
#import "UIImageHM.h"

@interface NewPostComponent : ZoomGestureView<UITextViewDelegate>
{
    UIImageHM *profileIMGVIEW;
    UIButton *postBtn;
    
    
    PreviewViewComponent *attachedImage;
    
    UITextView *statusView;
    UILabel *characterCountLBL;
    
    UILabel *replyToLBL;
    
    ChannelSearchView *channelSelectionView;
    
    PhotosBtnController *photoControllerBtns;
    
    PhotoGallery *photoGallery;
    
    MediaCropper *cropperControl;
    
}
-(void)setUpWithCellRect:(CGRect)rect;

@end


/*

Close Button to cancel the image
 
 

*/