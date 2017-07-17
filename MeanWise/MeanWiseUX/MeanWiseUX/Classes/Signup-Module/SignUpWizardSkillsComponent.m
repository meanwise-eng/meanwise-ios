//
//  SignUpWizardName.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "SignUpWizardSkillsComponent.h"
#import "FTIndicator.h"

@implementation SignUpWizardSkillsComponent

-(void)setUp
{
    self.backgroundColor=[UIColor clearColor];
    [Constant setUpGradient:self style:6];
    
    [self addSubview:[Constant createProgressSignupViewWithWidth:self.frame.size.width andProgress:0.4 toPercentage:0.6]];;

    

    int heightTop=100;
    
//    
    headLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 40)];
    [self addSubview:headLBL];
    headLBL.text=@"Enter your skills";
    headLBL.textColor=[UIColor whiteColor];
    headLBL.textAlignment=NSTextAlignmentLeft;
    headLBL.font=[UIFont fontWithName:k_fontAvenirNextHeavy size:28];
    headLBL.center=CGPointMake(self.frame.size.width/2, heightTop);

    subHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 60)];
    [self addSubview:subHeadLBL];
    subHeadLBL.numberOfLines=2;
    subHeadLBL.text=@"Got any cool skills? List them here.";
    subHeadLBL.textColor=[UIColor whiteColor];
    subHeadLBL.textAlignment=NSTextAlignmentLeft;
    subHeadLBL.font=[UIFont fontWithName:k_fontSemiBold size:15];
    subHeadLBL.center=CGPointMake(self.frame.size.width/2, heightTop+40);
    
    backBtn=[[UIButton alloc] initWithFrame:CGRectMake(20,35, 23*1.2, 16*1.2)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackButton.png"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-15, -15, -15, -15)];

    
    nextBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    nextBtn.layer.cornerRadius=20;
    nextBtn.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.6f];
    [nextBtn addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"nextArrow.png"] forState:UIControlStateNormal];
    [self addSubview:nextBtn];
    
    nextBtn.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-30);
    
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2)];
    view.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:view];
    view.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-60);
    
    
    
    skillHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 15)];
    [self addSubview:skillHeadLBL];
    skillHeadLBL.text=@"ADD SKILL";
    skillHeadLBL.textColor=[UIColor whiteColor];
    skillHeadLBL.textAlignment=NSTextAlignmentLeft;
    skillHeadLBL.font=[UIFont fontWithName:k_fontBold size:15];
    skillHeadLBL.center=CGPointMake(self.frame.size.width/2, heightTop+90);
    
    skillField=[Constant textField_Style1_WithRect:CGRectMake(20, 0, self.frame.size.width-40, 50)];
    [self addSubview:skillField];
    skillField.center=CGPointMake(self.frame.size.width/2, heightTop+90+45);
    skillField.returnKeyType=UIReturnKeyGo;
    [skillField addTarget:self
                      action:@selector(searchTermChanged:)
            forControlEvents:UIControlEventEditingChanged];

    skillField.returnKeyType=UIReturnKeyGo;

    skillField.delegate=self;

    addSkillBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,0, 40, 40)];
    [self addSubview:addSkillBtn];
    [addSkillBtn setTitle:@"+" forState:UIControlStateNormal];
    addSkillBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:25];

    [addSkillBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addSkillBtn addTarget:self action:@selector(newSkillBtnAdd:) forControlEvents:UIControlEventTouchUpInside];
    addSkillBtn.center=CGPointMake(self.frame.size.width-40, heightTop+90+45);

    
    skillBaseView=[[UIView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 1)];
    skillBaseView.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:skillBaseView];
    skillBaseView.center=CGPointMake(self.frame.size.width/2, heightTop+160);

  
    int height=skillField.frame.origin.y+50;
    
    tagListControl=[[EditSCTagListControl alloc] initWithFrame:CGRectMake(skillField.frame.origin.x, height, skillField.frame.size.width,self.frame.size.height-height-60)];
    [self addSubview:tagListControl];
//    NSString *currentTag=@"Adobe Photoshop,illustrator,Idea";
//    NSArray *array=[currentTag componentsSeparatedByString:@","];
//    
   // array=[UserSession getUserCustomSkills];
    [tagListControl setUp:[NSMutableArray arrayWithArray:[[NSArray alloc] init]]];
    tagListControl.backgroundColor=[UIColor clearColor];
    

    suggestionBox=[[EditSCSuggestionsComponent alloc] initWithFrame:tagListControl.frame];
    
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
    NSString *term=[skillField.text lowercaseString];
    [suggestionBox setTerm:term];
}

-(void)newSkillBtnAdd:(id)sender
{
 
    [self textFieldShouldReturn:skillField];
    
}


-(void)NewTagAddedFromSuggestion:(NSString *)string
{
    [self NewTagAdded:string];
}


-(void)NewTagAdded:(NSString *)tagName
{
    
    [tagListControl addNewTag:tagName];
    NSLog(@"New Tag : %@",tagName);
    skillField.text=@"";
    [suggestionBox setTerm:@""];
    [skillField resignFirstResponder];
    
}













#pragma mark - Navigation
-(void)setTarget:(id)target andFunc1:(SEL)func;
{
    delegate=target;
    Func_backBtnClicked=func;
    
}
-(void)setTarget:(id)target andFunc2:(SEL)func;
{
    delegate=target;
    Func_nextBtnClicked=func;
    
}
-(void)nextBtnClicked:(id)sender
{
    
    NSArray *array=[tagListControl getCurrentTagList];
    
    if(array.count>0)
    {
        [DataSession sharedInstance].signupObject.skills=array;
        
        [delegate performSelector:Func_nextBtnClicked withObject:nil afterDelay:0.01];

    }
    else
    {
        [FTIndicator showToastMessage:@"Please enter atleast one skill."];
        [skillField becomeFirstResponder];
        
    }
  /*  NSArray *array=[selectedTagListView getNumberOfTagsSelected];
    
    if(array.count>0)
    {
    }
    else
    {
        [Constant okAlert:@"Alert!" withSubTitle:@"Please enter atleast one skill." onView:self andStatus:-1];
    }*/

   
}

-(void)backBtnClicked:(id)sender
{
    [delegate performSelector:Func_backBtnClicked withObject:nil afterDelay:0.01];

}



@end
