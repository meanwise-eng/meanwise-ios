//
//  LineProgressBar.h
//  ExactApp
//
//  Created by Hardik on 11/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LineProgressBar : UIView
{
    
    float valueP;

    UIView *baseProgressView1;

    UIView *progressView1;
    
    UILabel *labelMark1;
    
}

-(void)setUp;


-(void)resetZero;
-(void)setProValue:(float)value;
-(float)getProValue;

//-(void)setValueForProgress:(float)value;
//-(void)setValueZero;
//-(void)setValuehalf;



@end


//TODO ; Dislay points , timings
//minimum time


//Doubleview;