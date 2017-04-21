//
//  RestaurantDetailViewController.h
//  RestoApp
//
//  Created by Fouad Allaoui on 4/19/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HCSStarRatingView.h"
#import "Restaurant.h"

@interface RestaurantDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>

@property Restaurant *restaurant;

@end
