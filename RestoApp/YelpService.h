//
//  YelpService.h
//  RestoApp
//
//  Created by Fouad Allaoui on 4/19/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YLPBusiness.h"
#import "RestaurantCell.h"

@interface YelpService : NSObject

+ (instancetype)sharedManager;

- (void)getNearByRestaurantsForCurrentLocation;

- (void)getNearByRestaurantsForLocation:(NSString*)location;

- (void)getReviewsForBusiness:(int)nbReviews withId:(NSString*)businessId;

- (void)downloadImageFromUrl:(NSURL*)imageUrl forCell:(RestaurantCell*)cell;

@end
