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
//#import "PreviewViewComponent.h"
#import "MediaCropper.h"
#import "UIImageHM.h"
#import "PreviewMaxScreen.h"
#import "SAMTextView.h"

@interface NewPostComponent : ZoomGestureView<UITextViewDelegate>
{
    UIImageHM *profileIMGVIEW;
    UIButton *postBtn;
    
    
    
    SAMTextView *statusView;
//    PreviewViewComponent *attachedImage;
    PreviewMaxScreen *mediaAttachComponent;
    
    
    UILabel *characterCountLBL;
    
    UILabel *replyToLBL;
    
    ChannelSearchView *channelSelectionView;
    
    PhotosBtnController *photoControllerBtns;
    
    PhotoGallery *photoGallery;
    
    MediaCropper *cropperControl;
    
    NSMutableArray *hashTagArray;
    NSMutableArray *topicArray;
    
    id target;
    SEL closeCallBackfunc;
    
    BOOL isPostHasAttachment;
    BOOL isMediaFromCamera1;

}
-(void)setUpWithCellRect:(CGRect)rect;
-(void)setTarget:(id)targetReceived onCloseEvent:(SEL)func1;
//-(void)openFullScreen:(id)sender;

@end


/*

Close Button to cancel the image
 
 

*/
