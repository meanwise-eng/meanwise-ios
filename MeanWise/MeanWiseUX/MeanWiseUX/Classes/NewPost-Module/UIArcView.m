//
//  UIArcView.m
//  ExactResearch
//
//  Created by Hardik on 12/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "UIArcView.h"

@implementation UIArcView


-(void)setProgress:(float)point
{
    progress=point;
    [self setNeedsDisplay];
}
-(void)startAnimation:(id)sender
{
    if(progress<0.8)
    {
 
        float inc=(arc4random()%10)*0.001;
        
        if(inc<0.005) inc=0;
        
        progress=progress+inc;
        [self setNeedsDisplay];
        [self performSelector:@selector(startAnimation:) withObject:nil afterDelay:0.01];
        
    }
    
}
-(void)setRadious:(float)point;
{
    radious=point;
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGPoint Center=CGPointMake(rect.size.width/2, rect.size.height/2);
    
    CGContextRef tx=UIGraphicsGetCurrentContext();
    CGContextBeginPath(tx);
    CGContextSetLineWidth(tx, 10);
    CGContextSetStrokeColorWithColor(tx, [UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:0.5f].CGColor);
    
    //    CGPatternRef pattern=CGPatternCreate(NULL, rect, CGAffineTransformIdentity, 24, 24, kCGPatternTilingConstantSpacing, true, &callbacks);
    
    
    
    CGContextAddArc(tx, Center.x, Center.y, radious, -M_PI/2, (2*M_PI*progress)-M_PI/2, 0);
    CGContextStrokePath(tx);
    
    
}
@end
