//
//  EditProffesionComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "MessageContactCell.h"
#import "ChatThreadComponent.h"
#import "EditProffesionComponent.h"
#import "UserSession.h"
#import "ViewController.h"

@implementation EditProffesionComponent

-(void)setUp
{
    
    
    
    APIPoster *tester=[[APIPoster alloc] init];

    dataArray=[tester getProffesionData];
    
    [self setUpNavBarAndAll];
    
    int fieldHeight=55;
    int startingTop=66+70;
    
    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0, startingTop, self.frame.size.width, fieldHeight)];
    [self addSubview:view1];
    view1.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    proffesionTXT=[[UITextField alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, fieldHeight)];
    proffesionTXT.backgroundColor=[UIColor clearColor];
    proffesionTXT.textColor=[UIColor blackColor];
    proffesionTXT.font=[UIFont fontWithName:k_fontSemiBold size:12];
    [view1 addSubview:proffesionTXT];
    proffesionTXT.adjustsFontSizeToFitWidth=YES;
    proffesionTXT.placeholder=@"Profession";
    proffesionTXT.text=[UserSession getProffesion];
    [proffesionTXT addTarget:self action:@selector(searchTextChangeEvent:) forControlEvents:UIControlEventEditingChanged];
    
    
    optionsTable=[[UITableView alloc] initWithFrame:CGRectMake(0, startingTop+fieldHeight, self.frame.size.width, self.frame.size.height-fieldHeight-startingTop)];
    [self addSubview:optionsTable];
    
    optionsTable.delegate=self;
    optionsTable.dataSource=self;
    
    optionsTable.hidden=true;

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // msgContactTable.bounces=false;
    
}
-(void)searchTextChangeEvent:(id)sender
{
    NSLog(@"%@",proffesionTXT.text);
    
    NSString *searchTerm=[proffesionTXT.text lowercaseString];
    
    if([searchTerm isEqualToString:@""])
    {
        
        searchResult=[NSArray arrayWithArray:dataArray];
    }
    else
    {
        
        NSMutableArray *array=[[NSMutableArray alloc] init];
        
        for(int i=0;i<[dataArray count];i++)
        {
            NSDictionary *dict=[dataArray objectAtIndex:i];
            
            if([[[dict valueForKey:@"text"] lowercaseString] containsString:searchTerm])
            {
                [array addObject:dict];
            }
        }
        
        searchResult=[NSArray arrayWithArray:array];
    }
    
    
    [optionsTable reloadData];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return searchResult.count;
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
    
    cell.textLabel.text = [[searchResult objectAtIndex:indexPath.row] valueForKey:@"text"];
    cell.textLabel.font=[UIFont fontWithName:k_fontSemiBold size:15];
    cell.textLabel.textColor=[UIColor lightGrayColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    NSString *tem=[[searchResult objectAtIndex:indexPath.row] valueForKey:@"text"];
    NSString *substring = proffesionTXT.text;

    NSRange range;
    if ((range =[[tem lowercaseString] rangeOfString:[substring lowercaseString]]).location == NSNotFound)
    {
        cell.textLabel.attributedText=nil;
        cell.textLabel.text=tem;
        NSLog(@"string does not contain base mix");
    }
    else
    {
        NSMutableAttributedString *temString=[[NSMutableAttributedString alloc]initWithString:tem];
        [temString addAttribute:NSForegroundColorAttributeName
                          value:[UIColor blackColor]
                          range:(NSRange){range.location,substring.length}];
        NSLog(@"%@",temString);
        cell.textLabel.text=@"";

        cell.textLabel.attributedText=temString;

    }


    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    selectedProffesionId=[[searchResult objectAtIndex:indexPath.row] valueForKey:@"id"];
//    NSLog(@"%@",);
        [proffesionTXT resignFirstResponder];
    proffesionTXT.text=[[searchResult objectAtIndex:indexPath.row] valueForKey:@"text"];
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
    navBarTitle.text=@"Profession";
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
    instructionField.text=@"This is your elevator pitch. Tell the world what you are good at. Bragging is allowed.";
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
 
    NSDictionary *dict=@{
                         @"profession":selectedProffesionId,
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
-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self convertRect:rawFrame fromView:nil];
    
    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
    
  //  keyBoardBar.frame=CGRectMake(0, keyboardFrame.origin.y-50, self.frame.size.width, 50);
    //    whiteColorBtn.center=CGPointMake(self.frame.size.width/2-25, keyboardFrame.origin.y-25);
    //  blackColorBtn.center=CGPointMake(self.frame.size.width/2+25, keyboardFrame.origin.y-25);
    
   // [self textViewDidChange:field];
    [self searchTextChangeEvent:nil];
    
    optionsTable.hidden=false;

}
-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self convertRect:rawFrame fromView:nil];
    
    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
    
  //  keyBoardBar.frame=CGRectMake(0, 2*self.frame.size.height, self.frame.size.width, 50);
    
   // [self EditingCorrectBtnClicked:nil];
        optionsTable.hidden=true;
    
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