//
//  LocationManagerBlock.m
//  VideoPlayerDemo
//
//  Created by Hardik on 11/08/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "LocationManagerBlock.h"
#import "FTIndicator.h"

@implementation LocationManagerBlock

- (void)updateCurrentLocation:(currentLocation)completionBlock {
    _objBlock = completionBlock;
}

-(void)setUp
{
    locationManager=[[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    locationManager.pausesLocationUpdatesAutomatically = TRUE;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    if (![CLLocationManager locationServicesEnabled])
    {
        
        NSLog(@"location services are disabled");
      //  return;
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        
        NSLog(@"location services are blocked by the user");
     //   return;
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        NSLog(@"location services are enabled");
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        NSLog(@"about to show a dialog requesting permission");
    }
    [locationManager startUpdatingLocation];

}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *currentLocation = [locations lastObject];
    NSString *longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    NSLog(@"%f", currentLocation.horizontalAccuracy);
    
    
    CLLocation *location = [locations lastObject];
    [locationManager stopUpdatingLocation];
    locationManager = nil;

    _objBlock(location);

}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{

    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        NSLog(@"User has denied location services");
    } else {
        
        NSLog(@"Location manager did fail with error: %@", error.localizedFailureReason);
    }
    _objBlock(nil);

}

@end
