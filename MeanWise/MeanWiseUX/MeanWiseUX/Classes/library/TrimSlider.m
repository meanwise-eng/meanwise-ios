//
//  TrimSlider.m
//  VideoPlayerDemo
//
//  Created by Hardik on 21/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "TrimSlider.h"

@implementation TrimSlider

-(void)setTarget:(id)targetReceived andOnTrimmingDidChangeFunc:(SEL)func;
{
    target=targetReceived;
    onTrimmingDidChangeFunc=func;
    
}
-(void)setUp:(NSString *)path
{
    urlPath=path;
    
    alertCount=0;
    videoDuration=[self getVideoDuration];
    
    if(videoDuration<4.0)
    {
        self.hidden=true;
        return;
    }
    else
    {
        self.hidden=false;
    }
    
    distanceFor2Seconds=2*(self.frame.size.width-30)/videoDuration;
    distanceFor25Seconds=25*(self.frame.size.width-30)/videoDuration;
    
    
    
    
    baseSlider=[[UIView alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width-30, 50)];
    [self addSubview:baseSlider];
    baseSlider.backgroundColor=[UIColor grayColor];
    baseSlider.layer.shadowColor=[UIColor blackColor].CGColor;
    baseSlider.layer.shadowOffset=CGSizeMake(0, 0);
    baseSlider.layer.shadowOpacity=0.6;
    baseSlider.layer.shadowRadius=5;
    
    
    [self createThumbAndSetup];
    
    progressSlider=[[UIView alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width-30, 50)];
    [self addSubview:progressSlider];
    progressSlider.backgroundColor=[UIColor clearColor];
    progressSlider.layer.borderColor=[UIColor whiteColor].CGColor;
    progressSlider.layer.borderWidth=1;
    
    prgressNodeToView1=[[UIView alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width-30, 50)];
    prgressNodeToView2=[[UIView alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width-30, 50)];
    [self addSubview:prgressNodeToView1];
    [self addSubview:prgressNodeToView2];
    prgressNodeToView1.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    prgressNodeToView2.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    
    
    
    
    
    baseSlider.layer.cornerRadius=5;
    progressSlider.layer.cornerRadius=5;
    
    
    node1Slider=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    [self addSubview:node1Slider];
    node1Slider.backgroundColor=[UIColor whiteColor];
    
    
    
    node2Slider=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    [self addSubview:node2Slider];
    node2Slider.backgroundColor=[UIColor whiteColor];
    
    UIView *node1top=[[UIView alloc] initWithFrame:CGRectMake(4, 15, 2, 20)];
    UIView *node2top=[[UIView alloc] initWithFrame:CGRectMake(4, 15, 2, 20)];
    
    node1top.backgroundColor=[UIColor darkGrayColor];
    node2top.backgroundColor=[UIColor darkGrayColor];
    
    
    [node1Slider addSubview:node1top];
    [node2Slider addSubview:node2top];
    
    
    playerMark=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 50)];
    [self addSubview:playerMark];
    playerMark.backgroundColor=[UIColor yellowColor];
    
    
    
    
    
    node1Slider.center=CGPointMake(15, node1Slider.center.y);
    
    if(videoDuration<25.0f)
    {
    node2Slider.center=CGPointMake(self.frame.size.width-15, node2Slider.center.y);
    }
    else
    {
     node2Slider.center=CGPointMake(node1Slider.center.x+distanceFor25Seconds, node2Slider.center.y);

    }
    
    
    selected=-1;
    
    node1Slider.userInteractionEnabled=false;
    node2Slider.userInteractionEnabled=false;
    baseSlider.userInteractionEnabled=false;
    
    blockView=[[UILabel alloc] initWithFrame:CGRectMake(0, -20, 50, 20)];
    [self addSubview:blockView];
    blockView.backgroundColor=[UIColor blackColor];
    blockView.textColor=[UIColor whiteColor];
    blockView.textAlignment=NSTextAlignmentCenter;
    blockView.font=[UIFont systemFontOfSize:10];
    blockView.text=@"00:00";
    blockView.alpha=0;
    blockView.layer.cornerRadius=10;
    blockView.clipsToBounds=YES;
    
    
    [self updateProgressSlider:1];
    
}
-(void)createThumbAndSetup
{
    
    float segment=10.0f;
    
    float intervalDuration=videoDuration*1000/segment;
    float segmentDistance=baseSlider.frame.size.width/segment;
    
    for(float i=0;i<segment;i=i+1)
    {
        
        dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
        dispatch_async(myQueue, ^{
            
            UIImage *image=[self generateThumbImage:i*intervalDuration];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                
                UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(segmentDistance*i, 0, segmentDistance, baseSlider.frame.size.height)];
                [baseSlider addSubview:imageView];
                imageView.clipsToBounds=YES;
                imageView.image=image;
                imageView.contentMode=UIViewContentModeScaleAspectFill;

                
            });
        });
        

        
        
    }
    
    
}
-(void)updateProgressSlider:(int)number
{
    
    float width=node2Slider.center.x-node1Slider.center.x;
    
    progressSlider.frame=CGRectMake(node1Slider.center.x, 0, width, 50);
    
    
    prgressNodeToView1.frame=CGRectMake(15, 0, node1Slider.center.x-15, 50);
    prgressNodeToView2.frame=CGRectMake(node1Slider.center.x+width, 0, baseSlider.frame.size.width-node1Slider.center.x-width+15, 50);
    
    if(number==1)
    {
        playerMark.frame=CGRectMake(node1Slider.frame.origin.x, 0, 3, 50);
    }
    else
    {
        playerMark.frame=CGRectMake(node2Slider.frame.origin.x, 0, 3, 50);
    }
    
    
    float totalDistance=(self.frame.size.width-30);
    float position=blockView.center.x;
    
    float ratio=(position-15)/totalDistance;
    
    int durationToshow=(int)(ratio*videoDuration);
    
    int minutes = durationToshow / 60;
    int seconds = durationToshow % 60;
    
    NSString *minutesStr=[NSString stringWithFormat:@"%d",minutes];
    if(minutes<10) minutesStr=[NSString stringWithFormat:@"0%d",minutes];
    
    NSString *secondStr=[NSString stringWithFormat:@"%d",seconds];
    if(seconds<10) secondStr=[NSString stringWithFormat:@"0%d",seconds];
    
    blockView.text=[NSString stringWithFormat:@"%@:%@",minutesStr,secondStr];
    
    NSLog(@"%f",ratio*videoDuration);
    
    
}
-(void)callBackToHandler:(int)selectedNumber isTouched:(int)touch
{
    float totalDistance=(self.frame.size.width-30);


    
    float position1=node1Slider.center.x;
    float ratio1=(position1-15)/totalDistance;
    float durationToshow1=(ratio1*videoDuration);

    float position2=node2Slider.center.x;
    float ratio2=(position2-15)/totalDistance;
    float durationToshow2=(ratio2*videoDuration);

    NSArray *array=@[[NSNumber numberWithFloat:durationToshow1],[NSNumber numberWithFloat:durationToshow2],[NSNumber numberWithInt:selectedNumber],[NSNumber numberWithInt:touch]];
    
    
    
    [target performSelector:onTrimmingDidChangeFunc withObject:array afterDelay:0.001];

}
-(void)updateProgress:(CMTime)startTime endTime:(CMTime)endTime andCurrentTime:(CMTime)currentTime
{

    CMTime trimmingDuration=CMTimeSubtract(endTime, startTime);
    
    CMTime arrowTime=CMTimeSubtract(currentTime, startTime);

    
    
  //  float trimmingDurationInSeconds=CMTimeGetSeconds(trimmingDuration);
    
    float trimmingDurationInSeconds=(trimmingDuration.value*1000)/trimmingDuration.timescale;
    trimmingDurationInSeconds=trimmingDurationInSeconds/1000;
    float arrowTimeInSeconds=CMTimeGetSeconds(arrowTime);


    if(trimmingDurationInSeconds<1)
    {
        int p=0;
    }
    
    float trimmingDistance=node2Slider.frame.origin.x-node1Slider.frame.origin.x;
    float ratio=trimmingDistance/trimmingDurationInSeconds;
    
    
     playerMark.center=CGPointMake(node1Slider.center.x+ratio*arrowTimeInSeconds,playerMark.center.y);
    
//    float ratio2=/videoDuration;
//    
    
    //float ratio=trimmingDistance/trimmingDuration;
    
  //  playerMark.center=CGPointMake(node1Slider.frame.origin.x+15+ratio*(duration-durationToshow1), playerMark.center.y);

    /*
    float totalDistance=(self.frame.size.width-30);
    float ratio=duration/videoDuration;
    
    float pos=totalDistance*ratio;

    
    playerMark.frame=CGRectMake(pos, 0, 3, 50);*/
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];
    
    CGRect node1frame=node1Slider.frame;
    CGRect node2frame=node2Slider.frame;
    
    node1frame=CGRectMake(node1frame.origin.x-10, node1frame.origin.y, node1frame.size.width+20, node1frame.size.height);
    node2frame=CGRectMake(node2frame.origin.x-10, node2frame.origin.y, node2frame.size.width+20, node2frame.size.height);
    
    if(CGRectContainsPoint(node1frame, point))
    {
        blockView.center=CGPointMake(node1Slider.center.x, blockView.center.y);
        
        blockView.alpha=1;
        
        selected=1;
        
    }
    else if(CGRectContainsPoint(node2frame, point))
    {
        blockView.center=CGPointMake(node2Slider.center.x, blockView.center.y);
        
        blockView.alpha=1;
        
        selected=2;
        
    }
    else
    {
        
    }
}
-(void)showAlert
{
    if(alertCount==0)
    {



        alertCount++;
        //[FTIndicator showToastMessage:@"Minimum 3 secs, Max 25 Secs"];
    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];
    
    
    if(point.x<=15)
    {
        point=CGPointMake(15, point.y);
    }
    if(point.x>=self.frame.size.width-15)
    {
        point=CGPointMake(self.frame.size.width-15, point.y);
    }
    
    
    if(selected==1)
    {
        if(point.x>node2Slider.center.x-15-distanceFor2Seconds)
        {
            [self showAlert];
            point=CGPointMake(node1Slider.center.x, point.y);
        }
        if(point.x<node2Slider.center.x-15-distanceFor25Seconds)
        {
            [self showAlert];
            point=CGPointMake(node1Slider.center.x, point.y);
        }
    }
    
    if(selected==2)
    {
        if(point.x<node1Slider.center.x+15+distanceFor2Seconds)
        {
                        [self showAlert];
            point=CGPointMake(node2Slider.center.x, point.y);
        }
        if(point.x>node1Slider.center.x+15+distanceFor25Seconds)
        {            [self showAlert];
            point=CGPointMake(node2Slider.center.x, point.y);
        }
        
    }
    
    
    if(selected==1)
    {
        node1Slider.center=CGPointMake(point.x, node1Slider.center.y);
        [self updateProgressSlider:1];
        
    }
    else if(selected==2)
    {
        
        
        node2Slider.center=CGPointMake(point.x, node2Slider.center.y);
        [self updateProgressSlider:2];
        
    }
    
    [self callBackToHandler:selected isTouched:1];

    blockView.center=CGPointMake(point.x, blockView.center.y);
    
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    alertCount=0;

    blockView.alpha=0;
    
    [self callBackToHandler:selected isTouched:0];
    selected=-1;

}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
    
}
-(float)getVideoDuration
{
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:urlPath];
    
    AVURLAsset *sourceAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    CMTime duration = sourceAsset.duration;
    
    float time=CMTimeGetSeconds(duration);
    return time;
    
    
}
-(UIImage *)generateThumbImage:(float)duration
{
    NSURL *url = [NSURL fileURLWithPath:urlPath];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = [asset duration];
    time.value = duration;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}



@end
