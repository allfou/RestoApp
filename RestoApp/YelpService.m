//
//  YelpService.m
//  RestoApp
//
//  Created by Fouad Allaoui on 4/19/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//
//  Yelp API V3 Documentation - https://www.yelp.com/developers/documentation/v3/

#import "YelpService.h"
#import "Restaurant.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"

@interface YelpService ()

@property (nonatomic) NSMutableArray *restaurants;  // List of restaurants
@property (nonatomic) YLPSearch *result; // List of businesses
@property (nonatomic) NSCache *cache;  // Cache for Reviews (key=restaurant_id, value=list<reviews>)

@end

@implementation YelpService

+ (instancetype)sharedManager {
    static YelpService *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc]init];
    });
    
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Init Cache
        self.cache = [NSCache new];
        
        // Init List of Near by Restaurants
        self.restaurants = [NSMutableArray new];
    }
    
    return self;
}

- (void)getNearByRestaurantsForLocation:(NSString*)location withFood:(NSString*)food sortedBy:(NSString*)sortedBy {
    NSString *terms = [NSString stringWithFormat:@"Restaurant %@", food];
    
    [[AppDelegate sharedYelpClient] searchWithLocation:location term:terms limit:50 offset:0 sort:[self getSortedType:sortedBy] completionHandler:^
     (YLPSearch *search, NSError* error) {
         self.result = search;
         [self refreshRestaurantList];
     }];
}

- (void)getReviewsForBusiness:(NSString*)businessId {
    
    // Check if reviews for given business are already cached
    if ([self.cache objectForKey:businessId]) {
        // Post Review Refresh Notification to Detail View Controller
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshReviewsMessageEvent" object:[self.cache objectForKey:businessId]];
    }
    
    // Else download reviews for business
    else {
        [[AppDelegate sharedYelpClient]reviewsForBusinessWithId:businessId completionHandler:^
         (YLPBusinessReviews *reviews, NSError *error) {
             // Post Review Refresh Notification to Detail View Controller
             [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshReviewsMessageEvent" object:reviews];
             
             // Update cache
             if (reviews) {
                 [self.cache setObject:reviews forKey:businessId];
             }
         }];
    }
}

- (void)refreshRestaurantList {
    [self.restaurants removeAllObjects];
    
    for (YLPBusiness *business in self.result.businesses) {
        Restaurant *restaurant = [Restaurant new];
        [restaurant setBusiness:business];
        [self.restaurants addObject:restaurant];
    }
    
    // Post Refresh Notification to Restaurant View Controller
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
                                       //cell.imageView.image = image;
                                       //[cell setNeedsLayout];
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           cell.imageView.alpha = 0.0f;
                                           cell.imageView.image = image;
                                           [UIView animateWithDuration:0.5f animations:^{
                                               cell.imageView.alpha = 1.0f;
                                               [cell setNeedsLayout];
                                           }];
                                       });                                       
                                   } failure:nil];
}

- (void)downloadUserAvatarFromUrl:(YLPReview*)review forCell:(ReviewCell*)cell {
    NSURLRequest *request = [NSURLRequest requestWithURL:review.user.imageURL];
    UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];

    [cell.userImage setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       cell.userImage.image = image;
                                       [cell setNeedsLayout];
                                   } failure:nil];

}

- (YLPSortType)getSortedType:(NSString*)type {
    // Switch case on NSString
    __block YLPSortType sortedType;
    typedef void (^CaseBlock)();
    NSDictionary *d = @{
                        @"Best Match":     ^{ sortedType = YLPSortTypeBestMatched; },
                        @"Distance":       ^{ sortedType = YLPSortTypeDistance; },
                        @"Highest Rated":  ^{ sortedType = YLPSortTypeHighestRated; },
                        @"Most Reviewed":  ^{ sortedType = YLPSortTypeMostReviewed; }
                        };
    ((CaseBlock)d[type])();
    
    return sortedType;
}

@end
