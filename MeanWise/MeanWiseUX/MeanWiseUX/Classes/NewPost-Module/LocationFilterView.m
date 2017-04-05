//
//  LocationFilterView.m
//  VideoPlayerDemo
//
//  Created by Hardik on 02/04/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "LocationFilterView.h"

@implementation LocationFilterView

-(void)setTarget:(id)targetReceived onLocationFail:(SEL)func
{
    target=targetReceived;
    onLocationFail=func;
}
-(void)setUp
{
    isLocationReceived=false;
    typeOfSticker=0;
    locationManager=nil;

    NSString *msg=[self locationPermissionCheck];
    
    if([msg isEqualToString:@""])
    {
        [self requestForLocation];
    }
    else
    {
        [self closeWithMessage:msg];
    }
    
}
-(void)closeWithMessage:(NSString *)msg
{

    [target performSelector:onLocationFail withObject:msg afterDelay:0.01];
    
    [self removeFromSuperview];

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
    
    
    [locationManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [locationManager stopUpdatingLocation];

    CLLocation *currentLocation = [locations lastObject];
   // NSString *longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
   // NSString *latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    NSLog(@"%f", currentLocation.horizontalAccuracy);
    [self reverseGeocode:currentLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locationManager stopUpdatingLocation];

    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){

        [self closeWithMessage:@"Turning on Location services will allow you to use this feature."];


        
    } else {
        
        locationName=@"";

        NSLog(@"Location manager did fail with error: %@", error.localizedFailureReason);
        
        [self closeWithMessage:@"Could not able to locate."];


    }
}

- (void)reverseGeocode:(CLLocation *)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Finding address");
        
        if (error)
        {
            [self closeWithMessage:@"Could not able to locate."];

            NSLog(@"Error %@", error.description);
            
        } else
        {
            CLPlacemark *placemark = [placemarks lastObject];
            [self locationParse:placemark];
            
            
            
        }
    }];
}
-(void)locationParse:(CLPlacemark *)placemark
{
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
               locationName=[[NSString stringWithFormat:@"%@, %@",CPsubLocality,CPISOcountryCode] uppercaseString];
            }
            else if(CPsubAdministrativeArea!=nil)
            {
                locationName=[[NSString stringWithFormat:@"%@, %@",CPsubAdministrativeArea,CPISOcountryCode] uppercaseString];
            }
            
            else if(CPlocality!=nil)
            {
                locationName=[[NSString stringWithFormat:@"%@, %@",CPlocality,CPISOcountryCode] uppercaseString];
            }
            else if(CPadministrativeArea!=nil)
            {
                locationName=[[NSString stringWithFormat:@"%@, %@",CPadministrativeArea,CPISOcountryCode] uppercaseString];
            }
            else
            {
                locationName=[NSString stringWithFormat:@"%@",[CPcountry uppercaseString]];
                
            }
            
            
        }
        else
        {
            locationName=[[NSString stringWithFormat:@"%@, %@",CPname,CPISOcountryCode] uppercaseString];
        }
    }
    else
    {
        locationName=[NSString stringWithFormat:@"%@",[CPname uppercaseString]];
    }
    isLocationReceived=true;
    
   
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateStickerUI];
    });
    

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    typeOfSticker++;
    [self updateStickerUI];
}
-(void)updateStickerUI
{
    
    NSArray *viewsToRemove = [self subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }

    typeOfSticker=typeOfSticker%4;
    
    
    CGRect bgRect=CGRectMake(0, 0, 100, 100);
   
   
    if(typeOfSticker==3)
    {
        UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self addSubview:bgView];
        
        
        
        //        bgView.backgroundColor=[Constant
        
        UILabel *locationLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        locationLabel.textAlignment=NSTextAlignmentLeft;
        locationLabel.textColor=[UIColor whiteColor];
        locationLabel.text=[locationName capitalizedString];
        locationLabel.font=[UIFont fontWithName:@"BradleyHandITCTT-Bold" size:25];
        [locationLabel sizeToFit];
        locationLabel.layer.shadowColor=[UIColor blackColor].CGColor;
        locationLabel.layer.shadowOffset=CGSizeMake(0, 0);
        locationLabel.layer.shadowOpacity=0.7;
        locationLabel.layer.shadowRadius=4;
        
        
        
        CGSize size=[locationLabel frame].size;
        
        int padding=size.height;
        
        
        bgView.frame=CGRectMake(0, 0, size.width+20+padding, size.height+10);
        locationLabel.frame=CGRectMake(padding+10, 5, size.width, size.height);
        
        bgRect=bgView.frame;
        
        [bgView addSubview:locationLabel];
        
        CGSize mainSize=[[UIScreen mainScreen] bounds].size;
        
        self.frame=bgRect;
        self.frame=CGRectMake(mainSize.width-bgRect.size.width, mainSize.height*0.7, bgRect.size.width, bgRect.size.height);
        
        
    }
    if(typeOfSticker==0)
    {
        UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self addSubview:bgView];


        
//        bgView.backgroundColor=[Constant
        
        UILabel *locationLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        locationLabel.textAlignment=NSTextAlignmentLeft;
        locationLabel.textColor=[UIColor whiteColor];
        locationLabel.text=locationName;
        locationLabel.font=[UIFont fontWithName:@"DINAlternate-Bold" size:15];
        [locationLabel sizeToFit];

        
        CGSize size=[locationLabel frame].size;

        int padding=size.height;

        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, padding, padding)];
        imageView.image=[UIImage imageNamed:@"locationMarkIcon.png"];
        
        bgView.frame=CGRectMake(0, 0, size.width+20+padding, size.height+10);
        locationLabel.frame=CGRectMake(padding+10, 5, size.width, size.height);
        
        bgView.clipsToBounds=YES;
        bgView.layer.cornerRadius=(padding+10)/2;
        bgRect=bgView.frame;
        
        [Constant setUpGradient:bgView style:201];
        [bgView addSubview:locationLabel];
        [bgView addSubview:imageView];

        CGSize mainSize=[[UIScreen mainScreen] bounds].size;
        
        self.frame=bgRect;
        self.frame=CGRectMake(mainSize.width-bgRect.size.width, mainSize.height*0.7, bgRect.size.width, bgRect.size.height);
        

    }
    if(typeOfSticker==1)
    {
        UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self addSubview:bgView];

        
        UILabel *locationLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        locationLabel.textAlignment=NSTextAlignmentLeft;
        locationLabel.textColor=[UIColor whiteColor];
        locationLabel.text=[self getTimeWithFormat:0];
        locationLabel.font=[UIFont fontWithName:@"DINAlternate-Bold" size:15];
        [locationLabel sizeToFit];
        
        
        CGSize size=[locationLabel frame].size;
        
        int padding=size.height;
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, padding, padding)];
        imageView.image=[UIImage imageNamed:@"timeMarkIcon.png"];
        
        bgView.frame=CGRectMake(0, 0, size.width+20+padding, size.height+10);
        locationLabel.frame=CGRectMake(padding+10, 5, size.width, size.height);
        
        
        bgView.clipsToBounds=YES;
        bgView.layer.cornerRadius=(padding+10)/2;
        bgRect=bgView.frame;

        
        [Constant setUpGradient:bgView style:201];
        [bgView addSubview:locationLabel];
        [bgView addSubview:imageView];

        
        //bgView.layer.cornerRadius=(padding+10)/2;

        CGSize mainSize=[[UIScreen mainScreen] bounds].size;
        
        self.frame=bgRect;
        self.frame=CGRectMake(mainSize.width-bgRect.size.width, mainSize.height*0.7, bgRect.size.width, bgRect.size.height);
        

    }
    if(typeOfSticker==2)
    {
        UIView *bgView1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self addSubview:bgView1];
        bgView1.backgroundColor=[UIColor blackColor];
        
        UIView *bgView2=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self addSubview:bgView2];
        bgView2.backgroundColor=[UIColor blackColor];
        
        UILabel *timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        timeLabel.textAlignment=NSTextAlignmentLeft;
        timeLabel.textColor=[UIColor whiteColor];
        timeLabel.text=[self getTimeWithFormat:0];
        timeLabel.font=[UIFont fontWithName:@"DINAlternate-Bold" size:15];
        [timeLabel sizeToFit];

        
        UILabel *locationLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        locationLabel.textAlignment=NSTextAlignmentLeft;
        locationLabel.textColor=[UIColor whiteColor];
        locationLabel.text=locationName;
        locationLabel.font=[UIFont fontWithName:@"DINAlternate-Bold" size:15];
        [locationLabel sizeToFit];

        
        
      
        
        CGSize size1=[timeLabel frame].size;
        int padding1=size1.height;
        UIImageView *imageView1=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, padding1, padding1)];
        imageView1.image=[UIImage imageNamed:@"timeMarkIcon.png"];
        timeLabel.frame=CGRectMake(padding1+10, 5, size1.width, size1.height);
        bgView1.frame=CGRectMake(0, 0, size1.width+20+padding1, size1.height+10);
        bgView1.clipsToBounds=YES;
        bgView1.layer.cornerRadius=(padding1+10)/2;
      

        CGSize size2=[locationLabel frame].size;
        int padding2=size2.height;
        UIImageView *imageView2=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, padding2, padding2)];
        imageView2.image=[UIImage imageNamed:@"locationMarkIcon.png"];
        locationLabel.frame=CGRectMake(padding2+10, 5, size2.width, size2.height);
        bgView2.frame=CGRectMake(0, 0, size2.width+20+padding2, size2.height+10);
        bgView2.clipsToBounds=YES;
        bgView2.layer.cornerRadius=(padding2+10)/2;
        
      
        CGRect containerRect=CGRectMake(0, 0, bgView2.frame.size.width, bgView1.frame.size.height+bgView2.frame.size.height);
        
        bgView1.frame=CGRectMake(containerRect.size.width-bgView1.frame.size.width, 0, bgView1.frame.size.width, bgView1.frame.size.height);
        bgView2.frame=CGRectMake(containerRect.size.width-bgView2.frame.size.width, bgView1.frame.size.height, bgView2.frame.size.width, bgView2.frame.size.height);
        
        [Constant setUpGradient:bgView1 style:201];
        [Constant setUpGradient:bgView2 style:201];

        [bgView2 addSubview:imageView2];
        [bgView1 addSubview:imageView1];
        [bgView2 addSubview:locationLabel];
        [bgView1 addSubview:timeLabel];

        
        CGSize mainSize=[[UIScreen mainScreen] bounds].size;
        self.frame=containerRect;
        self.frame=CGRectMake(mainSize.width-containerRect.size.width, mainSize.height*0.7, containerRect.size.width, containerRect.size.height);
        

    }
    
    
    
}

-(NSString *)locationPermissionCheck
{
    NSString *statusMessage=@"";
    
    if (![CLLocationManager locationServicesEnabled])
    {

        statusMessage=@"Turning on Location services will allow you to use this feature.";
        NSLog(@"location services are disabled");
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        
        statusMessage=@"Turning on Location services will allow you to use this feature.";
        
        NSLog(@"location services are blocked by the user");
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        statusMessage=@"";
        
        NSLog(@"location services are enabled");
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
    }
    
    return statusMessage;
    
}
-(NSString *)getTimeWithFormat:(int)no
{
    NSDate *localDate = [NSDate date];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"h:mm a";
    
    
    NSString *dateString = [timeFormatter stringFromDate: localDate];
    return dateString;
    
}
@end
