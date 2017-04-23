//
//  RestaurantCell.h
//  RestoApp
//
//  Created by Fouad Allaoui on 4/19/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "HCSStarRatingView.h"
#import "YLPCategory.h"

@interface RestaurantCell : UICollectionViewCell

// List View Attributes
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *stars;
@property (weak, nonatomic) IBOutlet UILabel *reviews;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *hours;

// Detail View Attributes
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *zip;

- (void)updateCellWithBusiness:(Restaurant*)restaurant withViewMode:(BOOL)isDetailMode;

@end
