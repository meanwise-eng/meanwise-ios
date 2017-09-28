//
//  TopicAutoCompleteControl.m
//  MeanWiseUX
//
//  Created by Hardik on 10/08/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "TopicAutoCompleteControl.h"
#import "Constant.h"
#import "FTIndicator.h"
#import "APIManager.h"

@implementation TopicAutoCompleteControl

-(void)setTarget:(id)targetRec onCloseFunc:(SEL)func;
{
    target=targetRec;
    onCloseFunc=func;
    
}
-(void)setUp:(CGRect)rect withData:(NSMutableArray *)array;
{
    smallRect=self.frame;
    
    fullRect=rect;

   
    self.clipsToBounds=YES;
    
    self.backgroundColor=[UIColor whiteColor];
    

    [self setUpNavBar];

 
    
    int topBar=60;
    
    searchBar=[[UIView alloc] initWithFrame:CGRectMake(0, topBar, fullRect.size.width, 70)];
    searchBar.backgroundColor=[UIColor whiteColor];
    [self addSubview:searchBar];
    
    searchFieldBG=[[UIView alloc] initWithFrame:CGRectMake(10, topBar+25, fullRect.size.width-20, 30)];
    searchFieldBG.backgroundColor=[UIColor colorWithRed:0.92 green:0.94 blue:0.95 alpha:1.00];
    [self addSubview:searchFieldBG];
    searchFieldBG.layer.cornerRadius=15;
    
    searchField=[[UITextField alloc] initWithFrame:CGRectMake(30, topBar+25, fullRect.size.width-60, 30)];
    searchField.backgroundColor=[UIColor clearColor];
    [self addSubview:searchField];
    searchField.placeholder=@"Enter Topic";
    searchField.textColor=[UIColor grayColor];
    searchField.font=[UIFont fontWithName:k_fontSemiBold size:15];
    searchField.delegate=self;
    
    [searchField addTarget:self action:@selector(searchTermChange:) forControlEvents:UIControlEventEditingChanged];
    [searchField addTarget:self action:@selector(searchTermFinish:) forControlEvents:UIControlEventEditingDidEndOnExit];

    
  
  
  
  

    
    
    tagListArray=[[NSMutableArray alloc] init];
    
    for(int i=0;i<array.count;i++)
    {
        NSDictionary *dict=@{@"id":@(-1),@"text":[array objectAtIndex:i]};

        [tagListArray addObject:dict];
    }
    
    tagList=[[EditTagListControl alloc] initWithFrame:CGRectMake(0, topBar+25+40, fullRect.size.width, fullRect.size.height-25-40-topBar)];
    [tagList setUp:tagListArray];
    [self addSubview:tagList];


    
    suggestionView=[[SuggestionBox alloc] initWithFrame:CGRectMake(0, topBar+25+30, fullRect.size.width, fullRect.size.height-topBar-25-30)];
    [self addSubview:suggestionView];
    [suggestionView setUp];
    suggestionView.hidden=true;
    [suggestionView setTarget:self onSelect:@selector(onSuggestioinSelect:)];


    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame=fullRect;
        
    } completion:^(BOOL finished) {
        
        [searchField becomeFirstResponder];
    }];
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ( [string isEqualToString:@" "] ){
        return NO;
    }
    else {
        return YES;
    }
}
-(void)onSuggestioinSelect:(NSString *)string
{
    [searchField resignFirstResponder];
    suggestionView.hidden=true;
    searchField.text=string;
    [self searchTermFinish:nil];
}
-(void)searchTermChange:(id)sender
{
        [suggestionView searchTermChange:searchField.text];
        suggestionView.hidden=false;
  
    
}
-(void)searchTermFinish:(id)sender
{
    

    NSString *string=[searchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    string=[string stringByReplacingOccurrencesOfString:@" " withString:@""];

    int flag=0;
    
    tagListArray=[NSMutableArray arrayWithArray:[tagList getCurrentTagList]];
    
    for(int i=0;i<tagListArray.count;i++)
    {
        NSString *oldR=[[[tagListArray objectAtIndex:i] valueForKey:@"text"] lowercaseString];
        
        if([oldR isEqualToString:[string lowercaseString]])
        {
            flag=1;
        }
        
    }
    

    
    if(flag==1)
    {
        [FTIndicator showToastMessage:@"Already added"];

    }
    else if(tagListArray.count>3)
    {
        [FTIndicator showToastMessage:@"You can add maximum 3 topics!"];

    }
    else
    {
        NSDictionary *dict=@{@"id":@(-1),@"text":string};
        [tagList addNewTag:dict];
        tagListArray=[NSMutableArray arrayWithArray:[tagList getCurrentTagList]];
        searchField.text=@"";
        suggestionView.hidden=true;
    }
    
        
    
    
   

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(void)setUpNavBar
{
    title=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, fullRect.size.width, 40)];
    [self addSubview:title];
    title.text=@"Add Topics";
    title.textAlignment=NSTextAlignmentCenter;
    title.font=[UIFont fontWithName:k_fontSemiBold size:20];
    title.textColor=[UIColor blackColor];
    
    
    cancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(5, 20, 80, 40)];
    [self addSubview:cancelBtn];
    
    doneBtn=[[UIButton alloc] initWithFrame:CGRectMake(fullRect.size.width-80-10, 20, 80, 40)];
    [self addSubview:doneBtn];

    cancelBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:15];
    doneBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:15];

    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];

    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    
}

-(void)cancelBtnClicked:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.frame=smallRect;
        
    } completion:^(BOOL finished) {
        
        [searchField resignFirstResponder];
        
        
        
        [target performSelector:onCloseFunc withObject:nil afterDelay:0.01];
        
    }];
    
}

-(void)doneBtnClicked:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.frame=smallRect;
        
    } completion:^(BOOL finished) {
        
        [searchField resignFirstResponder];

        tagListArray=[NSMutableArray arrayWithArray:[tagList getCurrentTagList]];

        NSArray *array=[tagListArray valueForKey:@"text"];
        
        [target performSelector:onCloseFunc withObject:array afterDelay:0.01];
        
    }];
    
}


@end
@implementation SuggestionBox

-(void)setSearchRect:(CGRect)frame;
{
    searchBoxRect=frame;
}
-(void)setUp
{
    self.backgroundColor=[UIColor whiteColor];
    
    searchString=@"";
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:blurEffectView];

    
    resultListView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:resultListView];
    resultListView.delegate=self;
    resultListView.dataSource=self;
    resultListView.rowHeight=50;
    resultListView.backgroundColor=[UIColor clearColor];
    resultListView.tableFooterView=[[UIView alloc] init];
    
}
-(void)searchTermChange:(NSString *)newString
{
    NSString *searchWordProtection = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (searchWordProtection.length != 0 && ![searchString isEqualToString:searchWordProtection]) {
        
        
        searchString=searchWordProtection;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        
        [self performSelector:@selector(search:) withObject:searchWordProtection afterDelay:0.01];
        
        
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return resultData.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [resultListView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text=[resultData objectAtIndex:indexPath.row];
    
    //    [cell.textLabel setText:autoCompleteResult.city];
    //    [cell.detailTextLabel setText:autoCompleteResult.description];
    
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont fontWithName:k_fontRegular size:14];
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [target performSelector:onSuggestionSelect withObject:[resultData objectAtIndex:indexPath.row] afterDelay:0.01];
    
}

-(void)setTarget:(id)targetReceived onSelect:(SEL)func
{
    target=targetReceived;
    onSuggestionSelect=func;
}
-(void)search:(NSString *)string
{
    NSLog(@"API call for %@",string);
    
    NSDictionary *dict=@{@"topic":string};

    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestExploreAutoCompleteAPI:dict Withdelegate:self andSelector:@selector(autoCompleteAPIReceived:)];

}
-(void)autoCompleteAPIReceived:(APIResponseObj *)responseObj
{
    if(responseObj.statusCode==200)
    {
        
        resultData=[[NSMutableArray alloc] initWithArray:(NSArray *)responseObj.response];
        
        if(![resultData containsObject:searchString])
        {
            [resultData insertObject:searchString atIndex:0];
        }
        
        [resultListView reloadData];
        NSLog(@"%@",responseObj.response);
    }
    
}
-(void)search2:(NSString *)string

{
    NSLog(@"API call for %@",string);
    
    
    NSString *path=[NSString stringWithFormat:@"query=%@",string];
    
    
    
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",@"https://autocomplete.clearbit.com/v1/companies/suggest?",path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
    
    
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    // NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //[urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    
                    resultData =[NSJSONSerialization
                                 JSONObjectWithData:data
                                 options:kNilOptions
                                 error:nil];
                    [resultListView reloadData];
                    
                    
                });
                
            }
        }
        else
        {
            NSLog(@"Error %ld",error.code);
            NSLog(@"Error %@",error.localizedDescription);
        }
        
        
        
    }];
    
    [postDataTask resume];
    
}
@end
