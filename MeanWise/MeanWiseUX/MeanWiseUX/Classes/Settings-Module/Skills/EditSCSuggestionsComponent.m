//
//  EditSCSuggestionsComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 16/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "EditSCSuggestionsComponent.h"
#import "Constant.h"

@implementation EditSCSuggestionsComponent

-(void)setUp
{
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:blurEffectView];
    

    
    tagListTBL=[[UITableView alloc] initWithFrame:self.bounds];
    [self addSubview:tagListTBL];
    tagListTBL.delegate=self;
    tagListTBL.dataSource=self;
    //tagListTBL.separatorStyle=UITableViewCellSeparatorStyleNone;
    tagListTBL.backgroundColor=[UIColor clearColor];
    self.backgroundColor=[UIColor clearColor];
    tagListTBL.rowHeight=50;
  

    self.clipsToBounds=YES;
    
    isQueryForProfession=false;
    
}

-(void)sendQueryForProfession:(BOOL)flag;
{
    isQueryForProfession=flag;
}
-(void)setTerm:(NSString *)term
{
    searchTerm=term;
   
    if([term isEqualToString:@""])
    {
        [self clearAndHide];

    }
    else if(term.length>2)
    {
        if(isQueryForProfession==false)
        {
        manager=[[APIManager alloc] init];
        [manager sendRequestForAutoCompleteSkills:term Delegate:self andSelector:@selector(AutoCompleteResultReceived:)];
        }
        else
        {
            manager=[[APIManager alloc] init];
            
            [manager sendRequestForAutoCompleteProfessions:term Delegate:self andSelector:@selector(AutoCompleteResultReceived:)];
            
        }
    }
    
    
}
-(void)setUp:(id)targetReceived OnTagSelectCallBack:(SEL)func
{
    
    target=targetReceived;
    onTagSelectCallBack=func;
    
}
-(void)AutoCompleteResultReceived:(APIResponseObj *)responseObj
{
    //resultList=[[NSMutableArray alloc] initWithObjects:searchTerm, nil];
    resultList=[[NSMutableArray alloc] init];

    NSString *outputTerm=[responseObj.response valueForKey:@"searchTerm"];
    NSArray *output=[[[responseObj.response valueForKey:@"results"] valueForKey:@"results"] valueForKey:@"text"];

    
    if([searchTerm isEqualToString:outputTerm] && output.count>0)
    {
        self.hidden=false;

        [resultList addObjectsFromArray:output];
        [tagListTBL reloadData];
        
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, tagListTBL.rowHeight*output.count);
        

    }
    else
    {
        [self clearAndHide];
    }

    
    
    
}
-(void)clearAndHide
{
    self.hidden=true;

    resultList=[[NSMutableArray alloc] init];
    [tagListTBL reloadData];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [target performSelector:onTagSelectCallBack withObject:[resultList objectAtIndex:indexPath.row] afterDelay:0.01];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* cellIdentifier = @"CellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    cell.textLabel.text=[[resultList objectAtIndex:indexPath.row ] lowercaseString];
    
    
    cell.textLabel.font=[UIFont fontWithName:k_fontRegular size:20];
    cell.textLabel.textColor=[UIColor lightGrayColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    cell.backgroundColor=[UIColor clearColor];
    
    NSString *tem=[[resultList objectAtIndex:indexPath.row] lowercaseString];
    NSString *substring = [searchTerm lowercaseString];
    
    NSRange range;
    if ((range =[[tem lowercaseString] rangeOfString:[substring lowercaseString]]).location == NSNotFound)
    {
        cell.textLabel.attributedText=nil;
        cell.textLabel.text=tem;
    }
    else
    {
        NSMutableAttributedString *temString=[[NSMutableAttributedString alloc]initWithString:tem];
        [temString addAttribute:NSForegroundColorAttributeName
                          value:[UIColor blackColor]
                          range:(NSRange){range.location,substring.length}];
        
        [temString addAttribute:NSFontAttributeName
                          value:[UIFont fontWithName:k_fontRegular size:20]
                          range:(NSRange){range.location,substring.length}];
        
        cell.textLabel.text=@"";
        
        cell.textLabel.attributedText=temString;
        
    }
    
    
    
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return resultList.count;
}

@end
