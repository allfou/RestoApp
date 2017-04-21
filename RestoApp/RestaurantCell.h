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

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *stars;
@property (weak, nonatomic) IBOutlet UILabel *reviews;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *hours;

- (void)updateCellWithBusiness:(Restaurant*)restaurant;

@end
