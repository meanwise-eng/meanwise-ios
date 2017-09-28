//
//  CircularGraphManager.m
//  MeanWiseRedesignHelper
//
//  Created by Hardik on 01/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "AvatarComponent.h"
#import "CircularGraphManager.h"
#import "APIObjects_ProfileObj.h"
#import "SearchGraphComponent.h"

@implementation CircularGraphManager

-(void)setUp
{
    cellSize=CGSizeMake(80, 80);
    float BoxW=self.bounds.size.height;

    scrollView=[[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scrollView];
    scrollView.contentSize=CGSizeMake(BoxW, BoxW);
    scrollView.delegate=self;
    scrollView.delaysContentTouches = YES;
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];


    
    [self scrollViewScrollToCenter:false];
    
    dataArray=[[NSMutableArray alloc] init];
    allUIObjects=[[NSMutableArray alloc] init];
    
    touchPoint=CGPointMake(BoxW/2, BoxW/2);
    layoutCenter=touchPoint;

    isSearching=false;
    
    
    
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [scrollView addGestureRecognizer:gesture];
    
    UILongPressGestureRecognizer *longTap=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapGesture:)];
    [scrollView addGestureRecognizer:longTap];

    
    
    
}

#pragma mark - Scroll

-(void)scrollViewScrollToCenter:(BOOL)withAnimation
{
    
    if(withAnimation==false)
    {
        CGFloat newContentOffsetX = (scrollView.contentSize.width - scrollView.frame.size.width) / 2;
        CGFloat newContentOffsetY = (scrollView.contentSize.height - scrollView.frame.size.height) / 2;
        scrollView.contentOffset = CGPointMake(newContentOffsetX, newContentOffsetY);
    }
    else
    {
        CGFloat newContentOffsetX = (scrollView.contentSize.width - scrollView.frame.size.width) / 2;
        CGFloat newContentOffsetY = (scrollView.contentSize.height - scrollView.frame.size.height) / 2;
        [scrollView setContentOffset:CGPointMake(newContentOffsetX, newContentOffsetY) animated:true];
    }
    
    
    
}
-(void)setTarget:(id)targetReceived onScroll:(SEL)func andOnUserTap:(SEL)func2 andLongTap:(SEL)func3;
{
    target=targetReceived;
    onScrollEvent=func;
    onUserTap=func2;
    onLongTap=func3;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView1
{
    CGRect visibleRect;
    visibleRect.origin = scrollView.contentOffset;
    visibleRect.size = scrollView.frame.size;
    touchPoint=CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    
    CGPoint diff=CGPointMake(touchPoint.x-layoutCenter.x, touchPoint.y-layoutCenter.y);
    


    [((SearchGraphComponent *)target) onCContronScroll:[NSValue valueWithCGPoint:diff]];
    
    
    
    [self zoomInAppropriate];
    
    
}



#pragma mark - Events

-(void)removeAllClear
{
    [self scrollViewScrollToCenter:true];
    
    isCleanupInProgress=true;
    
    scrollView.scrollEnabled=false;
    
    
    NSMutableArray *tempArray=[[NSMutableArray alloc] initWithArray:allUIObjects];
    
    [allUIObjects removeAllObjects];
    [dataArray removeAllObjects];
    
    
    for(int i=0;i<tempArray.count;i++)
    {
        
        AvatarComponent *compo=[tempArray objectAtIndex:i];
        CGPoint obPos=compo.center;
        CGPoint diff=CGPointMake(obPos.x-layoutCenter.x, obPos.y-layoutCenter.y);
        
        CGPoint finalPos=CGPointMake(obPos.x+diff.x, obPos.y+diff.y);
        
        
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            compo.alpha=0;
            compo.center=finalPos;
            
            
        } completion:^(BOOL finished) {
            
            [compo removeFromSuperview];
        }];
        
        
        
    }
    
    [self performSelector:@selector(cleanUp) withObject:nil afterDelay:0.6f];
    
    
    
}



-(void)cleanUp
{
    isCleanupInProgress=false;
    
    scrollView.scrollEnabled=true;
    
    float BoxW=self.bounds.size.height;
    
    scrollView.contentSize=CGSizeMake(BoxW, BoxW);
    
    touchPoint=CGPointMake(BoxW/2, BoxW/2);
    layoutCenter=touchPoint;

    
    
    [self scrollViewScrollToCenter:false];
    
}
-(void)setSearchMode:(BOOL)flag;
{
    isSearching=flag;
    
    if(flag==true)
    {
        scrollView.userInteractionEnabled=false;
    }
    else
    {
        scrollView.userInteractionEnabled=true;
    }
    
    
    [self setLayoutCustom:[[NSMutableArray alloc] init]];
    [self scrollViewScrollToCenter:YES];
    
    
}
-(BOOL)getSearchMode
{
    return isSearching;
}
-(void)tapGesture:(UITapGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateRecognized)
    {
        CGPoint point = [recognizer locationInView:recognizer.view];
        
        
        for (AvatarComponent *object in allUIObjects) {
            
            if(CGRectContainsPoint(object.frame, point))
            {
                [object setAnimationWithHide:YES];
                NSString *string=[object getUserIdStr];
                
                CGRect rect=CGRectMake(object.frame.origin.x-scrollView.contentOffset.x, object.frame.origin.y-scrollView.contentOffset.y, object.frame.size.width, object.frame.size.height);
                
                NSArray *array=[NSArray arrayWithObjects:string,[NSValue valueWithCGRect:rect],nil];
                [target performSelector:onUserTap withObject:array afterDelay:0.01];
                [object clicked:nil];
            }
        }
        
    }
    
}
-(void)longTapGesture:(UILongPressGestureRecognizer *)recognizer
{
    NSLog(@"longtap");
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [recognizer locationInView:recognizer.view];
        
        
        for (AvatarComponent *object in allUIObjects) {
            
            if(CGRectContainsPoint(object.frame, point))
            {
                
                NSString *string=[object getUserIdStr];
                [object setAnimationWithHide:YES];
                CGRect rect=CGRectMake(object.frame.origin.x-scrollView.contentOffset.x, object.frame.origin.y-scrollView.contentOffset.y, object.frame.size.width, object.frame.size.height);
                
                NSArray *array=[NSArray arrayWithObjects:string,[NSValue valueWithCGRect:rect],nil];
                [target performSelector:onLongTap withObject:array afterDelay:0.01];
                [object clicked:nil];
            }
        }
        
    }
}
-(void)makeAllVisible
{
    for (AvatarComponent *object in allUIObjects) {

        [object setAnimationWithHide:FALSE];
    }
    
}
-(void)addNewObjects:(NSArray *)inputArray;
{
   
    if(inputArray.count==0)
    {
        scrollView.userInteractionEnabled=false;
    }
    else{
        scrollView.userInteractionEnabled=true;

    }
    
    NSMutableArray *newObjects=[[NSMutableArray alloc] init];
    for(int i=0;i<inputArray.count;i++)
    {
        APIObjects_ProfileObj *obj=[inputArray objectAtIndex:i];
        
        NSLog(@"%@",obj.userId);
        
        
        
        NSString *string=[inputArray objectAtIndex:i];
        [dataArray addObject:string];
        AvatarComponent *demo=[[AvatarComponent alloc] initWithFrame:CGRectMake(0, 0, cellSize.width, cellSize.height)];
        
        [demo setUp:string andNo:5];

        
        
        [demo setURLString:obj.profile_photo_small andUserId:obj.userId withColorString:obj.profile_background_color];
        [scrollView addSubview:demo];
        [newObjects addObject:demo];
    }
    
    [self setLayoutCustom:newObjects];
    [self scrollViewScrollToCenter:YES];
}


#pragma mark - Helper
- (NSInteger)distanceBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2 {
    
    
    CGFloat deltaX = fabs(point1.x - point2.x);
    CGFloat deltaY = fabs(point1.y - point2.y);
    CGFloat distance = sqrt((deltaY*deltaY)+(deltaX*deltaX));
    
    return distance;
    
}
#pragma mark - Layout

-(void)zoomInAppropriate
{
    float radiusMain=cellSize.width;

    for(int i=0;i<allUIObjects.count;i++)
    {
        AvatarComponent *demo=[allUIObjects objectAtIndex:i];

        float distance=[self distanceBetweenPoint1:touchPoint andPoint2:demo.center];
        float scaleAlpha=0.2f+radiusMain/(distance);
        
        if(scaleAlpha>1) scaleAlpha=1;
        if(scaleAlpha<0.5) scaleAlpha=0.5;
        
        if(isSearching==true && i==0)
        {
            scaleAlpha=1;
        }
        demo.transform=CGAffineTransformMakeScale(scaleAlpha, scaleAlpha);
        demo.alpha=scaleAlpha;
        


    }
}

-(void)setLayoutCustom:(NSMutableArray *)newObjects
{
    float padding=cellSize.width+10;
    float radiusMain=cellSize.width;
    int noObjects=6;
   
    if(isSearching==true)
    {
        padding=padding*1.05;
        
    }
    
    stackCapacityArray=[[NSMutableArray alloc] init];
    stackPosRadiusArray=[[NSMutableArray alloc] init];
    for(int i=0;i<30;i++)
    {
        [stackPosRadiusArray addObject:@(padding+(radiusMain*i))];
    }
    for(int i=0;i<30;i++)
    {
        [stackCapacityArray addObject:@(noObjects+noObjects*i)];
    }
    [allUIObjects addObjectsFromArray:newObjects];

    
    NSMutableArray *tempAllObjects=[NSMutableArray arrayWithArray:allUIObjects];
    
    
    NSMutableArray *BigContainer=[[NSMutableArray alloc] init];
    
    for(int i=0;i<stackCapacityArray.count;i++)
    {
        NSMutableArray *smallContainer=[[NSMutableArray alloc] init];
        
        int stacklen=[[stackCapacityArray objectAtIndex:i] intValue];
        
        
        for(int j=0;j<stacklen && tempAllObjects.count!=0;j++)
        {
            [smallContainer addObject:[tempAllObjects objectAtIndex:0]];
            [tempAllObjects removeObjectAtIndex:0];
        }
        [BigContainer addObject:smallContainer];
        
    }
    
    
    NSMutableArray *drawLayoutValues=[[NSMutableArray alloc] init];
    

    
    
    int CountNewObj=0;
    
    for(int i=0;i<BigContainer.count;i++)
    {
        
        
        NSMutableArray *smallContainer=[BigContainer objectAtIndex:i];
        
        int noOfObjects=(int)smallContainer.count;
        float radius=[[stackPosRadiusArray objectAtIndex:i] floatValue];
        float initialRadius=radius+100;
        float circleAngle=0;
        
        if(isSearching==true && i==0)
        {
            circleAngle=0.02;
        }
        
        float dtCircleAngle=M_PI*2/[[stackCapacityArray objectAtIndex:i] intValue];
        
        for(int j=0;j<noOfObjects;j++)
        {
            
            float innerRadius=radius;
            AvatarComponent *demo=[smallContainer objectAtIndex:j];
            
            
            
            CGPoint diffInitial=CGPointMake(initialRadius*cos(circleAngle), initialRadius*sin(circleAngle));
            
            if(isSearching==true)
            {
                
                if(angle_is_between_angles(circleAngle,0-M_PI/16,M_PI/8))
                   {
                       innerRadius=radius*4;
                   }
                else if(angle_is_between_angles(circleAngle,M_PI-M_PI/16,M_PI+M_PI/8))
                {
                    innerRadius=radius*4;
                }
                else
                {
                    NSLog(@"outside %f",circleAngle);

                }

            }
            CGPoint diffFinal=CGPointMake(innerRadius*cos(circleAngle), innerRadius*sin(circleAngle));
            
            CGPoint posInitial=CGPointMake(layoutCenter.x+diffInitial.x, layoutCenter.y+diffInitial.y);
            CGPoint posFinal=CGPointMake(layoutCenter.x+diffFinal.x, layoutCenter.y+diffFinal.y);
            
            
            float distance=[self distanceBetweenPoint1:touchPoint andPoint2:posFinal];
            float scaleAlpha=0.2f+radiusMain/(distance);
            
            if(scaleAlpha>1) scaleAlpha=1;
            if(scaleAlpha<0.5) scaleAlpha=0.5;
            
            if(isSearching==true && i==0)
            {
                scaleAlpha=1;
            }

            
                if([newObjects containsObject:demo])
                {
                    CountNewObj++;
                    
                    demo.center=posInitial;
                    
                    demo.alpha=0;
                    
                    [UIView animateWithDuration:0.5f delay:0.01*CountNewObj options:UIViewAnimationOptionCurveEaseOut animations:^{
                        
                        demo.transform=CGAffineTransformMakeScale(scaleAlpha, scaleAlpha);
                        demo.alpha=scaleAlpha;
                        demo.center=posFinal;
                        
                    }
                    completion:^(BOOL finished)
                     {
                         
                         
                     }];
                    
                    
                }
                else
                {
                    [UIView animateWithDuration:0.5f delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        
                        demo.transform=CGAffineTransformMakeScale(scaleAlpha, scaleAlpha);
                        demo.alpha=scaleAlpha;
                        demo.center=posFinal;
                        
                        
                        
                    } completion:^(BOOL finished) {
                        
                    }];
                    
                }
            
        
            CGRect rect=CGRectMake(posFinal.x-cellSize.width/2, posFinal.y-cellSize.height/2, cellSize.width, cellSize.height);
            
            [drawLayoutValues addObject:[NSValue valueWithCGRect:rect]];

            
            
            
            
            
            circleAngle=circleAngle+dtCircleAngle;
            
            
        }
        
    }
    
    //Adjust Scroll Postion with Rect
    
    
    if(drawLayoutValues.count>0 && isSearching==false && isCleanupInProgress==false && newObjects.count!=0)
    {
        CGRect mainArea=[[drawLayoutValues objectAtIndex:0] CGRectValue];

        for(int i=0;i<drawLayoutValues.count;i++)
        {
        CGRect tempRect=[[drawLayoutValues objectAtIndex:i] CGRectValue];
        mainArea=CGRectUnion(mainArea, tempRect);

        }

        if(mainArea.size.width>mainArea.size.height)
        {
            mainArea=CGRectMake(0, 0, mainArea.size.width, mainArea.size.width);
            
        }
        else
        {
            mainArea=CGRectMake(0, 0, mainArea.size.height, mainArea.size.height);

        }
        
        float padding=50;
        mainArea=CGRectMake(mainArea.origin.x-padding/2, mainArea.origin.y-padding/2, mainArea.size.width+padding, mainArea.size.height+padding);
        
        if(scrollView.contentSize.height<mainArea.size.height)
        {

            
            
            scrollView.contentSize=CGSizeMake(mainArea.size.width, mainArea.size.height);
            layoutCenter=CGPointMake(mainArea.size.width/2, mainArea.size.height/2);


            [self scrollViewScrollToCenter:YES];
            touchPoint=layoutCenter;
            
            [self setLayoutCustom:[[NSMutableArray alloc] init]];

            
        }
    }
    
    
    
    
    
}
static inline double angle_1to360(double angle){
    angle=((int)angle % 360) + (angle-trunc(angle)); //converts angle to range -360 + 360
    if(angle>0.0)
        return angle;
    else
        return angle + 360.0;
}

static inline BOOL angle_is_between_angles(float N,float a,float b) {
     N = angle_1to360(N); //normalize angles to be 1-360 degrees
    a = angle_1to360(a);
    b = angle_1to360(b);
    
    if (a < b)
        return a <= N && N <= b;
    return a <= N || N <= b;
}

@end








