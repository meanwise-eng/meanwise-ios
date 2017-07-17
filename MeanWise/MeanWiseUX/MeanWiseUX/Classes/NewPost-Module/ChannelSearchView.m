//
//  ChannelSearchView.m
//  MeanWiseUX
//
//  Created by Hardik on 29/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "ChannelSearchView.h"
#import "ChannelCell.h"

@implementation ChannelSearchView

-(NSArray *)getChannelData
{
    NSArray *channelList=[[[APIPoster alloc] init] getInterestData];

    NSMutableArray *listWithColor=[[NSMutableArray alloc] init];
    for(int i=0;i<channelList.count;i++)
    {
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:[channelList objectAtIndex:i]];
        
        [dict setObject:[NSNumber numberWithInt:i%14] forKey:@"colorNumber"];
        
        [listWithColor addObject:[NSDictionary dictionaryWithDictionary:dict]];
    }
    
    return [NSArray arrayWithArray:listWithColor];
}
-(int)getSelectedChannelId
{
    return selectedChannelId;
}
-(void)setUp
{
    
    
    masterData=[self getChannelData];
    
    resultData=[NSArray arrayWithArray:masterData];
    
    fullFrameOther=CGRectMake(0, self.frame.size.height*2, self.frame.size.width, self.frame.size.height);
    fullFrame=self.bounds;
    
    
    selectedChannelId=-1;
    
    
    selectionMasterView=[[UIView alloc] initWithFrame:fullFrameOther];
    [self addSubview:selectionMasterView];
    
    
    searchBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 70)];
    searchBar.backgroundColor=[UIColor whiteColor];
    [selectionMasterView addSubview:searchBar];
    
    searchFieldBG=[[UIView alloc] initWithFrame:CGRectMake(10, 25, self.frame.size.width-20, 30)];
    searchFieldBG.backgroundColor=[UIColor colorWithRed:0.92 green:0.94 blue:0.95 alpha:1.00];
    [selectionMasterView addSubview:searchFieldBG];
    searchFieldBG.layer.cornerRadius=15;

    
    feedTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.frame.size.width, self.frame.size.height-70)];
    [selectionMasterView addSubview:feedTable];
    feedTable.delegate=self;
    feedTable.dataSource=self;
    feedTable.backgroundColor=[UIColor whiteColor];
    feedTable.layoutMargins = UIEdgeInsetsZero;
    
    
    searchField=[[UITextField alloc] initWithFrame:CGRectMake(30, 25, self.frame.size.width-60, 30)];
    searchField.backgroundColor=[UIColor clearColor];
    [selectionMasterView addSubview:searchField];
    searchField.placeholder=@"Search";
    searchField.textColor=[UIColor grayColor];
    searchField.font=[UIFont fontWithName:k_fontSemiBold size:15];
    
    [searchField addTarget:self action:@selector(searchTermChange:) forControlEvents:UIControlEventEditingChanged];
    
}
-(void)searchTermChange:(id)sender
{
    NSString *string=searchField.text;
    
    if(string.length!=0)
    {
    NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K beginswith[cd] %@", @"name", string];//keySelected is NSString itself
    NSLog(@"predicate %@",predicateString);
    
    resultData = [NSArray arrayWithArray:[masterData filteredArrayUsingPredicate:predicateString]];

    }
    else
    {
        resultData=[NSArray arrayWithArray:masterData];
    }

    [feedTable reloadData];
    
}
-(void)setState1Frame:(CGRect)frame
{
    shortFrame=frame;
    shortFrameOther=CGRectMake(shortFrame.origin.x-shortFrame.size.width, shortFrame.origin.y, shortFrame.size.width, shortFrame.size.height);

    self.frame=frame;
    
    buttonSelect=[[UIButton alloc] initWithFrame:self.bounds];
    [self addSubview:buttonSelect];
    [buttonSelect addTarget:self action:@selector(btnOpenClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    selectedCellImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 40, 40)];
    [buttonSelect addSubview:selectedCellImage];
    //selectedCellImage.image=[UIImage imageNamed:@"post_1.jpeg"];
    selectedCellImage.layer.cornerRadius=2;
    selectedCellImage.clipsToBounds=YES;
    selectedCellImage.backgroundColor=[UIColor colorWithRed:0.00 green:0.76 blue:0.89 alpha:1.00];
    
    selectedCellImageOverLay=[[UIView alloc] initWithFrame:selectedCellImage.frame];
    [buttonSelect addSubview:selectedCellImageOverLay];
    selectedCellImageOverLay.alpha=0.5;
    
    selectedCellTitle=[[UILabel alloc] initWithFrame:CGRectMake(70, 5, frame.size.width-70, 50)];
    [buttonSelect addSubview:selectedCellTitle];
    selectedCellTitle.font=[UIFont fontWithName:k_fontSemiBold size:16];
    selectedCellTitle.text=@"Choose Channel";
    selectedCellTitle.textColor=[UIColor colorWithRed:0.00 green:0.76 blue:0.89 alpha:1.00];;
    
    
    nextArrowImage=[[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-50, 10, 40, 40)];
    [buttonSelect addSubview:nextArrowImage];
    nextArrowImage.image=[UIImage imageNamed:@"nextArrowBlack.png"];
    nextArrowImage.contentMode=UIViewContentModeScaleAspectFit;
    
 
    [self sendSubviewToBack:buttonSelect];
    
}
-(void)btnOpenClicked:(id)sender
{
    self.frame=fullFrame;
    
    buttonSelect.frame=shortFrame;

    [self.superview bringSubviewToFront:self];
    
    resultData=[NSArray arrayWithArray:masterData];
    
    [feedTable reloadData];

    searchField.text=@"";
    
    [UIView animateWithDuration:0.5 animations:^{
        
        buttonSelect.frame=shortFrameOther;
        selectionMasterView.frame=fullFrame;
        
    }];
    
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return resultData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"CellIdentifier";
    ChannelCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ChannelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *name=[[resultData objectAtIndex:indexPath.row] valueForKey:@"name"];
    int number=[[[resultData objectAtIndex:indexPath.row] valueForKey:@"colorNumber"] intValue];
    NSString *urlString=[[resultData objectAtIndex:indexPath.row] valueForKey:@"photo"];

    [cell setName:name andNumber:number];
    [cell setImageURL:urlString];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ChannelCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    selectedCellTitle.textColor=[cell getColorOfCell];
    selectedCellTitle.text=[[resultData objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    selectedChannelId=[[[resultData objectAtIndex:indexPath.row] valueForKey:@"id"] intValue];

    int imageNo=[cell getImageNumberOfColor];
    UIColor *color1=[Constant colorGlobal:(imageNo%14)];

    selectedCellImage.image=[cell getImage];
    selectedCellImage.contentMode=UIViewContentModeScaleAspectFill;

    selectedCellImageOverLay.backgroundColor=color1;

    
    [self hideControl];
    
}
-(void)hideControl
{
    [searchField resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        buttonSelect.frame=shortFrame;
        selectionMasterView.frame=fullFrameOther;
        
    } completion:^(BOOL finished) {
        
        self.frame=shortFrame;
        buttonSelect.frame=self.bounds;
        
    }];
    
 
    /*
    self.frame=fullFrame;
    
    buttonSelect.frame=shortFrame;
    
    [UIView animateWithDuration:1.0 animations:^{
        
        buttonSelect.frame=CGRectMake(shortFrame.origin.x-shortFrame.size.width, shortFrame.origin.y, shortFrame.size.width, shortFrame.size.height);
        
        selectionMasterView.frame=fullFrame;
        
    }];
     */
}

@end
