//
//  SignUpWizardName.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "SignUpWizardInterestComponent.h"
#import "InterestCell.h"
#import "APIPoster.h"

@implementation SignUpWizardInterestComponent

-(void)setUp
{
    self.backgroundColor=[UIColor clearColor];
    [Constant setUpGradient:self style:7];
    
    selectedArray=[[NSMutableArray alloc] init];
   // arrayData=[[NSArray alloc] initWithObjects:@"Music",@"Travel",@"Lifestyle",@"Sports",@"Science & Technology",@"Politics",@"Fashion",@"Finance",@"Gamming",nil];

    arrayData1=[[[APIPoster alloc] init] getInterestData];

    headLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 40)];
    [self addSubview:headLBL];
    headLBL.text=@"Choose Interests";
    headLBL.textColor=[UIColor whiteColor];
    headLBL.textAlignment=NSTextAlignmentLeft;
    headLBL.font=[UIFont fontWithName:k_fontAvenirNextHeavy size:28];
    headLBL.center=CGPointMake(self.frame.size.width/2, 140);
    
    subHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 60)];
    [self addSubview:subHeadLBL];
    subHeadLBL.numberOfLines=2;
    subHeadLBL.text=@"Choose atleast 5 interests";
    subHeadLBL.textColor=[UIColor whiteColor];
    subHeadLBL.textAlignment=NSTextAlignmentLeft;
    subHeadLBL.font=[UIFont fontWithName:k_fontSemiBold size:15];
    subHeadLBL.center=CGPointMake(self.frame.size.width/2, 180);
    
    
    
    backBtn=[[UIButton alloc] initWithFrame:CGRectMake(20,35, 23*1.2, 16*1.2)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackButton.png"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-15, -15, -15, -15)];

    
    
    
    
    nextBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    nextBtn.layer.cornerRadius=20;
    nextBtn.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.6f];
    [nextBtn addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"nextArrow.png"] forState:UIControlStateNormal];
    [self addSubview:nextBtn];
    nextBtn.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-30);
    nextBtn.hidden=true;
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2)];
    view.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:view];
    view.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-60);
    
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    
    
    CGRect collectionViewFrame = CGRectMake(0, self.frame.size.height-430, self.frame.size.width, 400);
    
    
    interestCollectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    interestCollectionView.delegate = self;
    interestCollectionView.dataSource = self;
    //  interestCollectionView.pagingEnabled = YES;
    interestCollectionView.showsHorizontalScrollIndicator = NO;
    interestCollectionView.backgroundColor=[UIColor clearColor];
    [interestCollectionView registerClass:[InterestCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:interestCollectionView];
    
    interestCollectionView.allowsMultipleSelection=YES;
    
    numberOfItemSelected=0;
    
    counterLBL=[[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height-420, self.frame.size.width-20, 30)];
    [self addSubview:counterLBL];
    counterLBL.textAlignment=NSTextAlignmentRight;
    counterLBL.textColor=[UIColor whiteColor];
    [self updateUI];

    
 /*   UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:collectionViewFrame];
    [self addSubview:scrollView];
    scrollView.showsHorizontalScrollIndicator=false;
    scrollView.showsVerticalScrollIndicator=false;
    //scrollView.pagingEnabled=true;
    
    
    
    arrayViews=[[NSMutableArray alloc] init];

    
    float ratio=0.75;
    for(int i=0;i<[arrayData count];i++)
    {
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0+collectionViewFrame.size.width*ratio*i, 0, collectionViewFrame.size.width*ratio, collectionViewFrame.size.height)];
        [scrollView addSubview:view];
        //view.backgroundColor=[UIColor colorWithHue:i*0.1 saturation:1.0f brightness:1.0f alpha:1.0f];
//        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,300)];
        [view addSubview:imageView];
        imageView.image=[UIImage imageNamed:@"CoverPhoto.jpg"];
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds=YES;
        
        UIView *whiteView=[[UIView alloc] initWithFrame:imageView.bounds];
        [imageView addSubview:whiteView];
        whiteView.backgroundColor=[UIColor purpleColor];
        whiteView.alpha=0.2;
        
        imageView.center=CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
        
        [arrayViews addObject:imageView];
        
        
//        UIImageView *shadowImage=[[UIImageView alloc] initWithFrame:imageView.frame];
//        shadowImage.image=[UIImage imageNamed:@"BlackShadow.png"];
//        shadowImage.contentMode=UIViewContentModeScaleAspectFill;
//        [view addSubview:shadowImage];
//        shadowImage.alpha=0.3;
//        shadowImage.clipsToBounds=YES;

        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200-20, 80)];
        label.textAlignment=NSTextAlignmentLeft;
        label.text=[[arrayData objectAtIndex:i] uppercaseString];
        [imageView addSubview:label];
        label.textColor=[UIColor whiteColor];
        label.font=[UIFont fontWithName:k_fontSemiBold size:20];
        label.adjustsFontSizeToFitWidth=2;
        label.numberOfLines=2;
        
        
        
        UIButton *whiteBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        whiteBtn.backgroundColor=[UIColor colorWithWhite:1 alpha:0.5];
        whiteBtn.clipsToBounds=YES;
        whiteBtn.tag=i;
    
        whiteBtn.layer.cornerRadius=35;
        [view addSubview:whiteBtn];
        whiteBtn.center=CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
        
        [whiteBtn addTarget:self action:@selector(interestSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [whiteBtn setBackgroundImage:nil forState:UIControlStateNormal];


        whiteBtn.alpha=0.5;
        whiteBtn.backgroundColor=[UIColor clearColor];
        whiteBtn.layer.borderColor=[UIColor whiteColor].CGColor;
        whiteBtn.layer.borderWidth=2;

    }
    
    scrollView.contentSize=CGSizeMake(collectionViewFrame.size.width*ratio*[arrayData count], 0);
    scrollView.delaysContentTouches = NO;
    scrollView.delegate=self;

    [self scrollViewDidScroll:scrollView];*/
    

    
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

   
//        cell.transform=CGAffineTransformMakeScale(0.9, 0.9);
//        cell.alpha=0;
//    
//        
//        [UIView animateWithDuration:0.3
//                         animations:^{
//                             
//                             cell.transform=CGAffineTransformMakeScale(1, 1);
//                             cell.alpha=1;
//                             
//                             
//                         }
//                         completion:^(BOOL finished) {
//                             
//                         }];
    
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InterestCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
   // cell.profileIMGVIEW.image=[UIImage imageNamed:[NSString stringWithFormat:@"post_%d.jpeg",(int)indexPath.row%5+3]];
    
    [cell.profileIMGVIEW setUp:[[arrayData1 objectAtIndex:indexPath.row] valueForKey:@"photo"]];
    
    
    cell.shadowImage.backgroundColor=[Constant colorGlobal:(indexPath.row%13)];

   // cell.nameLBL.text=[[arrayData1 objectAtIndex:indexPath.row] uppercaseString];
    
    cell.nameLBL.text=[[arrayData1 objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    cell.layer.cornerRadius=3;
    cell.clipsToBounds=YES;
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrayData1.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width*0.56, collectionView.bounds.size.height*0.75);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"add:%@",[[arrayData1 objectAtIndex:indexPath.row] valueForKey:@"name"]);

    [selectedArray addObject:[arrayData1 objectAtIndex:indexPath.row]];
    
    numberOfItemSelected++;
     [self updateUI];
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [selectedArray removeObject:[arrayData1 objectAtIndex:indexPath.row]];
    
        NSLog(@"remove:%@",[[arrayData1 objectAtIndex:indexPath.row] valueForKey:@"name"]);
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
        nextBtn.hidden=false;
    }
    else
    {
        nextBtn.hidden=true;
    }
}



/*
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for(int i=0;i<[arrayViews count];i++)
    {
        UIView *view=[arrayViews objectAtIndex:i];
        
        float pos=(scrollView.contentOffset.x+scrollView.frame.size.width*0.8)/((i+1)*scrollView.frame.size.width*0.8);
        
        
        view.transform=CGAffineTransformMakeScale(1+pos/4, 1+pos/4);
        
      //  view.layer.transform=CATransform3DMakeRotation(pos/4, 1, 0, 1);
        
    }
    
    
}



-(void)interestSelected:(UIButton *)btn
{
    if(btn.alpha==0.5)
    {
        btn.alpha=1;
        [btn setBackgroundImage:[UIImage imageNamed:@"Checkmark.png"] forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor colorWithWhite:1 alpha:0.5];
        btn.layer.borderColor=[UIColor whiteColor].CGColor;
        btn.layer.borderWidth=0;


    }
    else
    {
        btn.alpha=0.5;
        [btn setBackgroundImage:nil forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor clearColor];
        btn.layer.borderColor=[UIColor whiteColor].CGColor;
        btn.layer.borderWidth=2;

    }

    
}
*/











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
    [DataSession sharedInstance].signupObject.interests=selectedArray;

    
    [delegate performSelector:Func_nextBtnClicked withObject:nil afterDelay:0.01];

}

-(void)backBtnClicked:(id)sender
{
    [delegate performSelector:Func_backBtnClicked withObject:nil afterDelay:0.01];

}

-(void)forgetPassBtnClicked:(id)sender
{
    
}

@end
