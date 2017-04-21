//
//  YelpService.m
//  RestoApp
//
//  Created by Fouad Allaoui on 4/19/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//
//  Yelp API V3 Documentation - https://www.yelp.com/developers/documentation/v3/

#import "YelpService.h"
#import "YLPClient+Search.h"
#import "YLPClient+Reviews.h"
#import "YLPSortType.h"
#import "YLPSearch.h"
#import "Restaurant.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "LocationService.h"

@interface YelpService ()

@property (nonatomic) NSMutableArray *restaurants;  // List of restaurants
@property (nonatomic) YLPSearch *result; // List of businesses
@property (nonatomic) NSCache *cache;        // Cache (key=restaurant_id, value=list<reviews>)

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, strong) LocationService *locationService;

@end

@implementation YelpService

+ (instancetype)sharedManager {
    static YelpService *sharedYelpService = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedYelpService = [[self alloc]init];
    });
    
    return sharedYelpService;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Init Cache
        self.cache = [NSCache new];
        
        // Init List of Near by Restaurants
        self.restaurants = [NSMutableArray new];
        
        // Init Location Service
        self.locationService = [[LocationService sharedManager]init];
    }
    
    return self;
}

- (void)getNearByRestaurantsForCurrentLocation {
    [self.locationManager startUpdatingLocation];
}

- (void)getNearByRestaurantsForLocation:(NSString*)location {
    [[AppDelegate sharedYelpClient] searchWithLocation:location term:@"Restaurant" limit:50 offset:0 sort:YLPSortTypeDistance completionHandler:^
     (YLPSearch *search, NSError* error) {
         self.result = search;
         [self refreshRestaurantList];
     }];
}

- (void)getReviewsForBusiness:(int)nbReviews withId:(NSString*)businessId {
    [[AppDelegate sharedYelpClient]reviewsForBusinessWithId:businessId completionHandler:^
     (YLPBusinessReviews *reviews, NSError *error) {
         [self.cache setObject:reviews forKey:businessId];
     }];
}

- (void)refreshRestaurantList {
    [self.restaurants removeAllObjects];
    
    for (YLPBusiness *business in self.result.businesses) {
        Restaurant *restaurant = [Restaurant new];
        [restaurant setBusiness:business];
        [self.restaurants addObject:restaurant];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshRestaurantListMessageEvent" object:self.restaurants];
}

- (void)loadMoreRestaurants {
    // TODO
}

- (void)downloadImageFromUrl:(NSURL*)imageUrl forCell:(RestaurantCell*)cell {

    NSURLRequest *request = [NSURLRequest requestWithURL:imageUrl];
    UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
        
    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       cell.imageView.image = image;
                                       [cell setNeedsLayout];
                                   } failure:nil];
}

@end
