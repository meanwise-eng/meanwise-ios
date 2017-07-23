//
//  EditLocationComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "MessageContactCell.h"
#import "ChatThreadComponent.h"
#import "EditLocationComponent.h"
#import "UserSession.h"
#import "ViewController.h"
#import "ABCGooglePlace.h"
#import "ABCGooglePlacesAPIClient.h"
#import "ABCGoogleAutoCompleteResult.h"
#import "FTIndicator.h"

@implementation EditLocationComponent

-(void)setUp
{
    
    
    
    [self setUpNavBarAndAll];
    
    int fieldHeight=55;
    int startingTop=66+70;
    
    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0, startingTop, self.frame.size.width, fieldHeight)];
    [self addSubview:view1];
    view1.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    locationTXT=[[UITextField alloc] initWithFrame:CGRectMake(10, startingTop, self.frame.size.width-20, fieldHeight)];
    locationTXT.backgroundColor=[UIColor clearColor];
    locationTXT.textColor=[UIColor blackColor];
    locationTXT.font=[UIFont fontWithName:k_fontSemiBold size:15];
    [self addSubview:locationTXT];
    locationTXT.adjustsFontSizeToFitWidth=YES;
    locationTXT.placeholder=@"Location";
    
    locationTXT.autocorrectionType=UITextAutocorrectionTypeNo;
    locationTXT.spellCheckingType=UITextSpellCheckingTypeNo;
    [locationTXT addTarget:self action:@selector(searchTermChange:) forControlEvents:UIControlEventEditingChanged];
    locationTXT.delegate=self;
    locationTXT.returnKeyType=UIReturnKeyDone;

    
    NSString *location=[UserSession getCityLocation];
    
    if(location.class!=[NSNull class])
    {
        locationTXT.text=location;
    }
    
    resultContainerView=[[UIView alloc] initWithFrame:CGRectMake(0, locationTXT.frame.origin.y+locationTXT.frame.size.height, self.frame.size.width, 0)];
    
    [self addSubview:resultContainerView];
    resultContainerView.hidden=true;
    resultListView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, resultContainerView.frame.size.width, 0)];
    [resultContainerView addSubview:resultListView];
    resultListView.delegate=self;
    resultListView.dataSource=self;
    resultListView.rowHeight=50;
    resultContainerView.backgroundColor=[UIColor whiteColor];
    
    
    logoHeight=15;

    poweredByLogo=[[UIImageView alloc] initWithFrame:CGRectMake(resultContainerView.frame.size.width/2, 5, resultContainerView.frame.size.width/2, logoHeight)];
    [resultContainerView addSubview:poweredByLogo];
    poweredByLogo.image=[UIImage imageNamed:@"powered_by_google_on_white.png"];
    poweredByLogo.contentMode=UIViewContentModeScaleAspectFit;
    
    
    activityIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:activityIndicator];
    activityIndicator.center=CGPointMake(locationTXT.frame.size.width-40, locationTXT.frame.origin.y+25);
    activityIndicator.hidden=true;
    searchString=@"";

    

    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    resultContainerView.hidden=true;
    [locationTXT resignFirstResponder];
    
    return true;
}

-(void)searchTermChange:(id)sender
{
    NSString *searchWordProtection = [locationTXT.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (searchWordProtection.length != 0 && ![searchString isEqualToString:searchWordProtection]) {
        
        
        searchString=searchWordProtection;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        [activityIndicator startAnimating];
        activityIndicator.hidden=false;
        
        [self performSelector:@selector(search:) withObject:searchWordProtection afterDelay:1.5f];
        
        //  NSLog(@"%@",searchWordProtection);
        //  [self search:searchWordProtection];
        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [ABCGooglePlacesAPIClient sharedInstance].searchResults.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ABCGoogleAutoCompleteResult *autoCompleteResult = [[ABCGooglePlacesAPIClient sharedInstance].searchResults objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [resultListView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.font=[UIFont fontWithName:k_fontRegular size:15];

    [cell.textLabel setText:autoCompleteResult.city];
    //    [cell.detailTextLabel setText:autoCompleteResult.description];
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ABCGoogleAutoCompleteResult *autoCompleteResult = [[ABCGooglePlacesAPIClient sharedInstance].searchResults objectAtIndex:indexPath.row];
    
    locationTXT.text=autoCompleteResult.city;
    resultContainerView.hidden=true;
    [locationTXT resignFirstResponder];
}


-(void)search:(NSString *)string

{
    NSLog(@"API call for %@",string);
    
    [[ABCGooglePlacesAPIClient sharedInstance] retrieveGooglePlaceInformation:string withCompletion:^(BOOL isSuccess, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                
                NSLog(@"%@",error.description);
                [FTIndicator showToastMessage:error.localizedDescription];
                [activityIndicator stopAnimating];
                activityIndicator.hidden=true;
                resultContainerView.hidden=true;
                
                //                [self showError:error];
            }
            else if([ABCGooglePlacesAPIClient sharedInstance].searchResults.count==0)
            {
                
                [activityIndicator stopAnimating];
                activityIndicator.hidden=true;
                resultContainerView.hidden=true;
                
            }
            else
            {
                
                
                [activityIndicator stopAnimating];
                activityIndicator.hidden=true;
                resultContainerView.hidden=false;
                
                [resultListView reloadData];
                
                resultContainerView.frame=CGRectMake(locationTXT.frame.origin.x, locationTXT.frame.origin.y+locationTXT.frame.size.height, resultContainerView.frame.size.width, [ABCGooglePlacesAPIClient sharedInstance].searchResults.count*50+logoHeight+5);
                
                resultListView.frame=CGRectMake(0, logoHeight+5, resultContainerView.frame.size.width, [ABCGooglePlacesAPIClient sharedInstance].searchResults.count*50);
            }
            
        });
        
        
    }];
    
}

#pragma mark - Helper
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
    navBarTitle.text=@"Where are you?";
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
    instructionField.text=@"We promise we won’t stalk you";
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
                         @"city":locationTXT.text,
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
