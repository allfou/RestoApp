//
//  LocationService.h
//  RestoApp
//
//  Created by Fouad Allaoui on 4/20/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationService : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong)NSString *location; // Shared current location in NSString format

+ (instancetype)sharedManager;

- (void)startUpdatingLocation;

- (NSString*)getCurrentLocation;

@end
