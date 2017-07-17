//
//  LocationStickerView.m
//  VideoPlayerDemo
//
//  Created by Hardik on 09/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "LocationStickerView.h"
#import "GUIScaleManager.h"
#import "UIColor+Hexadecimal.h"

@implementation LocationStickerView


-(void)setUpLocationSticker
{
    self.bounds=CGRectMake(0, 0, 40, 40);
    
    mainView=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:mainView];
    
    
    self.backgroundColor=[UIColor clearColor];
    label=[[UILabel alloc] initWithFrame:self.bounds];
    [mainView addSubview:label];
    mainView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    label.font=[UIFont fontWithName:@"Avenir-Roman" size:20];
    mainView.backgroundColor=[UIColor blueColor];
    label.textColor=[UIColor whiteColor];
    
    
    label.text=@"";
    [label sizeToFit];
    label.hidden=true;
    
    CGSize size=label.frame.size;
    CGRect rect=CGRectMake(0, 0, size.width+10, size.height+10);
    label.frame=rect;
    label.textAlignment=NSTextAlignmentCenter;
    
    
    mainView.bounds=rect;
    self.bounds=rect;
    
    type=0;
    
    [self requestForLocation];

    
    
}
-(void)requestForLocation
{
    
    locationManager=[[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    locationManager.activityType = CLActivityTypeFitness;
    locationManager.pausesLocationUpdatesAutomatically = TRUE;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    if (![CLLocationManager locationServicesEnabled])
    {
      //D  [self adjustLocationLabelPadding];
        
        NSLog(@"location services are disabled");
        return;
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        //D [self adjustLocationLabelPadding];
        
        NSLog(@"location services are blocked by the user");
        return;
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
    

    [self reverseGeocode:currentLocation];
    [locationManager stopUpdatingLocation];
    
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        NSLog(@"User has denied location services");
    } else {
        
        fulllocationString=@"";
        
        
        NSLog(@"Location manager did fail with error: %@", error.localizedFailureReason);
    }
}

- (void)reverseGeocode:(CLLocation *)location
{
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Finding address");
        
        if (error)
        {
            
            NSLog(@"Error %@", error.description);
            
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            
            CPadministrativeArea=placemark.administrativeArea;
            CPcountry=placemark.country;
            CPinlandWater=placemark.inlandWater;
            CPISOcountryCode=placemark.ISOcountryCode;
            CPlocality=placemark.locality;
            CPname=placemark.name;
            CPocean=placemark.ocean;
            CPsubAdministrativeArea=placemark.subAdministrativeArea;
            CPpostalCode=placemark.postalCode;
            CPsubLocality=placemark.subLocality;
            CPsubThoroughfare=placemark.subThoroughfare;
            CPthoroughfare=placemark.thoroughfare;
            
            
            
            if(CPISOcountryCode!=nil && CPname!=nil)
            {
                
                NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
                if ([CPname rangeOfCharacterFromSet:notDigits].location == NSNotFound)
                {
                    if(CPsubLocality!=nil)
                    {
                        fulllocationString=[[NSString stringWithFormat:@"%@, %@",CPsubLocality,CPISOcountryCode] uppercaseString];
                    }
                    else if(CPsubAdministrativeArea!=nil)
                    {
                        fulllocationString=[[NSString stringWithFormat:@"%@, %@",CPsubAdministrativeArea,CPISOcountryCode] uppercaseString];
                    }
                    
                    else if(CPlocality!=nil)
                    {
                        fulllocationString=[[NSString stringWithFormat:@"%@, %@",CPlocality,CPISOcountryCode] uppercaseString];
                    }
                    else if(CPadministrativeArea!=nil)
                    {
                        fulllocationString=[[NSString stringWithFormat:@"%@, %@",CPadministrativeArea,CPISOcountryCode] uppercaseString];
                    }
                    else
                    {
                        fulllocationString=[NSString stringWithFormat:@"%@",[CPcountry uppercaseString]];
                        
                    }
                    
                    
                }
                else
                {
                    fulllocationString=[[NSString stringWithFormat:@"%@, %@",CPname,CPISOcountryCode] uppercaseString];
                }
            }
            else
            {
                fulllocationString=[NSString stringWithFormat:@"%@",[CPname uppercaseString]];
            }
            
            [self resetWithAnimation:YES];
            
            //name,countrycode
            //
            
            
            
        }
    }];
}
-(void)setDeleteCallBack:(SEL)func
{
    onDeleteCallBack=func;
}
-(void)handlePanningWithPoint:(CGPoint)translatedCenter
{
    CGRect rect=RX_mainScreenBounds;

    if(translatedCenter.y>rect.size.height-80 && translatedCenter.x>rect.size.width/2-40 && translatedCenter.x<rect.size.width/2+40)
    {
        
        [UIView animateWithDuration:0.2 animations:^{
            mainView.alpha=0.5;
            mainView.transform=CGAffineTransformMakeScale(0.2, 0.2);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            mainView.alpha=1;
            mainView.transform=CGAffineTransformMakeScale(1, 1);
        }];
    }

    
}
-(void)objectDelete
{
    
    [delegate performSelector:onDeleteCallBack withObject:self afterDelay:0.01];
    
    
}
-(void)resetWithAnimation:(BOOL)animation
{
    
    
    if(fulllocationString==nil)
    {
        fulllocationString=@"Somewhere";
    }

    type++;
    if(type>4)
    {
        type=0;
    }
    

    /*
    @"Avenir-Black",
    @"Anton-Regular",
    @"TitilliumWeb-Regular",
    
    @"GillSans-SemiBold",
    
    @"AlfaSlabOne-Regular",
    @"Bahiana-Regular",
    @"Barrio-Regular",
    @"BungeeInline-Regular",
    @"Chewy",
    @"JustAnotherHand-Regular",
    @"Pacifico-Regular",
    @"Skranji-Bold",
     */
    
    if(type==0)
    {
        mainView.backgroundColor=[UIColor colorWithRed:37.0f/255.0f green:137.0f/255.0f blue:189.0f/255.0f alpha:0.9f];

        label.font=[UIFont fontWithName:@"TitilliumWeb-Regular" size:20];
        label.text=[NSString stringWithFormat:@"⦿ %@",fulllocationString];
        label.textColor=[UIColor whiteColor];

    }
    else if(type==1)
    {
        mainView.backgroundColor=[UIColor colorWithRed:255/255.0f green:27/255.0f blue:110.0f/255.0f alpha:0.9f];

        label.font=[UIFont fontWithName:@"AlfaSlabOne-Regular" size:20];
        label.text=[NSString stringWithFormat:@"⦿ %@",fulllocationString];
        label.textColor=[UIColor whiteColor];

        
    }
    else if(type==2)
    {
        mainView.backgroundColor=[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.9f];
        label.font=[UIFont fontWithName:@"TitilliumWeb-Regular" size:20];
        label.text=[NSString stringWithFormat:@"⦿ %@",fulllocationString];
        label.textColor=[UIColor blackColor];



    }
    else if(type==3)
    {
        mainView.backgroundColor=[UIColor colorWithRed:67/255.0f green:87/255.0f blue:173/255.0f alpha:0.9f];
        
        label.font=[UIFont fontWithName:@"Chewy" size:20];
        label.text=[NSString stringWithFormat:@"⦿ %@",fulllocationString];
        label.textColor=[UIColor whiteColor];
        
        
    }
    else
    {
        mainView.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.8f];
        
        label.font=[UIFont fontWithName:@"TitilliumWeb-Regular" size:20];
        label.text=[NSString stringWithFormat:@"⦿ %@",fulllocationString];
        label.textColor=[UIColor whiteColor];

        
    }
    

    
    label.hidden=false;
    [label sizeToFit];
    
    int paddingX=15;
    int paddingY=10;

    CGSize size=label.frame.size;
    
    
    
    CGRect rect=CGRectMake(paddingX/2, paddingY/2, size.width, size.height);
    
    label.frame=rect;
    label.textAlignment=NSTextAlignmentCenter;
    self.bounds=CGRectMake(0, 0, size.width+paddingX, size.height+paddingY);
    mainView.bounds=self.bounds;

    mainView.layer.cornerRadius=8;
    
    if(type==4)
    {
        label.textColor=[self gradientFromColor:[UIColor colorWithHexString:@"#08B2E3"] toColor:[UIColor colorWithHexString:@"#6761A8"] withHeight:mainView.bounds.size];
    }
    if(type==2)
    {
//        mainView.backgroundColor=[self gradientFromColor:[UIColor colorWithHexString:@"#c2c2c2"] toColor:[UIColor colorWithHexString:@"#F4F4F8"] withHeight:mainView.bounds.size];
    }
    if(type==0)
    {
        mainView.backgroundColor=[self gradientFromColor:[UIColor colorWithHexString:@"#AA78A6"] toColor:[UIColor colorWithHexString:@"#A0CFD3"] withHeight:mainView.bounds.size];
    }

 
    
   
    
}
-(UIColor*) gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray* colors = [NSArray arrayWithObjects:(id)c1.CGColor, (id)c2.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(size.width, size.height), 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

@end
