//
//  ShareComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 26/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "ShareComponent.h"

@implementation ShareComponent

-(void)setTarget:(id)target andCloseBtnClicked:(SEL)func1;
{
    delegate=target;
    closeBtnClicked=func1;
}

-(void)setUp
{
    blackOverLay=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:blackOverLay];
    blackOverLay.backgroundColor=[UIColor blackColor];
    blackOverLay.alpha=0;
    
    

    containerView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height/2)];
    
    containerView.backgroundColor=[UIColor whiteColor];
    [self addSubview:containerView];
    
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
        
        containerView.frame=CGRectMake(0, self.bounds.size.height/2, self.bounds.size.width, self.bounds.size.height/2);
        blackOverLay.alpha=0.4;
        
    } completion:^(BOOL finished) {
        
        
        
    }];
    
    shareTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    [containerView addSubview:shareTitle];
    shareTitle.font=[UIFont fontWithName:k_fontRegular size:17];
    shareTitle.text=@"Share";

    shareTitle.textColor=[UIColor colorWithRed:0.26 green:0.36 blue:0.41 alpha:1.00];
    shareTitle.textAlignment=NSTextAlignmentCenter;
    

    seperator1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    seperator1.backgroundColor=[UIColor colorWithRed:0.26 green:0.36 blue:0.41 alpha:0.1];
    [containerView addSubview:seperator1];
    seperator1.center=CGPointMake(self.frame.size.width/2, 40);

    seperator2=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    seperator2.backgroundColor=[UIColor colorWithRed:0.26 green:0.36 blue:0.41 alpha:0.1];
    [containerView addSubview:seperator2];
    seperator2.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2-70);

    seperator3=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    seperator3.backgroundColor=[UIColor colorWithRed:0.26 green:0.36 blue:0.41 alpha:0.1];
    [containerView addSubview:seperator3];
    seperator3.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2-140);;

    
  
    
    cancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, self.bounds.size.height/2-70, self.frame.size.width, 70)];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:0.26 green:0.36 blue:0.41 alpha:1.00] forState:UIControlStateNormal];
    [containerView addSubview:cancelBtn];
    cancelBtn.titleLabel.font=[UIFont fontWithName:k_fontRegular size:17];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);


    CGRect collectionViewFrame = CGRectMake(0, 60, self.frame.size.width, 120);
    peopleList = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    peopleList.delegate = self;
    peopleList.dataSource = self;
    peopleList.showsHorizontalScrollIndicator = NO;
    peopleList.backgroundColor=[UIColor clearColor];
    [peopleList registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [containerView addSubview:peopleList];

    NSArray *array=[NSArray arrayWithObjects:@"FacebookIcon.png",@"TwitterIcon.png",@"GoogleIcon.png", nil];
    
    for(int i=0;i<5;i++)
    {
        
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(i*70, self.frame.size.height/2-140, 70, 70)];
        [containerView addSubview:btn];
        
        [btn setImage:[UIImage imageNamed:[array objectAtIndex:i%3]] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(25, 25, 25, 25)];
        
    }
    
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    
    UIImageView *profileIMGVIEW=[[UIImageView alloc] initWithFrame:CGRectMake(25, 10, 70, 70)];
    [cell addSubview:profileIMGVIEW];
    profileIMGVIEW.image=[UIImage imageNamed:[NSString stringWithFormat:@"profile%d.jpg",((int)indexPath.row)%6+1]];

    profileIMGVIEW.contentMode=UIViewContentModeScaleToFill;
    profileIMGVIEW.clipsToBounds=YES;
    profileIMGVIEW.layer.cornerRadius=35;
    
    UILabel *contactNameLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 80, 120, 40)];
    [cell addSubview:contactNameLBL];
    contactNameLBL.text=@"John Elapse";
    contactNameLBL.textColor=[UIColor colorWithRed:0.26 green:0.36 blue:0.41 alpha:1.00];
    contactNameLBL.textAlignment=NSTextAlignmentCenter;
    contactNameLBL.font=[UIFont fontWithName:k_fontSemiBold size:12];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120,120);
}

-(void)cancelBtnClicked:(id)sender
{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
        
        containerView.frame=CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height/2);
        blackOverLay.alpha=0;
        
    } completion:^(BOOL finished) {
        [delegate performSelector:closeBtnClicked withObject:nil afterDelay:0.01f];

        [self removeFromSuperview];
        
    }];
}
@end
