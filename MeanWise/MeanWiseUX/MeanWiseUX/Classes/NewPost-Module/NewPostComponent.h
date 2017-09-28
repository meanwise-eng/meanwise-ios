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
#import "MediaCropper.h"
#import "UIImageHM.h"
#import "PreviewMaxScreen.h"
#import "SAMTextView.h"
#import "TopicAutoCompleteControl.h"
#import "LocationManagerBlock.h"
#import "UITextViewSuggestionHelper.h"

@interface NewPostComponent : ZoomGestureView<UITextViewDelegate>
{
    LocationManagerBlock *blockc;

    UIImageHM *profileIMGVIEW;
    UIButton *postBtn;
    
    
    
    SAMTextView *statusView;
    PreviewMaxScreen *mediaAttachComponent;
    UITextViewSuggestionsBox *suggestionView;
    UITextViewAutoSuggestionsDataSource *acHelper;

    
    
    UILabel *characterCountLBL;
    
    
    UIButton *topicListBtn;
    
    
    TopicAutoCompleteControl *topicControl;
    ChannelSearchView *channelSelectionView;
    
    PhotosBtnController *photoControllerBtns;
    
    PhotoGallery *photoGallery;
    
    MediaCropper *cropperControl;
    
    NSMutableArray *topicArray;
    NSMutableArray *mentionArray;
    
    id target;
    SEL closeCallBackfunc;
    
    BOOL isPostHasAttachment;
    BOOL isMediaFromCamera1;
    
    UIButton *locationBtn;
    float geo_location_lat;
    float geo_location_lng;


}
-(void)setUpWithCellRect:(CGRect)rect;
-(void)setTarget:(id)targetReceived onCloseEvent:(SEL)func1;

@end


