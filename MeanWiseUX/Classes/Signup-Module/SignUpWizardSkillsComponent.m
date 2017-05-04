//
//  SignUpWizardName.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "SignUpWizardSkillsComponent.h"

@implementation SignUpWizardSkillsComponent

-(void)setUp
{
    self.backgroundColor=[UIColor clearColor];
    [Constant setUpGradient:self style:6];
    
    
    APIPoster *tester=[[APIPoster alloc] init];
    skillDBTagsArray=[tester getSkillsData];

   // skillTagsArray=[[NSArray alloc] initWithObjects:@"java",@"javascript",@"objective c",@"data entry",@"SEO",@"Android",@"NodeJS",@"Social Media",@"Logo Design",@"Marketting",@"PR",@"Consulting",@"Data Analysis",@"Database",@"Quality",@"Photography",@"Assitance",@"illustrations",@"Photoshop",@"Translations",@"WebTraffic",@"Graphics",@"C",@"C++",@"Twitter",@"Facebook",@"Writting",@"Dancing",@"Painting", nil];
    
    
//
    

    
    headLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 40)];
    [self addSubview:headLBL];
    headLBL.text=@"Enter your skills";
    headLBL.textColor=[UIColor whiteColor];
    headLBL.textAlignment=NSTextAlignmentLeft;
    headLBL.font=[UIFont fontWithName:k_fontAvenirNextHeavy size:28];
    headLBL.center=CGPointMake(self.frame.size.width/2, 140);
    
    subHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 60)];
    [self addSubview:subHeadLBL];
    subHeadLBL.numberOfLines=2;
    // subHeadLBL.text=@"Let your friends know you are here.";
    subHeadLBL.textColor=[UIColor whiteColor];
    subHeadLBL.textAlignment=NSTextAlignmentLeft;
    subHeadLBL.font=[UIFont fontWithName:k_fontSemiBold size:15];
    subHeadLBL.center=CGPointMake(self.frame.size.width/2, 180);
    
    
    backBtn=[[UIButton alloc] initWithFrame:CGRectMake(20,35, 22*1, 15*1)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackButton.png"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-15, -15, -15, -15)];
    
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    view.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:view];
    view.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-60);
    
    
    
    emailHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 15)];
    [self addSubview:emailHeadLBL];
    emailHeadLBL.text=@"ADD SKILL";
    emailHeadLBL.textColor=[UIColor whiteColor];
    emailHeadLBL.textAlignment=NSTextAlignmentLeft;
    emailHeadLBL.font=[UIFont fontWithName:k_fontSemiBold size:15];
    emailHeadLBL.center=CGPointMake(self.frame.size.width/2, 230);
    
    skillField=[Constant textField_Style1_WithRect:CGRectMake(20, 0, self.frame.size.width-40, 50)];
    [self addSubview:skillField];
    skillField.center=CGPointMake(self.frame.size.width/2, 230+45);
    skillField.delegate=self;
    skillField.returnKeyType=UIReturnKeyGo;
    skillField.font = [UIFont fontWithName:k_fontLight size:26.0f];
    [skillField addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
    
    skillValidationLbl=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 20)];
    [self addSubview:skillValidationLbl];
    skillValidationLbl.center=CGPointMake(self.frame.size.width/2, 310);
    skillValidationLbl.font=[UIFont fontWithName:k_fontExtraBold size:12];
    skillValidationLbl.textAlignment=NSTextAlignmentLeft;
    skillValidationLbl.text=@"Please enter atleast one skill.";
    skillValidationLbl.textColor=[UIColor yellowColor];
    skillValidationLbl.hidden=true;
    
    
    addSkillBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,0, 40, 40)];
   // [self addSubview:addSkillBtn];
    [addSkillBtn setTitle:@"+" forState:UIControlStateNormal];
    addSkillBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:30];
    
    [addSkillBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addSkillBtn addTarget:self action:@selector(newSkillBtnAdd:) forControlEvents:UIControlEventTouchUpInside];
    addSkillBtn.center=CGPointMake(self.frame.size.width-40, 230+45);

    
    emailBaseView=[[UIView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 1)];
    emailBaseView.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:emailBaseView];
    emailBaseView.center=CGPointMake(self.frame.size.width/2, 300);

    selectedTagListView=[[HMTagList alloc] initWithFrame:CGRectMake(20, skillField.center.y+25+100, self.frame.size.width-40, 200)];
    [self addSubview:selectedTagListView];
    [selectedTagListView setUp];
    
    skillSearchTableView=[[UITableView alloc] initWithFrame:CGRectMake(20, skillField.center.y+25, self.frame.size.width-40, 80)];
    skillSearchTableView.backgroundColor=[UIColor clearColor];
    [self addSubview:skillSearchTableView];
    skillSearchTableView.delegate=self;
    skillSearchTableView.dataSource=self;
    skillSearchTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
   
    skillSearchTableView.hidden=true;
    
    nextBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    nextBtn.layer.cornerRadius=20;
    [nextBtn addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"nextArrow.png"] forState:UIControlStateNormal];
    [self addSubview:nextBtn];
    
    nextBtn.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-30);
    nextBtn.enabled = false;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [filteredTagsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"CellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor colorWithWhite:1 alpha:0.1];
    cell.textLabel.text = [[filteredTagsArray objectAtIndex:indexPath.row] valueForKey:@"text"];
    cell.textLabel.textColor=[UIColor whiteColor];
    
    cell.textLabel.font=[UIFont fontWithName:k_fontLight size:22.0f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    skillField.text=@"";
    skillSearchTableView.hidden=true;

    [selectedTagListView addNewTag:[filteredTagsArray objectAtIndex:indexPath.row]];
    

    NSArray *array=[selectedTagListView getNumberOfTagsSelected];
    
    if(array.count>0)
    {
        nextBtn.enabled = true;
    }
    else{
        nextBtn.enabled = false;
    }
}




-(void)newSkillBtnAdd:(id)sender
{
    
    [skillField becomeFirstResponder];
    skillSearchTableView.hidden=true;
 
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidChange:(id)sender
{
    NSLog(@"%@",skillField.text);
    
    if(!skillValidationLbl.isHidden){
        skillValidationLbl.hidden = true;
        nextBtn.enabled = false;
    }
    
    if(skillField.text.length==0)
    {
        skillSearchTableView.hidden=true;

    }
    else
    {
        skillSearchTableView.hidden=false;
        
        NSMutableArray *tempArray=[[NSMutableArray alloc] init];
        
        for(int i=0;i<[skillDBTagsArray count];i++)
        {
            
            
            if([[[[skillDBTagsArray objectAtIndex:i] valueForKey:@"text"] lowercaseString] hasPrefix:[skillField.text lowercaseString]])
            {
                [tempArray addObject:[skillDBTagsArray objectAtIndex:i]];
            }
            
        }
        

        
        filteredTagsArray=[NSArray arrayWithArray:tempArray];
        [skillSearchTableView reloadData];
        

       
        
    }
    
}

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
    NSArray *array=[selectedTagListView getNumberOfTagsSelected];
    
    if(array.count>0)
    {
        skillValidationLbl.hidden = true;
        [DataSession sharedInstance].signupObject.skills=array;

        [delegate performSelector:Func_nextBtnClicked withObject:nil afterDelay:0.01];
    }
    else
    {
       // [Constant okAlert:@"" withSubTitle:@"Please enter atleast one skill." onView:self andStatus:-1];
        skillValidationLbl.hidden = false;
        nextBtn.enabled = false;
    }

   
}

-(void)backBtnClicked:(id)sender
{
    [delegate performSelector:Func_backBtnClicked withObject:nil afterDelay:0.01];

}

-(void)forgetPassBtnClicked:(id)sender
{
    
}

@end
