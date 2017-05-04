//
//  LocationFilterView.h
//  VideoPlayerDemo
//
//  Created by Hardik on 02/04/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationFilterView : UIView <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    
    NSString *CPname; // eg. Apple Inc.
    NSString *CPthoroughfare; // street address, eg. 1 Infinite Loop
    NSString *CPsubThoroughfare; // eg. 1
    NSString *CPlocality; // city, eg. Cupertino
    NSString *CPsubLocality; // neighborhood, common name, eg. Mission District
    NSString *CPadministrativeArea; // state, eg. CA
    NSString *CPsubAdministrativeArea; // county, eg. Santa Clara
    NSString *CPpostalCode; // zip code, eg. 95014
    NSString *CPISOcountryCode; // eg. US
    NSString *CPcountry; // eg. United States
    NSString *CPinlandWater; // eg. Lake Tahoe
    NSString *CPocean; // eg. Pacific Ocean
    
    NSString *locationName;
    
 
    id target;
    SEL onLocationFail;
    
    BOOL isLocationReceived;
    int typeOfSticker;
}
-(void)setUp;
-(NSString *)locationPermissionCheck;
-(void)setTarget:(id)targetReceived onLocationFail:(SEL)func;

@end
