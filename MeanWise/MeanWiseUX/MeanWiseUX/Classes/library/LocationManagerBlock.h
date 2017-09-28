//
//  LocationManagerBlock.h
//  VideoPlayerDemo
//
//  Created by Hardik on 11/08/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^currentLocation)(CLLocation *currentLocation);

@interface LocationManagerBlock : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;

}
@property (strong) currentLocation objBlock;

- (void)updateCurrentLocation:(currentLocation)completionBlock;
-(void)setUp;

@end
