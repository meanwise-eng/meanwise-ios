//
//  EditInterestsComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "MessageContactCell.h"
#import "ChatThreadComponent.h"
#import "EditInterestsComponent.h"
#import "UserSession.h"
#import "ViewController.h"
#import "InterestCell.h"

@implementation EditInterestsComponent

-(void)setUp
{
    
    selectedArray=[[NSMutableArray alloc] init];
    
    dbData=[[[APIPoster alloc] init] getInterestData];

    [selectedArray addObjectsFromArray:[UserSession getUserInterests]];
    
    numberOfItemSelected=(int)selectedArray.count;

    
    [self setUpNavBarAndAll];
    //[UserSession getProffesion];
    
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    
    
    CGRect collectionViewFrame = CGRectMake(0, self.frame.size.height-450, self.frame.size.width, 400);
    
    
    interestCollectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    interestCollectionView.delegate = self;
    interestCollectionView.dataSource = self;
    //  interestCollectionView.pagingEnabled = YES;
    interestCollectionView.showsHorizontalScrollIndicator = NO;
    interestCollectionView.backgroundColor=[UIColor clearColor];
    [interestCollectionView registerClass:[InterestCell class] forCellWithReuseIdentifier:@"cellIdentifier"];

    [self addSubview:interestCollectionView];
    
    interestCollectionView.allowsMultipleSelection=YES;
    
    
    counterLBL=[[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height-480, self.frame.size.width-20, 30)];
    [self addSubview:counterLBL];
    counterLBL.textAlignment=NSTextAlignmentRight;
    counterLBL.textColor=[UIColor blackColor];
    [self updateUI];
    
    // msgContactTable.bounces=false;
    
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // CGRect finalCellFrame=cell.frame;
    
    CGPoint translation = [collectionView.panGestureRecognizer translationInView:collectionView.superview];
    
    if (translation.x > 0) {
        //  cell.frame = CGRectMake(finalCellFrame.origin.x - 100, finalCellFrame.origin.y, finalCellFrame.size.width, finalCellFrame.size.height);
        
        cell.transform=CGAffineTransformConcat(CGAffineTransformMakeScale(0.9, 0.9), CGAffineTransformMakeTranslation(-100, 0));
    } else {
        //        cell.frame = CGRectMake(finalCellFrame.origin.x + 100, finalCellFrame.origin.y, finalCellFrame.size.width, finalCellFrame.size.height);
        
        cell.transform=CGAffineTransformConcat(CGAffineTransformMakeScale(0.9, 0.9), CGAffineTransformMakeTranslation(100, 0));
        
    }
    
    [UIView animateWithDuration:0.5f animations:^(void){
        cell.transform=CGAffineTransformConcat(CGAffineTransformMakeScale(1, 1), CGAffineTransformMakeTranslation(0, 0));
    }];
    
    

    
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InterestCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    // cell.profileIMGVIEW.image=[UIImage imageNamed:[NSString stringWithFormat:@"post_%d.jpeg",(int)indexPath.row%5+3]];
    
    [cell.profileIMGVIEW setUp:[[dbData objectAtIndex:indexPath.row] valueForKey:@"photo"]];
    
    
    cell.shadowImage.backgroundColor=[Constant colorGlobal:(indexPath.row%13)];
    
    // cell.nameLBL.text=[[arrayData1 objectAtIndex:indexPath.row] uppercaseString];
    
    cell.nameLBL.text=[[dbData objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    cell.layer.cornerRadius=3;
    cell.clipsToBounds=YES;
    
   // int indexNo=(int)indexPath.row-1;
    

    NSNumber *cellChannelId=[NSNumber numberWithInt:[[[dbData objectAtIndex:indexPath.row] valueForKey:@"id"] intValue]];
    
    
    if([selectedArray containsObject:cellChannelId])
    {
     
        cell.selected=YES;
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];

    }
    


   
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dbData.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width*0.56, collectionView.bounds.size.height*0.75);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSLog(@"add:%@",[[dbData objectAtIndex:indexPath.row] valueForKey:@"name"]);
    
    
    int newAddingId=[[[dbData objectAtIndex:indexPath.row] valueForKey:@"id"] intValue];

    
    [selectedArray addObject:[NSNumber numberWithInt:newAddingId]];
    
    numberOfItemSelected++;
    [self updateUI];
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    NSLog(@"remove:%@",[[dbData objectAtIndex:indexPath.row] valueForKey:@"name"]);

    int removeingId=[[[dbData objectAtIndex:indexPath.row] valueForKey:@"id"] intValue];

    [selectedArray removeObject:[NSNumber numberWithInt:removeingId]];

    numberOfItemSelected--;
    [self updateUI];
}
-(void)updateUI
{
    
    NSMutableAttributedString *string=[[NSMutableAttributedString alloc] init];
    
    NSAttributedString *subString1=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",numberOfItemSelected] attributes:@{NSFontAttributeName:[UIFont fontWithName:k_fontExtraBold size:15]}];
    
    NSAttributedString *mid1=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" of "] attributes:@{NSFontAttributeName:[UIFont fontWithName:k_fontSemiBold size:13]}];
    
    
    NSAttributedString *subString3=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",5] attributes:@{NSFontAttributeName:[UIFont fontWithName:k_fontExtraBold size:15]}];
    
    [string appendAttributedString:subString1];
    [string appendAttributedString:mid1];
    [string appendAttributedString:subString3];
    
    
    
    
    //  counterLBL.text=[NSString stringWithFormat:@"%d of 5",numberOfItemSelected];
    
    counterLBL.attributedText=string;
    
    
    if(numberOfItemSelected>4)
    {
        saveBtn.hidden=false;
    }
    else
    {
        saveBtn.hidden=true;
    }
    
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
    navBarTitle.text=@"Interests";
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
    
//    NSString *interestStr = [[selectedArray valueForKey:@"id"] componentsJoinedByString:@","];
//    interestStr=[NSString stringWithFormat:@"[%@]",interestStr];

    if(selectedArray.count>4)
    {
       NSDictionary *dict=@{
                         @"interests":selectedArray,
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