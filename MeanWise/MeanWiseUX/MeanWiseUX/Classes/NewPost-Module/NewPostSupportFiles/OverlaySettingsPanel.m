//
//  OverlaySettingsPanel.m
//  VideoPlayerDemo
//
//  Created by Hardik on 10/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "OverlaySettingsPanel.h"
#import "GUIScaleManager.h"
#import "Constant.h"

@implementation OverlaySettingsPanel

-(void)setTarget:(id)del onPropertyChange:(SEL)func;
{
    target=del;
    onPropertyChangeCallBack=func;
    
}
-(void)setUp
{
    
    CGSize mainScreenSize=RX_mainScreenBounds.size;
    fontSizeValue=30;
    
    //
    //
    //CourierNewPS-BoldMT
    //
    //
    
    
    fontList=[NSArray arrayWithObjects:
              @"Avenir-Black",
              @"Anton-Regular",
              @"TitilliumWeb-Regular",

              @"GillSans-SemiBold",
              
              @"AlfaSlabOne-Regular",
              @"Bahiana-Regular",
              @"BungeeInline-Regular",
              @"Chewy",
              @"JustAnotherHand-Regular",
              @"Skranji-Bold",
              
              @"Slackey",
              @"Lalezar-Regular",
              @"Cookie-Regular",
              @"Bellefair-Regular",
              
              
              
              
              nil];
    
    fontDisplayNameList=[NSArray arrayWithObjects:
                         @"Avenir",
                         @"DINAlternate",
                         @"MarkerFelt",
                         @"Noteworthy",
                         @"SavoyeLet",
                         @"GillSans",
                         @"Futura",
                         @"Courier",
                         
                         
                         nil];
    
    
    
    
    
    dict=@{@"font":@"Avenir-Roman",@"Alignment":[NSNumber numberWithInteger:1],@"color":[NSNumber numberWithInteger:0]};
    
    
    
    mainPanel=[[UIView alloc] initWithFrame:CGRectMake(0, 50, mainScreenSize.width, 50)];
    [self addSubview:mainPanel];
    mainPanel.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    
    fontPanel=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainScreenSize.width, 50)];
    [self addSubview:fontPanel];
    fontPanel.canCancelContentTouches=YES;
    fontPanel.contentSize=CGSizeMake(90*fontList.count, 0);
    
    fontSizePanel=[[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenSize.width, 50)];
    [self addSubview:fontSizePanel];
    fontSizePanel.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5f];

    fontSizeSlider=[[UISlider alloc] initWithFrame:CGRectMake(5, 0, fontSizePanel.bounds.size.width-10, fontSizePanel.bounds.size.height)];
    
    
    [fontSizeSlider addTarget:self action:@selector(fontSizeChange:) forControlEvents:UIControlEventValueChanged];
    fontSizeSlider.minimumValue=15;
    fontSizeSlider.maximumValue=60;
    fontSizeSlider.value=30;
    
    fontSizeSlider.tintColor=[UIColor whiteColor];
    
    [fontSizePanel addSubview:fontSizeSlider];


    
    
    for(int i=0;i<fontList.count;i++)
    {
        NSString *fontNameTemp=[fontList objectAtIndex:i];
       // NSString *fontNameDisplay=[fontDisplayNameList objectAtIndex:i];
        
        UIButton *button=[self getNormalButton1:@"ABC" andCallBack:@selector(newFontSelected:)];
        
        [fontPanel addSubview:button];
        button.tag=i;
        button.titleLabel.font=[UIFont fontWithName:fontNameTemp size:12];
        button.titleLabel.adjustsFontSizeToFitWidth=YES;
        button.frame=CGRectMake(10+i*90, 5, 80, 40);
        button.layer.cornerRadius=5;
        
        
    }
    
    fontPanel.hidden=true;
    fontSizePanel.hidden=true;
    
    
    
    fontBtn=[self getButton:@"MX_changeFont.png" andCallBack:@selector(fontBtnClicked:)];
    [mainPanel addSubview:fontBtn];
    
    alignmentBtn=[self getButton:@"MX_justify.png" andCallBack:@selector(alignmentBtnClicked:)];
    [mainPanel addSubview:alignmentBtn];
    
    invertBtn=[self getButton:@"MX_invert_colors.png" andCallBack:@selector(invertBtnClicked:)];
    [mainPanel addSubview:invertBtn];
    
    
    color1Btn=[self getButton:@"MX_blackcircle.png" andCallBack:@selector(color1BtnClicked:)];
    [mainPanel addSubview:color1Btn];
    
    color2Btn=[self getButton:@"MX_whitecircle-o.png" andCallBack:@selector(color2BtnClicked:)];
    [mainPanel addSubview:color2Btn];
    
    fontSizeBtn=[self getButton:@"MX_fontSize.png" andCallBack:@selector(fontSizeBtnClicked:)];
    [mainPanel addSubview:fontSizeBtn];
    
    
    fontBtn.center=CGPointMake(25, 25);
    alignmentBtn.center=CGPointMake(75, 25);
    
    color1Btn.center=CGPointMake(mainScreenSize.width-75, 25);
    color2Btn.center=CGPointMake(mainScreenSize.width-25, 25);
    
    invertBtn.center=CGPointMake(mainScreenSize.width-25-100, 25);
    fontSizeBtn.center=CGPointMake(75+50, 25);
    
    fontName=@"Avenir-Black";
    textAlignment=1;
    colorNumber=1;
    isInvert=0;
    
    
}
-(void)fontSizeChange:(UISlider *)sender
{
    fontSizeValue=sender.value;
    
    dict=@{@"font":fontName,@"alignment":[NSNumber numberWithInteger:textAlignment],@"color":[NSNumber numberWithInteger:colorNumber],@"invert":[NSNumber numberWithInteger:isInvert],@"fontSizeValue":@(fontSizeValue)};
    
    
    [target performSelector:onPropertyChangeCallBack withObject:dict afterDelay:0.01];

}
-(void)invertBtnClicked:(id)sender
{
    if(isInvert==0)
    {
        isInvert=1;
    }
    else
    {
        isInvert=0;
    }
    
    dict=@{@"font":fontName,@"alignment":[NSNumber numberWithInteger:textAlignment],@"color":[NSNumber numberWithInteger:colorNumber],@"invert":[NSNumber numberWithInteger:isInvert],@"fontSizeValue":@(fontSizeValue)};
    
    
    [target performSelector:onPropertyChangeCallBack withObject:dict afterDelay:0.01];

    
}
-(void)newFontSelected:(UIButton *)sender
{
    fontName=[fontList objectAtIndex:sender.tag];
    
    dict=@{@"font":fontName,@"alignment":[NSNumber numberWithInteger:textAlignment],@"color":[NSNumber numberWithInteger:colorNumber],@"invert":[NSNumber numberWithInteger:isInvert],@"fontSizeValue":@(fontSizeValue)};
    
    
    [target performSelector:onPropertyChangeCallBack withObject:dict afterDelay:0.01];
    
}

-(void)fontBtnClicked:(id)sender
{
    
    fontPanel.hidden=false;
    fontSizePanel.hidden=true;

    
    
}
-(void)fontSizeBtnClicked:(id)sender
{
    fontSizePanel.hidden=false;
    fontPanel.hidden=true;
}
-(void)alignmentBtnClicked:(id)sender
{
    fontPanel.hidden=true;
    
    textAlignment=textAlignment+1;
    if(textAlignment>2)
    {
        textAlignment=0;
    }
    
    dict=@{@"font":fontName,@"alignment":[NSNumber numberWithInteger:textAlignment],@"color":[NSNumber numberWithInteger:colorNumber],@"invert":[NSNumber numberWithInteger:isInvert],@"fontSizeValue":@(fontSizeValue)};
    
    [target performSelector:onPropertyChangeCallBack withObject:dict afterDelay:0.01];
    
    
}
-(void)color1BtnClicked:(id)sender
{
    fontPanel.hidden=true;
    
    colorNumber=1;
    
    dict=@{@"font":fontName,@"alignment":[NSNumber numberWithInteger:textAlignment],@"color":[NSNumber numberWithInteger:colorNumber],@"invert":[NSNumber numberWithInteger:isInvert],@"fontSizeValue":@(fontSizeValue)};
    
    [target performSelector:onPropertyChangeCallBack withObject:dict afterDelay:0.01];
    
}
-(void)color2BtnClicked:(id)sender
{
    fontPanel.hidden=true;
    
    colorNumber=2;
    
    dict=@{@"font":fontName,@"alignment":[NSNumber numberWithInteger:textAlignment],@"color":[NSNumber numberWithInteger:colorNumber],@"invert":[NSNumber numberWithInteger:isInvert],@"fontSizeValue":@(fontSizeValue)};
    
    [target performSelector:onPropertyChangeCallBack withObject:dict afterDelay:0.01];
    
}
-(UIButton *)getButton:(NSString *)imagePath andCallBack:(SEL)func
{
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setBackgroundImage:[UIImage imageNamed:imagePath] forState:UIControlStateNormal];
    [btn addTarget:self action:func forControlEvents:UIControlEventTouchUpInside];
    [btn setShowsTouchWhenHighlighted:YES];
    return btn;
    
    
}

-(UIButton *)getNormalButton1:(NSString *)title andCallBack:(SEL)func
{
    
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setBackgroundColor:[UIColor blackColor]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:func forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.adjustsFontSizeToFitWidth=YES;
    return btn;
    
}
@end
