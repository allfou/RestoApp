//
//  LocationService.m
//  RestoApp
//
//  Created by Fouad Allaoui on 4/20/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import "LocationService.h"
#import "YelpService.h"

@interface LocationService ()

@property (nonatomic, strong) CLLocation *currentLocation; // Private current location of CLLocation type

@end

@implementation LocationService

+ (instancetype)sharedManager {
    static LocationService* sharedManager;
    if(!sharedManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [LocationService new];
        });
    }
    
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    
    if(self) {
        // Init Location Manager
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentLocation = [locations objectAtIndex:0];
    [self.locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!(error)) {
            
            // Get Current Location
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            self.location = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.administrativeArea];
            NSLog(@"Current Location Update = %@", self.location);
            
            // Update List of Restaurant at Location
            [[YelpService sharedManager] getNearByRestaurantsForLocation:self.location];
        }
        else {
            NSLog(@"Geocode failed with error %@", error);
            NSLog(@"\nCurrent Location Not Detected\n");
        }
    }];
}

- (NSString*)getCurrentLocation {
    return self.location;
}

@end
