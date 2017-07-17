//
//  ListCell.h
//  MeanWiseUX
//
//  Created by Hardik on 01/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMVideoPlayer.h"

@interface ListCell : UICollectionViewCell
{
    NSString *stringURLPath;
}
@property (nonatomic, strong) HMVideoPlayer *player;

-(NSString *)getURLPath;

-(void)setURL:(NSString *)stringURL;
-(void)cleanUp;
@end
