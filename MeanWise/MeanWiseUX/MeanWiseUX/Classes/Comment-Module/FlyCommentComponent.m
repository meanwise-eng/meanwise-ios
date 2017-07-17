//
//  FlyCommentComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 21/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "FlyCommentComponent.h"

@implementation FlyCommentComponent

-(void)setUp
{
    currentIndex=0;
    
    arrayData=[[NSMutableArray alloc] init];
    cellStack=[[NSMutableArray alloc] init];
    
    displayStack=[[NSMutableArray alloc] init];
    
    
    for(int i=0;i<20;i++)
    {
        
        [self performSelector:@selector(addNewMessage) withObject:nil afterDelay:(i*1.5f+(arc4random()%4)*0.45)];
        
        
    }

    
}

-(void)addNewMessage
{
    
    NSArray *randomMessages=[[NSArray alloc] initWithObjects:
                        
                             @"Could you repeat that please?",
                             @"cheers",
                             @"I don't think its that much bad."
                             @"Yeah, right. What do you like to read?",
                             @"You are my favorite",
                             @"Oh My Good, For real?",
                             @"You know what you can do with that????",
                             @"What is wrong with you?",
                             @"I'm sure I'll think of more",
                             @"Are you kidding me?",
                             @"Ha Ha. Do you play or follow any sports?",
                             @"SooooooooperCute. Do you like animals? What's your favorite animal?",
                             
                             nil];
    
    for(int i=0;i<1;i++)
    {
        
        
        NSString *msg=[randomMessages objectAtIndex:arc4random()%(randomMessages.count)];
        
        
        NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:msg,@"msg",
                            [NSNumber numberWithInt:arc4random()%2],@"sender",
                            nil];
        
        [arrayData addObject:dict];
    }
    
    [self animateComponent];
    
}

-(void)animateComponent
{
    
    

    if(currentIndex<arrayData.count)
    {

        FlyCommentComponentCell *cell=[[FlyCommentComponentCell alloc] init];
        int height=[cell setUp:[[arrayData objectAtIndex:currentIndex] valueForKey:@"msg"]];
        cell.frame=CGRectMake(0, self.frame.size.height-height-20, 200, height);
        [self addSubview:cell];
        [cellStack addObject:cell];
        currentIndex++;
        cell.alpha=0;
        [self shiftUp];
    
    }
    
    //[self performSelector:@selector(shiftUp) withObject:nil afterDelay:1.0f];
   
}
-(void)shiftUp
{
    


    int height=0;

   
    FlyCommentComponentCell *cell=[cellStack firstObject];
    height=height+[cell getHeightValue];
   // cell.frame=CGRectMake(0, self.frame.size.height-height-20, 200, height);
    cell.alpha=1;
    [displayStack addObject:cell];
    [cellStack removeObject:cell];

    [cell fadeOut];

    
    
    for(int i=0;i<[displayStack count];i++)
    {
        FlyCommentComponentCell *cell=[displayStack objectAtIndex:i];
        
        if(cell.hidden==true)
        {
            [displayStack removeObject:cell];
            [cell removeFromSuperview];
        }


    }
   
    
   // NSLog(@"%ld",displayStack.count);
    
    
    [UIView animateKeyframesWithDuration:0.2 delay:0.0f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{

        int newHeight=0;

        for(int i=(int)[displayStack count]-1;i>=0;i--)
        {
            FlyCommentComponentCell *cell=[displayStack objectAtIndex:i];
            
            if(cell!=nil)
            {
                int cellHeight=[cell getHeightValue];
                newHeight=newHeight+cellHeight+10;
                 cell.frame=CGRectMake(0, self.frame.size.height-newHeight-20, 200, cellHeight);

            }
            
        }
        

    
    }completion:^(BOOL finished) {
        
    }];

    
    
    

}

@end

@implementation FlyCommentComponentCell

-(void)fadeOut
{
    
    self.alpha=0;
    [UIView animateKeyframesWithDuration:0.5f delay:0.2f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        self.alpha=1;
        
    
    } completion:^(BOOL finished) {
        
        
        
        [UIView animateKeyframesWithDuration:2 delay:2.0f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            self.alpha=0;
            
            
        } completion:^(BOOL finished) {
            self.hidden=true;
            
        }];

        
    }];
    
    
    
    
    
}
-(int)setUp:(NSString *)string
{
    self.userInteractionEnabled=false;


    shadowView=[[UIView alloc] initWithFrame:CGRectMake(25, 5, 200, 30)];
    [self addSubview:shadowView];
    shadowView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.86f];
    shadowView.clipsToBounds=YES;
    shadowView.layer.cornerRadius=20;
    
    
    profileIMGVIEW=[[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 45, 45)];
    [self addSubview:profileIMGVIEW];
    profileIMGVIEW.image=[UIImage imageNamed:[NSString stringWithFormat:@"profile%d.jpg",arc4random()%6+1]];
    profileIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
    profileIMGVIEW.clipsToBounds=YES;
    profileIMGVIEW.layer.cornerRadius=45/2;
    
    
    
    nameLBL=[[UILabel alloc] initWithFrame:CGRectMake(55,5, 200, 100)];
    [self addSubview:nameLBL];
    nameLBL.text=@"Awesome! How do you do that?";
    nameLBL.textColor=[UIColor whiteColor];
    
    nameLBL.textAlignment=NSTextAlignmentLeft;
    nameLBL.font=[UIFont fontWithName:k_fontRegular size:14];
    nameLBL.numberOfLines=1;
    

    nameLBL.text=string;
    CGFloat fixedWidth = nameLBL.frame.size.width;
    CGSize newSize = [nameLBL sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    
    
    
    
    CGRect newFrame = nameLBL.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height+10);

    newFrame.size = CGSizeMake(fixedWidth, 40);

    nameLBL.frame = newFrame;
    
    shadowView.frame=CGRectMake(25, newFrame.origin.y, newFrame.size.width+20+newFrame.origin.x-10, newFrame.size.height);

    
    height=shadowView.frame.size.height;
    return height;

}


-(int)getHeightValue;
{
    return height;
}


@end
