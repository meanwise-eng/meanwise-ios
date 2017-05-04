//
//  FirstLaunchScreen.h
//  MeanWiseUX
//
//  Created by Hardik on 29/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstLaunchScreen : UIView
{

    NSMutableArray *arrayStack;
    
    id delegate;
    SEL Func_signInFinished;
}
-(void)setUp;
-(void)walkthroughSkipped:(id)sender;

-(void)setTarget:(id)target withFunction:(SEL)func;

/*
 -Forget Password Alert
 -Keyboard type in every field
 -skills and tags - https://github.com/arsonic/AVTagTextView
 -Interest choose
 -Appearance Page - photo
 -Show progress bar
 -Invite friends
 
 -Resize Mechanism- Resolution independent
 -Swap home screen icon positions
 -Splash Screen
 
 
 
 */

/*
 
 1 - name
 2 - tell us a bit more
 3 - skills
 4 - interests
 5 - profile
 6 - appearance
 7 - invite friends
 
 
 */



@end

