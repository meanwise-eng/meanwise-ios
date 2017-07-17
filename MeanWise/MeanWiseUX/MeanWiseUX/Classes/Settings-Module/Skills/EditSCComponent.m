//
//  EditSkillsCustomComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "MessageContactCell.h"
#import "ChatThreadComponent.h"
#import "EditSCComponent.h"
#import "ViewController.h"
#import "FTIndicator.h"


@implementation EditSCComponent
-(void)setUp
{
    
    
    
    [self setUpNavBarAndAll];

    
    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0, 66+70, self.frame.size.width, 60)];
    [self addSubview:view1];
    view1.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    tagSearchField=[[UITextField alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, 60)];
    tagSearchField.backgroundColor=[UIColor clearColor];
    tagSearchField.textColor=[UIColor blackColor];
    tagSearchField.font=[UIFont fontWithName:k_fontSemiBold size:18];
    [view1 addSubview:tagSearchField];
    tagSearchField.adjustsFontSizeToFitWidth=YES;
    tagSearchField.placeholder=@"Enter skill and press 'Continue'";
    [tagSearchField addTarget:self action:@selector(searchTermChanged:) forControlEvents:UIControlEventEditingChanged];
    tagSearchField.delegate=self;

    tagSearchField.returnKeyType=UIReturnKeyContinue;

   
    
    tagListControl=[[EditSCTagListControl alloc] initWithFrame:CGRectMake(tagSearchField.frame.origin.x, view1.frame.origin.y+60, tagSearchField.frame.size.width,200)];
    [self addSubview:tagListControl];
    NSString *currentTag=@"Adobe Photoshop,illustrator,Idea";
    NSArray *array=[currentTag componentsSeparatedByString:@","];
    array=[UserSession getUserCustomSkills];
    
    NSMutableArray *arrayMain=[[NSMutableArray alloc] init];
    
    for(int i=0;i<[array count];i++)
    {
        NSString *string=[array objectAtIndex:i];

        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];

        [arrayMain addObject:string];
    }
    
    [tagListControl setUp:arrayMain];
    
    
    suggestionBox=[[EditSCSuggestionsComponent alloc] initWithFrame:CGRectMake(0, view1.frame.origin.y+60, self.frame.size.width,200)];
    
    [suggestionBox setUp];
    [suggestionBox setUp:self OnTagSelectCallBack:@selector(NewTagAddedFromSuggestion:)];
    [suggestionBox setTerm:@""];
    
    [self addSubview:suggestionBox];
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    NSString *string=[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if(![string isEqualToString:@""])
    {
    [self NewTagAdded:string];
        return false;

    }
    else
    {
        return true;
    }
}
-(void)searchTermChanged:(id)sender
{
    NSString *term=tagSearchField.text;
    [suggestionBox setTerm:term];
}


-(void)NewTagAddedFromSuggestion:(NSString *)string
{
    [self NewTagAdded:string];
}


-(void)NewTagAdded:(NSString *)tagName
{
    
    [tagListControl addNewTag:tagName];
    NSLog(@"New Tag : %@",tagName);
    tagSearchField.text=@"";
    [suggestionBox setTerm:@""];
    [tagSearchField resignFirstResponder];

}


#pragma mark = Helper
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
    navBarTitle.text=@"Skills";
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
    instructionField.text=@"Got any cool skills? List them here.";
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
    
 
    
   
    NSArray *finalArray=[tagListControl getCurrentTagList];
    
    if(finalArray.count<1)
    {
        [FTIndicator showToastMessage:@"Please enter atleast one skill"];

    }
    else if(finalArray.count>10)
    {
        [FTIndicator showToastMessage:@"You can enter maximum 10 skills."];

    }
    else
    {
//        NSMutableArray *allSkillsFormatter=[[NSMutableArray alloc] init];
//        for(int i=0;i<finalArray.count;i++)
//        {
//         
//            [allSkillsFormatter addObject:[NSString stringWithFormat:@"'%@'",[finalArray objectAtIndex:i]]];
//            
//        }
//        
//    NSString *updatedSkillsArray=[allSkillsFormatter componentsJoinedByString:@","];
//        updatedSkillsArray=[NSString stringWithFormat:@"[%@]",updatedSkillsArray];
//    
//        NSLog(@"%@",updatedSkillsArray);
        
        NSDictionary *dict=@{
                             @"skills_list":finalArray,
                             };
        
        UINavigationController *vc=(UINavigationController *)[Constant topMostController];
        ViewController *t=(ViewController *)vc.topViewController;
        [t updateProfileWithDict:dict];

    }
   
    
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
