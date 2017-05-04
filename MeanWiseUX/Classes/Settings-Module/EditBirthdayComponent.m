//
//  EditBirthdayComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "MessageContactCell.h"
#import "ChatThreadComponent.h"
#import "EditBirthdayComponent.h"
#import "ViewController.h"


@implementation EditBirthdayComponent

-(void)setUp
{
    
    
    
    
    
    
    [self setUpNavBarAndAll];
    
    int fieldHeight=55;
    int startingTop=66+70;

    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0, startingTop, self.frame.size.width, fieldHeight)];
    [self addSubview:view1];
    view1.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    

    
    
    birthdateTXT=[[UITextField alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, fieldHeight)];
    birthdateTXT.backgroundColor=[UIColor clearColor];
    birthdateTXT.textColor=[UIColor blackColor];
    birthdateTXT.font=[UIFont fontWithName:k_fontSemiBold size:12];
    [view1 addSubview:birthdateTXT];
    birthdateTXT.adjustsFontSizeToFitWidth=YES;
    birthdateTXT.placeholder=@"Choose Birthday";
    birthdateTXT.userInteractionEnabled=false;
    //birthdateTXT.text=[UserSession getBirthDate];
    
    
    UIDatePicker *datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0, startingTop+(fieldHeight+1),self.frame.size.width, 300)];
    datePicker.datePickerMode=UIDatePickerModeDate;
    datePicker.hidden=NO;
    datePicker.maximumDate=[NSDate date];
    datePicker.date=[NSDate date];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:datePicker];
    datePicker.tintColor=[UIColor purpleColor];
    
    
    
    
    
    NSDate *currentBdate=[self getBirthDateFromString:[UserSession getBirthDate]];
    
    NSString *displayFormat=[self getStringFromDate:currentBdate];
    
    birthdateTXT.text=displayFormat;
    
    datePicker.date=currentBdate;
    dateSelected=currentBdate;
    
    // msgContactTable.bounces=false;
    
}
-(NSString *)getStringFromDate:(NSDate *)date
{

    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"MMM d, yyyy"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:date]];
    
    return str;

    
}
-(NSDate *)getBirthDateFromString:(NSString *)string
{
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    
    [dateFormat setDateFormat:@"YYYY-M-d"];
    
    NSDate *date=[dateFormat dateFromString:string];
    
    return date;
    
}
-(void)dateChanged:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"MMM d, yyyy"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:sender.date]];
    //assign text to label
    birthdateTXT.text=str;

    dateSelected=sender.date;
    
}

-(void)setUpNavBarAndAll
{
    self.blackOverLayView=[[UIImageView alloc] initWithFrame:CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    
    self.blackOverLayView.backgroundColor=[UIColor blackColor];
    [self addSubview:self.blackOverLayView];
    self.blackOverLayView.alpha=0;
    
    
    navBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 65)];
    [self addSubview:navBar];
    navBar.backgroundColor=[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
    
    UIView *seperator=[[UIView alloc] initWithFrame:CGRectMake(0,65,self.frame.size.width, 1)];
    [self addSubview:seperator];
    seperator.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1.0f];
    
    navBarTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 65-20)];
    [navBar addSubview:navBarTitle];
    navBarTitle.text=@"Birthday";
    navBarTitle.textColor=[UIColor colorWithRed:0.59 green:0.11 blue:1.00 alpha:1.00];
    navBarTitle.textAlignment=NSTextAlignmentCenter;
    navBarTitle.font=[UIFont fontWithName:k_fontSemiBold size:18];
    
    
    
    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 60, 25, 25)];
    [backBtn setShowsTouchWhenHighlighted:YES];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackPlainForNav.png"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    
    backBtn.center=CGPointMake(10+25/2, 20+65/2-10);
    
    instructionField=[[UILabel alloc] initWithFrame:CGRectMake(30, 66, self.frame.size.width-60, 70)];
    instructionField.backgroundColor=[UIColor whiteColor];
    instructionField.font=[UIFont fontWithName:k_fontBold size:11];
    instructionField.textAlignment=NSTextAlignmentCenter;
    instructionField.text=@"Select your birth date";
    instructionField.textColor=[UIColor lightGrayColor];
    [self addSubview:instructionField];
    instructionField.numberOfLines=3;
    
    saveBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 50)];
    [self addSubview:saveBtn];
    [saveBtn setTitle:@"SAVE" forState:UIControlStateNormal];
    saveBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:17];
    saveBtn.backgroundColor=[UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:1.00];

    [saveBtn addTarget:self action:@selector(saveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)saveBtnClicked:(id)sender
{
 
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    
    [dateFormat setDateFormat:@"dd"];
    NSString *str1=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:dateSelected]];
    
    
    [dateFormat setDateFormat:@"M"];
    NSString *str2=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:dateSelected]];
    
    [dateFormat setDateFormat:@"yyyy"];
    NSString *str3=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:dateSelected]];
    
    NSString *finalDate=[NSString stringWithFormat:@"%@-%@-%@",str3,str2,str1];
    

    
    NSDictionary *dict=@{
                         @"dob":finalDate,
                         };
    
    UINavigationController *vc=(UINavigationController *)[Constant topMostController];
    ViewController *t=(ViewController *)vc.topViewController;
    [t updateProfileWithDict:dict];
}

-(void)setTarget:(id)target andBackFunc:(SEL)func
{
    delegate=target;
    backBtnClicked=func;
    
}
-(void)backBtnClicked:(id)sender
{
    [delegate performSelector:backBtnClicked withObject:nil afterDelay:0.02];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}





@end
