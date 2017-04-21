//
//  LocationService.m
//  RestoApp
//
//  Created by Fouad Allaoui on 4/20/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import "LocationService.h"

@interface LocationService ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@end

@implementation LocationService

+ (instancetype)sharedManager {
    
    static LocationService* sharedManager;
    
    if(!sharedManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[self alloc] init];
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
        self.locationManager.distanceFilter = 10.0; // Will notify the LocationManager every 10 meters
        //locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
        }
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
            //[[YelpService sharedManager] getNearByRestaurantsForLocation:self.location];
            
            // Post Updated Current Location Notification to Restaurant View Controller
            [[NSNotificationCenter defaultCenter] postNotificationName:@"currentLocationUpdatedMessageEvent" object:self.location];
        }
        else {
            NSLog(@"Geocode failed with error %@", error);
            NSLog(@"\nCurrent Location Not Detected\n");
        }
    }];
}

- (void)startUpdatingLocation {
    [self.locationManager startUpdatingLocation];
}

- (NSString*)getCurrentLocation {
    return self.location;
}

@end
