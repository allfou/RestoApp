//
//  LocationService.h
//  RestoApp
//
//  Created by Fouad Allaoui on 4/20/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationService : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong)CLLocationManager* locationManager;
@property (nonatomic, strong)NSString *location; // Shared current location in NSString format

+ (instancetype)sharedManager;

- (NSString*)getCurrentLocation;

@end
