//
//  EditTagSearchResultComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 29/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "EditTagSearchResultComponent.h"
#import "APIPoster.h"

@implementation EditTagSearchResultComponent
-(void)setUp:(id)targetReceived OnTagSelectCallBack:(SEL)func
{
    
    target=targetReceived;
    onTagSelectCallBack=func;
    
    tagList=[[APIPoster alloc] getSkillsData];

    tagListTBL=[[UITableView alloc] initWithFrame:self.bounds];
    [self addSubview:tagListTBL];
    tagListTBL.delegate=self;
    tagListTBL.dataSource=self;
    

    
    
}
-(void)setSearchTerm:(NSString *)term withCurrentArray:(NSArray *)array
{
    searchTerm=term;
    currentTagList=array;
    
    if([term isEqualToString:@""])
    {
        self.hidden=true;
    }
    else
    {
        self.hidden=false;
    }
    resultList=[[NSMutableArray alloc] init];

    

    for(NSDictionary *dict in tagList)
    {
    
        if([[[dict valueForKey:@"text"] lowercaseString] containsString:[term lowercaseString]])
        {
            [resultList addObject:dict];
        }
    
    }
    
    [resultList removeObjectsInArray:currentTagList];
    
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
    
    
    
    cell.textLabel.text=[[[resultList objectAtIndex:indexPath.row] valueForKey:@"text"] lowercaseString];
    
    
    cell.textLabel.font=[UIFont fontWithName:k_fontSemiBold size:20];
    cell.textLabel.textColor=[UIColor lightGrayColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    NSString *tem=[[[resultList objectAtIndex:indexPath.row] valueForKey:@"text"] lowercaseString];
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
                          value:[UIFont fontWithName:k_fontBold size:20]
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
