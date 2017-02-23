//
//  ProffesionComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 19/02/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ProffesionComponent.h"
#import "APIPoster.h"

@implementation ProffesionComponent

-(void)setTarge:(id)delegate andOnProffSelect:(SEL)func1;
{
    target=delegate;
    proSelectedFunc=func1;
    
}
-(void)setUp
{
    self.backgroundColor=[UIColor whiteColor];
    
    profArray=[[APIPoster alloc] getProffesionData];
    
    keyTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.frame.size.width, self.frame.size.height-70)];
    [self addSubview:keyTable];
    keyTable.delegate=self;
    keyTable.dataSource=self;
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return profArray.count;
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
    
    cell.textLabel.text = [[profArray objectAtIndex:indexPath.row] valueForKey:@"text"];
    cell.textLabel.font=[UIFont fontWithName:k_fontLight size:20];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



@end
