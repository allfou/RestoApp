//
//  DetailViewController.m
//  RestoApp
//
//  Created by Fouad Allaoui on 4/19/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import "DetailViewController.h"
#import "LocationService.h"
#import "YelpService.h"
#import "YLPCoordinate.h"
#import "YLPReview.h"
#import "YLPBusiness.h"
#import "YLPBusinessReviews.h"
#import "YLPClient+Search.h"
#import "YLPClient+Reviews.h"
#import "YLPClient+Business.h"
#import "YLPResponsePrivate.h"
#import "AppDelegate.h"
#import "ReviewCell.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *rating;
@property (weak, nonatomic) IBOutlet UILabel *hours;
@property (weak, nonatomic) IBOutlet UILabel *totalReviews;
@property (weak, nonatomic) IBOutlet UILabel *openOrClose;

@property NSArray<YLPReview *> *reviews;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Init Table View
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ReviewRestaurantCell" bundle:nil] forCellReuseIdentifier:@"reviewCell"];
    
    // Init Data
    self.reviews = [NSArray<YLPReview *> new];
    
    // Init Map View
    self.mapView.showsUserLocation = YES;
    //self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    
    // Init Restaurant details
    [self.name setText:self.restaurant.business.name];
    [self.totalReviews setText:[NSString stringWithFormat:@"%lu Reviews", (unsigned long)[self.restaurant.business reviewCount]]];
    if (self.restaurant.business.isClosed) {
        [self.hours setText:@"Closed"];
        [self.hours setBackgroundColor:[UIColor redColor]];
    } else {
        [self.hours setText:@"Open"];
        [self.hours setTintColor:[UIColor greenColor]];
    }
    self.rating.allowsHalfStars = YES;
    self.rating.accurateHalfStars = YES;
    self.rating.value = self.restaurant.business.rating;
    self.rating.shouldBeginGestureRecognizerBlock = nil;
    [self.rating setShouldBecomeFirstResponder:NO];
    [self.rating setUserInteractionEnabled:NO];
    
    // Init Restaurant Reviews
    [self getRestaurantReviews];
    
    // Init Restaurant Location
    [self getRestaurantLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// **************************************************************************************************

#pragma mark Data

- (void)getRestaurantReviews {
    [[AppDelegate sharedYelpClient] reviewsForBusinessWithId:self.restaurant.business.identifier completionHandler:^
     (YLPBusinessReviews *reviews, NSError *error) {
         NSLog(@"%@", reviews);
         self.reviews = reviews.reviews;
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
         });
     }];
}

- (void)getRestaurantLocation {
     MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
     CLLocationCoordinate2D pinCoordinate;
     pinCoordinate.latitude = self.restaurant.business.location.coordinate.latitude;
     pinCoordinate.longitude = self.restaurant.business.location.coordinate.longitude;
     myAnnotation.coordinate = pinCoordinate;
     myAnnotation.title = self.restaurant.business.name;
     
     dispatch_async(dispatch_get_main_queue(), ^{
         MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:pinCoordinate fromEyeCoordinate:CLLocationCoordinate2DMake(pinCoordinate.latitude, pinCoordinate.longitude) eyeAltitude:10000];
         [self.mapView setCamera:camera];
         [self.mapView addAnnotation:myAnnotation];
     });
}

// **************************************************************************************************

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.reviews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReviewCell *cell = (ReviewCell*) [self.tableView dequeueReusableCellWithIdentifier:@"reviewCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [ReviewCell new];
    }
    
    [cell updateCellWithReview:self.reviews[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115.0f;
}

@end
