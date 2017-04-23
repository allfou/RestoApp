//
//  RestaurantCell.m
//  RestoApp
//
//  Created by Fouad Allaoui on 4/19/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import "RestaurantCell.h"

@implementation RestaurantCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    // Reset values for reusable cell
    self.imageView.image = nil;
    
    //self.name.text = @"";
    //self.type.text = @"";
    //self.reviews.text = @"";
    //self.hours.text = @"";
    //self.stars.value = 0.0f;
    
}

- (void)updateCellWithBusiness:(Restaurant*)restaurant withViewMode:(BOOL)isDetailMode {

    // If list View
    if (isDetailMode) {
        [self setDetailView:restaurant];
    // Detail View
    } else {
        [self setListView:restaurant];
    }
}

- (void)setListView:(Restaurant*)restaurant {
    // Name
    [self.name setText:restaurant.business.name];
    
    // Category
    [self.type setText:[[restaurant.business.categories firstObject] name]];
    
    // Total Reviews
    [self.reviews setText:[NSString stringWithFormat:@"%lu Reviews", (unsigned long)[restaurant.business reviewCount]]];
    
    // Is Open or Close
    if (restaurant.business.isClosed) {
        [self.hours setText:@"Closed"];
        [self.hours setBackgroundColor:[UIColor redColor]];
    } else {
        [self.hours setText:@"Open"];
        [self.hours setTintColor:[UIColor greenColor]];
    }
    
    // Rating
    self.stars.allowsHalfStars = YES;
    self.stars.accurateHalfStars = YES;
    self.stars.value = restaurant.business.rating;
    self.stars.shouldBeginGestureRecognizerBlock = nil;
    [self.stars setShouldBecomeFirstResponder:NO];
    [self.stars setUserInteractionEnabled:NO];
}

- (void)setDetailView:(Restaurant*)restaurant {
    // Address
    [self.address setText:restaurant.business.location.address[0]];
    
    // City
    [self.city setText:restaurant.business.location.city];
    
    // Zip + State
    [self.zip setText:[NSString stringWithFormat:@"%@, %@", restaurant.business.location.postalCode, restaurant.business.location.stateCode]];
    
    // Distance
    [self.distance setText:[NSString stringWithFormat:@"%.1f mi", [self convertMetersToMiles:restaurant.business.distance]]];
    
    // Price
    [self.price setText:restaurant.business.price];
}

// ****************************************************************************************************************

#pragma mark - Util

- (double)convertMetersToMiles:(double)meters {
    
    return meters * 0.000621371192;
}

@end
