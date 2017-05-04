//
//  ListCell.m
//  MeanWiseUX
//
//  Created by Hardik on 01/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.clipsToBounds=YES;
        
        self.opaque=YES;
        
        self.player=[[HMVideoPlayer alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:self.player];
        [self.player setUp];

        self.contentView.opaque=YES;
        
    }
    return self;
}
-(NSString *)getURLPath
{
    return stringURLPath;
}
-(void)setURL:(NSString *)stringURL;
{
    stringURLPath=stringURL;
    [self.player setURL:stringURL];
}
-(void)cleanUp
{
    [self.player cleanupPlayer];
    [self removeFromSuperview];
}


@end
