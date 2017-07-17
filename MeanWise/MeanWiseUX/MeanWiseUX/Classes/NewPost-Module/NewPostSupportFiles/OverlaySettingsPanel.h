//
//  OverlaySettingsPanel.h
//  VideoPlayerDemo
//
//  Created by Hardik on 10/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverlaySettingsPanel : UIView
{
    
    NSArray *fontList;
    NSArray *fontDisplayNameList;
    
    UIView *mainPanel;
    UIScrollView *fontPanel;
    UIView *fontSizePanel;
    UISlider *fontSizeSlider;
    
    UIButton *fontBtn;
    UIButton *alignmentBtn;
    UIButton *color1Btn;
    UIButton *invertBtn;
    UIButton *color2Btn;
    UIButton *fontSizeBtn;
    
    id target;
    SEL onPropertyChangeCallBack;
    
    NSDictionary *dict;
    
    NSString *fontName;
    int textAlignment;
    int colorNumber;
    int isInvert;
    
    float fontSizeValue;
}
-(void)setUp;
-(void)setTarget:(id)del onPropertyChange:(SEL)func;

@end
