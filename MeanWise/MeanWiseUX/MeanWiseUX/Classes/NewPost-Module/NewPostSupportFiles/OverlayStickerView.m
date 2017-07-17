//
//  OverlayStickerView.m
//  VideoPlayerDemo
//
//  Created by Hardik on 09/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "OverlayStickerView.h"
#import "GUIScaleManager.h"


@implementation OverlayStickerView

-(void)cleanUp
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    
}
-(void)handlePanningWithPoint:(CGPoint)translatedCenter
{
    CGRect rect=RX_mainScreenBounds;
    
    if(translatedCenter.y>rect.size.height-80 && translatedCenter.x>rect.size.width/2-40 && translatedCenter.x<rect.size.width/2+40)
    {
        
        
        
        [UIView animateWithDuration:0.2 animations:^{
            mainView.alpha=0.5;
            mainView.transform=CGAffineTransformMakeScale(0.2, 0.2);
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            mainView.alpha=1;
            mainView.transform=CGAffineTransformMakeScale(1, 1);
        }];
    }
    
    
}
-(void)setUpOverLaySticker
{
    
    
    
    allowBackground=false;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    mainView=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:mainView];
    mainView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

    
    mainTextView=[[UITextView alloc] initWithFrame:self.bounds];
    [mainView addSubview:mainTextView];
    mainTextView.text=@"";
    mainTextView.userInteractionEnabled=false;
    mainTextView.delegate=self;
    mainTextView.scrollEnabled=false;
    mainTextView.font=[UIFont fontWithName:@"Avenir-Black" size:30];
    // mainTextView.backgroundColor=[UIColor grayColor];
    mainTextView.keyboardAppearance=UIKeyboardAppearanceDark;
    
    [mainTextView setAutocorrectionType:UITextAutocorrectionTypeYes];
    [mainTextView setSpellCheckingType:UITextSpellCheckingTypeNo];

    mainView.layer.cornerRadius=5;
    mainView.clipsToBounds=YES;
    
    if(allowBackground==true)
    {
        mainView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.95f];
    }
    else
    {
        mainView.backgroundColor=[UIColor clearColor];
    }
    
    
    mainTextView.backgroundColor=[UIColor clearColor];
    mainTextView.textColor=[UIColor whiteColor];
    
    [self textViewDidChange:mainTextView];
    
    
    [editingDelegate performSelector:onEditingStart withObject:self afterDelay:0.01];
    
    
    
}
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    UITextView *tv = object;
//    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
//    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
//    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
//}

-(void)changeProperty:(NSDictionary *)dict;
{
    
    NSString *fontName=[dict valueForKey:@"font"];
    
    int alignment=[[dict valueForKey:@"alignment"] intValue];
    int colorNumber=[[dict valueForKey:@"color"] intValue];
    int isInvert=[[dict valueForKey:@"invert"] intValue];
    float fontSize=[[dict valueForKey:@"fontSizeValue"] floatValue];
    
    if(isInvert==0)
    {
        allowBackground=false;
    }
    else
    {
        allowBackground=true;
    }
    
    
    
    
    
    
    if(colorNumber==1)
    {
        if(allowBackground==true)
        {
            mainView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.95f];
        }
        else
        {
            mainView.backgroundColor=[UIColor clearColor];
        }
        mainTextView.backgroundColor=[UIColor clearColor];
        mainTextView.textColor=[UIColor whiteColor];
        
    }
    else if(colorNumber==2)
    {
        if(allowBackground==true)
        {
            mainView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.95f];
        }
        else
        {
            mainView.backgroundColor=[UIColor clearColor];
        }
        mainTextView.backgroundColor=[UIColor clearColor];
        mainTextView.textColor=[UIColor blackColor];
    }
    
    
    
    
    mainTextView.font=[UIFont fontWithName:fontName size:fontSize];
    mainTextView.textAlignment=alignment;
    [self textViewDidChange:mainTextView];
    [editingDelegate performSelector:onEditingStart withObject:self afterDelay:0.01];
    
}
-(void)objectDelete
{
    
    [delegate performSelector:onDeleteCallBack withObject:self afterDelay:0.01];
    
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    
    int width=RX_mainScreenBounds.size.width-50;
    int height=RX_mainScreenBounds.size.height;
    
    int paddingX=0;
    int paddingY=0;
    
    CGSize size = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    
    
    self.bounds=CGRectMake(0,0, size.width+paddingX, size.height+paddingY);
    
    
    mainTextView.frame=CGRectMake(paddingX/2, paddingY/2, size.width, size.height);
    [mainTextView becomeFirstResponder];
    [editingDelegate performSelector:onEditingStart withObject:self afterDelay:0.01];
    
    [self updateTextViewFrame];
    
    
    
    
    
}
- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //  CGFloat deltaHeight = kbSize.height - currentKeyboardHeight;
    // Write code to adjust views accordingly using deltaHeight
    currentKeyboardHeight = kbSize.height;
    
    [self updateTextViewFrame];
    
}

-(void)updateTextViewFrame
{
    
    
    if(self.userInteractionEnabled==true)
    {
        int height=RX_mainScreenBounds.size.height;
        
        
        self.frame=CGRectMake(self.frame.origin.x, height-mainTextView.bounds.size.height-currentKeyboardHeight-150, self.bounds.size.width, self.bounds.size.height);
    }
    
    
}
- (void)keyboardWillHide:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    //CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    // Write code to adjust views accordingly using kbSize.height
    currentKeyboardHeight = 0.0f;
}
-(void)setDeleteCallBack:(SEL)func
{
    onDeleteCallBack=func;
}
-(float)getKeyboardHeight
{
    return currentKeyboardHeight;
}

-(void)resetWithAnimation:(BOOL)animation
{
    
    [self resetManuallyToTypeNew];
    
}
-(void)resignResponderThis
{
    
    [mainTextView resignFirstResponder];
    [editingDelegate performSelector:onEditingEnd withObject:self afterDelay:0.01];
    
}
-(void)resetManuallyToTypeNew
{
    
    
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.center = self.superview.center;
        
        
    } completion:^(BOOL finished) {
        [mainTextView becomeFirstResponder];
        
        [editingDelegate performSelector:onEditingStart withObject:self afterDelay:0.01];
        
    }];
    
    
    
}
-(void)becomeResponsderThis
{
    
    [self resetManuallyToTypeNew];
    
}

-(void)setEditingDelegate:(id)delegateReceived onEditingStart:(SEL)func1 onEditingEnd:(SEL)func2
{
    editingDelegate=delegateReceived;
    onEditingStart=func1;
    onEditingEnd=func2;
    
    
}
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    
    
    
    BOOL flag=[super gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    
    
    return flag;
}

@end
