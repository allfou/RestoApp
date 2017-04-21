//
//  YelpService.h
//  RestoApp
//
//  Created by Fouad Allaoui on 4/19/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RestaurantCell.h"
#import "ReviewCell.h"
#import "YLPBusiness.h"
#import "YLPSearch.h"
#import "YLPReview.h"
#import "YLPCoordinate.h"
#import "YLPSortType.h"
#import "YLPBusinessReviews.h"
#import "YLPClient+Search.h"
#import "YLPClient+Reviews.h"
#import "YLPClient+Business.h"
#import "YLPResponsePrivate.h"

@interface YelpService : NSObject

+ (instancetype)sharedManager;

- (void)getNearByRestaurantsForLocation:(NSString*)location;

- (void)getReviewsForBusiness:(NSString*)businessId;

- (void)downloadImageFromUrl:(NSURL*)imageUrl forCell:(RestaurantCell*)cell;

- (void)downloadUserAvatarFromUrl:(YLPReview*)review forCell:(ReviewCell*)cell;

@end
