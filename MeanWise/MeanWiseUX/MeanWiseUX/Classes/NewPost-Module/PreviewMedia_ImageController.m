//
//  PreviewMediaController.m
//  ExactResearch
//
//  Created by Hardik on 13/02/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "PreviewMedia_ImageController.h"

@implementation PreviewMedia_ImageController

-(void)setTarget:(id)targetReceived OnSuccess:(SEL)func1 OnFail:(SEL)func2;
{
    target=targetReceived;
    onSuccessFunc=func1;
    onCancelFunc=func2;
    
}
-(void)setUpWithString:(NSString *)strPath
{
    
    NSLog(@"%@",strPath);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    
    
    filePathStr=strPath;
    NSString *ext = [filePathStr pathExtension];
    
    if([ext.lowercaseString isEqualToString:@"png"] || [ext.lowercaseString isEqualToString:@"jpg"] || [ext.lowercaseString isEqualToString:@"jpeg"])
    {
        isVideo=false;
    }
    else{
        isVideo=true;
    }

    
    keyImageView=[[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:keyImageView];
    keyImageView.image=[UIImage imageWithContentsOfFile:filePathStr];
    keyImageView.contentMode=UIViewContentModeScaleAspectFill;
    
    
    shadowImageView=[[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:shadowImageView];
    shadowImageView.contentMode=UIViewContentModeScaleAspectFill;
    shadowImageView.image=[UIImage imageNamed:@"BlackShadow.png"];
    shadowImageView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    shadowImageView.alpha=0.1f;
    shadowImageView.transform=CGAffineTransformMakeScale(1, -1);
    
    
    
    fontSize=30;
    
    field=[[UITextView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, 50)];
    [self addSubview:field];
    field.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
    field.textColor=[UIColor whiteColor];
    field.center=self.center;
    field.font=[UIFont fontWithName:@"Avenir-Black" size:fontSize];
    field.delegate=self;
    field.textAlignment=NSTextAlignmentCenter;
    field.layer.shadowColor = [[UIColor blackColor] CGColor];
    field.layer.shadowOffset = CGSizeMake(0, 0);
    field.layer.shadowOpacity = 0.8f;
    field.layer.shadowRadius = 2.0f;
    field.keyboardAppearance=UIKeyboardAppearanceDark;

    

    
    
    editBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    [self addSubview:editBtn];
    editBtn.center=CGPointMake(55, self.frame.size.height-55);
    [editBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"1_editBtn.png"] forState:UIControlStateNormal];

    
    doneBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    [self addSubview:doneBtn];
    doneBtn.center=CGPointMake(self.frame.size.width-55, self.frame.size.height-55);
    [doneBtn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"1_doneBtn.png"] forState:UIControlStateNormal];

    

    
    
    
    
    
    
    EditingCancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self addSubview:EditingCancelBtn];
    EditingCancelBtn.center=CGPointMake(35, 35);
    [EditingCancelBtn addTarget:self action:@selector(EditingCancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [EditingCancelBtn setBackgroundImage:[UIImage imageNamed:@"2_cancelBtn.png"] forState:UIControlStateNormal];
    
    EditingCorrectBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self addSubview:EditingCorrectBtn];
    EditingCorrectBtn.center=CGPointMake(self.frame.size.width-35, 35);
    [EditingCorrectBtn addTarget:self action:@selector(EditingCorrectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [EditingCorrectBtn setBackgroundImage:[UIImage imageNamed:@"2_correctBtn.png"] forState:UIControlStateNormal];

    
    
    
    //KeyBoard Bar setup
    [self setUpKeyBoardBar];
   

 
    
    [self setState:0];

    [self addTextBtnClicked:nil];
}
-(void)setUpKeyBoardBar
{
    keyBoardBar=[[UIView alloc] initWithFrame:CGRectMake(0,  2*self.frame.size.height, self.frame.size.width, 50)];
    [self addSubview:keyBoardBar];
    keyBoardBar.backgroundColor=[UIColor clearColor];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = keyBoardBar.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [keyBoardBar addSubview:blurEffectView];

    
    blackColorBtn=[self setUpBtnWithTitle:@"" andSel:@selector(colorChoosen:)];
    [keyBoardBar addSubview:blackColorBtn];
    blackColorBtn.tag=1;
    
    whiteColorBtn=[self setUpBtnWithTitle:@"" andSel:@selector(colorChoosen:)];
    [keyBoardBar addSubview:whiteColorBtn];
    whiteColorBtn.tag=2;
    
    
    
 
    
    alignmentBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [keyBoardBar addSubview:alignmentBtn];

    fontSizeUpBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [keyBoardBar addSubview:fontSizeUpBtn];

    fontSizeDownBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [keyBoardBar addSubview:fontSizeDownBtn];

    [alignmentBtn addTarget:self action:@selector(alignmentToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [fontSizeUpBtn addTarget:self action:@selector(fontSizePlus:) forControlEvents:UIControlEventTouchUpInside];
    [fontSizeDownBtn addTarget:self action:@selector(fontSizeMinus:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [alignmentBtn setBackgroundImage:[UIImage imageNamed:@"1_alignmentBtn.png"] forState:UIControlStateNormal];
    [fontSizeUpBtn setBackgroundImage:[UIImage imageNamed:@"1_fontPlusBtn.png"] forState:UIControlStateNormal];
    [fontSizeDownBtn setBackgroundImage:[UIImage imageNamed:@"1_fontMinBtn.png"] forState:UIControlStateNormal];
    
    whiteColorBtn.backgroundColor=[UIColor colorWithWhite:1.0f alpha:1.0f];
    blackColorBtn.backgroundColor=[UIColor colorWithWhite:0.0f alpha:1.0f];
    
    whiteColorBtn.layer.borderColor=[UIColor yellowColor].CGColor;
    blackColorBtn.layer.borderColor=[UIColor yellowColor].CGColor;

    
 
    
    
    
    whiteColorBtn.frame=CGRectMake(0, 0, 35, 35);
    blackColorBtn.frame=CGRectMake(0, 0, 35, 35);
    
    whiteColorBtn.layer.cornerRadius=35/2;
    blackColorBtn.layer.cornerRadius=35/2;
    
    
    whiteColorBtn.center=CGPointMake(30,25);
    blackColorBtn.center=CGPointMake(30+40,25);
    
    alignmentBtn.center=CGPointMake(self.frame.size.width-25,25);
    fontSizeDownBtn.center=CGPointMake(self.frame.size.width-50-25,25);
    fontSizeUpBtn.center=CGPointMake(self.frame.size.width-100-25,25);

    [self colorChoosen:whiteColorBtn];
    
    /*
     
     whiteColorBtn.layer.borderWidth=2;
     blackColorBtn.layer.borderWidth=0;
     
*/
    
}


-(NSString *)applicationDocumentsDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    
    return documentsPath;
}
-(NSString *)FM_saveImageAtDocumentDirectory:(UIImage *)image
{
    
    NSString *savedImagePath = [[self applicationDocumentsDirectoryPath] stringByAppendingPathComponent:@"savedImage.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    BOOL flag=[imageData writeToFile:savedImagePath atomically:YES];
    
    return savedImagePath;
    
}


#pragma mark - operation status
-(void)doneBtnClicked:(id)sender
{
    editBtn.hidden=true;
    doneBtn.hidden=true;
    
    
  //  CGSize size=keyImageView.image.size;
    
 //   float ratio=self.frame.size.width/size.width;
    
    
    
    UIGraphicsBeginImageContextWithOptions(keyImageView.bounds.size, NO, 0.0); //retina res
    [[self layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();


    
   
    NSString *string=[self FM_saveImageAtDocumentDirectory:capturedImage];
    
    
    
    editBtn.hidden=false;
    doneBtn.hidden=false;
    
    [target performSelector:onSuccessFunc withObject:string afterDelay:0.01];

    [self removeFromSuperview];

}
-(void)backBtnClicked:(id)sender
{
    [target performSelector:onCancelFunc withObject:nil afterDelay:0.01];

    [self removeFromSuperview];
}
#pragma mark - events status
-(void)editBtnClicked:(id)sender
{
 
    
    [self setState:1];

}
-(void)EditingCancelBtnClicked:(id)sender
{
    
    
    
  //  [self setState:0];
    [field resignFirstResponder];
    [self backBtnClicked:nil];
    
    
}
-(void)EditingCorrectBtnClicked:(id)sender
{
    [self setState:2];
    
}
-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self convertRect:rawFrame fromView:nil];
    
    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));

    keyBoardBar.frame=CGRectMake(0, keyboardFrame.origin.y-50, self.frame.size.width, 50);
//    whiteColorBtn.center=CGPointMake(self.frame.size.width/2-25, keyboardFrame.origin.y-25);
  //  blackColorBtn.center=CGPointMake(self.frame.size.width/2+25, keyboardFrame.origin.y-25);

    [self textViewDidChange:field];
    
}
-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self convertRect:rawFrame fromView:nil];
    
    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
    
    keyBoardBar.frame=CGRectMake(0, 2*self.frame.size.height, self.frame.size.width, 50);

    [self EditingCorrectBtnClicked:nil];
    

}
-(void)alignmentToggle:(id)sender
{
    if(field.textAlignment==NSTextAlignmentCenter)
    {
        field.textAlignment=NSTextAlignmentLeft;
    }
    else if(field.textAlignment==NSTextAlignmentLeft)
    {
        field.textAlignment=NSTextAlignmentRight;
    }
    else if(field.textAlignment==NSTextAlignmentRight)
    {
        field.textAlignment=NSTextAlignmentCenter;
    }
    
}

-(void)fontSizePlus:(UIButton *)sender
{
    
    if(fontSize+1<60)
    {
        fontSize=fontSize+1;
    }
    
    
    field.font=[UIFont fontWithName:@"Avenir-Black" size:fontSize];
    [self textViewDidChange:field];

    
}
-(void)fontSizeMinus:(UIButton *)sender
{
    if(fontSize-1>12)
    {
        fontSize=fontSize-1;
    }
    
    field.font=[UIFont fontWithName:@"Avenir-Black" size:fontSize];
    [self textViewDidChange:field];

}
-(void)colorChoosen:(UIButton *)sender
{
    if(sender.tag==1)
    {
        field.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
        field.textColor=[UIColor blackColor];

       // whiteColorBtn.backgroundColor=[UIColor colorWithWhite:1.0f alpha:1.0f];
       // blackColorBtn.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.3f];
        
       // whiteColorBtn.layer.borderWidth=0;
       // blackColorBtn.layer.borderWidth=2;
        
        whiteColorBtn.transform=CGAffineTransformMakeScale(1, 1);
        blackColorBtn.transform=CGAffineTransformMakeScale(0.8, 0.8);
        
        field.layer.shadowColor = [[UIColor whiteColor] CGColor];

    }
    else
    {
        field.backgroundColor=[UIColor colorWithWhite:0 alpha:0];

        field.textColor=[UIColor whiteColor];
        
       // whiteColorBtn.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.3f];
       // blackColorBtn.backgroundColor=[UIColor colorWithWhite:0.0f alpha:1.0f];
        
       // whiteColorBtn.layer.borderWidth=2;
       // blackColorBtn.layer.borderWidth=0;
        
        whiteColorBtn.transform=CGAffineTransformMakeScale(0.8, 0.8);
        blackColorBtn.transform=CGAffineTransformMakeScale(1, 1);
        field.layer.shadowColor = [[UIColor blackColor] CGColor];

    }
}
-(void)textViewDidChange:(UITextView *)textView
{
    CGSize size = [textView sizeThatFits:CGSizeMake(self.frame.size.width-20, FLT_MAX)];
    float height=size.height;
    
    
    
    
    [UIView animateWithDuration:0.2 animations:^{
        field.frame=CGRectMake(10, 0, self.frame.size.width-20, height);

        field.center=CGPointMake(self.center.x, self.center.y-height/2-30);

    }];

}
-(void)addTextBtnClicked:(id)sender
{
    field.text=@"";

    [self setState:1];
}
-(void)setState:(int)number
{
    if(number==0) //Preview
    {
        editBtn.hidden=true;
        
        EditingCancelBtn.hidden=true;
        EditingCorrectBtn.hidden=true;
        keyBoardBar.hidden=true;
        field.hidden=true;
        
    }
    if(number==1)
    {
        
        editBtn.hidden=true;
        field.hidden=false;
        [field becomeFirstResponder];
        
        EditingCancelBtn.hidden=false;
        EditingCorrectBtn.hidden=false;
        
        keyBoardBar.hidden=false;
        field.userInteractionEnabled=true;

    }
    if(number==2)
    {
        

        EditingCancelBtn.hidden=true;
        EditingCorrectBtn.hidden=true;
        
        keyBoardBar.hidden=true;
        field.hidden=false;
        editBtn.hidden=false;
        
        field.userInteractionEnabled=false;
  //      field.editable=false;
        [field resignFirstResponder];

//        field.scrollEnabled=false;

    }
    
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    
    CGPoint location=[touch locationInView:self];
    CGPoint prevLocation=[touch previousLocationInView:self];
    
    CGPoint diff=CGPointMake(prevLocation.x-location.x, prevLocation.y-location.y);
    
    
    field.center=CGPointMake(field.center.x-diff.x, field.center.y-diff.y)  ;
    
    
}
-(UIButton *)setUpBtnWithTitle:(NSString *)str andSel:(SEL)selector
{
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    btn.titleLabel.font=[UIFont fontWithName:@"Avenir-Roman" size:12];
    
    btn.backgroundColor=[UIColor blackColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
    return btn;
}
-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];

}
@end
